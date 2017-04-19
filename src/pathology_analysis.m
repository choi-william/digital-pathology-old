function [ output_args ] = pathology_analysis()
%INTERFACE Summary of this function goes here
%   Detailed explanation goes here

    parpool;
    
    resultsPath = '../results';
    
    
    %%% - PROMPT USER FOR BRAIN SLIDE PATH
    
    %%% - USE SHAHRIARS PART TO GET ALL SLIDE INFO
    
    %%% - USE SLIDE INFO BELOW

    filePath = strcat([resultsPath , '/DP_Slide.mat']);
    load(filePath);
    
    sizeDPslide = size(DPslide,2);
    
    blockSize = 128; % size of each image subblock, change to 128 when new data is available
    
    topleft = DPslide(1).Pos{1};
    bottomright = DPslide(sizeDPslide).Pos{2};
    
    numcols = (bottomright(1) - topleft(1)+1)/blockSize;
    numrows = (bottomright(2) - topleft(2)+1)/blockSize;
    
%   image = reshape(DPslide,[numrows, numcols]);
    
    slide = zeros(numrows,numcols);
    outputData1 = -1*ones(numrows*numcols,1);
    outputData2 = -1*ones(numrows*numcols,1);
    
    status = zeros(numrows*numcols,1);

    %necessary for displaying count due to parallel nature
    b = 0;
    for linInd=1:(numcols*numrows)
        if DPslide(linInd).Label == 1
            b = b+1;
            status(linInd) = b;
        end
    end
    total = sum(status~=0);

    tic
    parfor linInd=1:(numcols*numrows)   
        %j = ceil(linInd/numcols);
        %i = mod(linInd-1,numcol)+1;

        slide(linInd) = DPslide(linInd).Label;

        if slide(linInd) == -99
            slide(linInd) = -1;
        end

        if slide(linInd) == 0
            outputData1(linInd)=0;
            outputData2(linInd)=0;
        end

        if (slide(linInd) == 1)
            filename = [resultsPath '/BlockImg' '/' num2str(linInd) '.tif'];            
            im = DPImage('real',filename);
            [cell_count, average_fractal] = block_analysis( im, 0 );
            outputData1(linInd) = cell_count;
            outputData2(linInd) = 1+10*average_fractal;
            
            fprintf('%d out of %d\n',status(linInd),total);
        end
    end
    toc
    
    delete(gcp);
    
    outputData1 = reshape(outputData1,[numrows, numcols]);
    outputData2 = reshape(outputData2,[numrows, numcols]);
    
    imagesc(outputData1);
    title('cell count');
    
    imagesc(outputData2);
    title('average fractal');
end

