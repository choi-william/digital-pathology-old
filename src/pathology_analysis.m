function [] = pathology_analysis(analysis_type, imagePath, outPath)
%INTERFACE Summary of this function goes here
%   Detailed explanation goes here
    
    if(isempty(imagePath))
        [f,p] = uigetfile('*','Select the .svs image file');
        imagePath = strcat(p,f);
    end
    
    global out_path;
    if(isempty(outPath))
        out_path = uigetdir('','Choose output data destination');
    else
        out_path = outPath;
    end
    
    ROI.roi_finder( imagePath, out_path );
    
    filePath = strcat([out_path , '/DP_Slide.mat']);
    load(filePath);
    
    sizeDPslide = size(DPslide,2);
    
    blockSize = 256; % size of each image subblock, change to 128 when new data is available
    
    topleft = DPslide(1).Pos{1};
    bottomright = DPslide(sizeDPslide).Pos{2};
    
    numcols = (bottomright(1) - topleft(1)+1)/blockSize;
    numrows = (bottomright(2) - topleft(2)+1)/blockSize;
    
%   image = reshape(DPslide,[numrows, numcols]);
    
    slide = zeros(numrows,numcols);
    outputData1 = -1*ones(numrows*numcols,1);
    outputData2 = -1*ones(numrows*numcols,1);
    
    status = zeros(numrows*numcols,1);

    parpool;
    

    %necessary for displaying count due to parallel nature
    b = 0;
    for linInd=1:(numcols*numrows)
        if DPslide(linInd).Label == 1
            b = b+1;
            status(linInd) = b;
        end
    end
    total = sum(status~=0)
    
    tic
    brainSlide = imread(imagePath);
    parfor linInd=1:(numcols*numrows)   
        %j = ceil(linInd/numcols);
        %i = mod(linInd-1,numcol)+1;

        slide(linInd) = DPslide(linInd).Label;

        if slide(linInd) == -99
            outputData1(linInd) = -2;
            outputData2(linInd) = -2;
        end

        if slide(linInd) == 0
            outputData1(linInd)=-1;
            outputData2(linInd)=-1;
        end

        if (slide(linInd) == 1)
%             filename = [out_path '/BlockImg' '/' num2str(linInd) '.tif'];
%             im=DPImage('real',filename);
            im = DPImage('notAFile');
            im.image = imcrop(brainSlide,[DPslide(linInd).Pos{1}(1), DPslide(linInd).Pos{1}(2),... 
                DPslide(linInd).Pos{2}(1)-DPslide(linInd).Pos{1}(1), DPslide(linInd).Pos{2}(2)-DPslide(linInd).Pos{1}(2)]);
            [cell_count, average_fractal] = block_analysis( im, analysis_type, 0 );
            outputData1(linInd) = cell_count;
            outputData2(linInd) = average_fractal;
            
            fprintf('%d out of %d\n',status(linInd),total);
        end
    end
    toc
    
    delete(gcp);
    
    outputData1 = reshape(outputData1,[numrows, numcols]);
    outputData2 = reshape(outputData2,[numrows, numcols]);
    
    %path hardcoded at the moment TODO
    vis_path = strcat([out_path , '/visualization.mat']);
    save(vis_path,'outputData1','outputData2');
    
    imagesc(outputData1);
    title('cell count');
    
    imagesc(outputData2);
    title('average fractal');
end

