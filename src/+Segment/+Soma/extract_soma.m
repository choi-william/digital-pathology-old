% 
% dpimage - image object
% alg - algorithm type parameter. 0 for opening and closing by
% reconstruction. 1 for mumford-shah.
%
function [list,dp] = extract_soma( dpimage, alg , th, lsb )
    if alg == 0
        %EXTRACTSOMA Summary of this function goes here
        %   Detailed explanation goes here

        % converting image to grayscale
        %grayIm = rgb2gray(dpimage.image);
        grayIm = dpimage.image;
        grayIm = grayIm(:,:,3);
        %grayIm = imadjust(grayIm);
        %adjusted = imadjust(grayIm,[0; 0.5],[0; 1]);
        %adjusted = imsharpen(adjusted);

        adjusted = grayIm + (255-mean(grayIm(:)));
        %figure, imshow(adjusted);

        % open and close by reconstruction

        Iobrcbr = Tools.smooth_ocbrc(adjusted,2);
        dpimage.preThresh = Iobrcbr;

        %THRESHOLD RESULT%
        somaIm = imbinarize(Iobrcbr,th);
        
        dpimage.rawThresh = somaIm;

        %Filter Image
        somaIm = Helper.sizeFilter(somaIm,lsb,100000000);

    elseif alg == 1
        input_image = dpimage.image;
        
        % Converting image to grayscale, increasing contrast.
        grayIm = rgb2gray(input_image);
%         grayIm = input_image(:,:,1);
        grayIm = imadjust(grayIm);
        grayIm = imsharpen(grayIm);
        
        % Mumford-Shah smoothing
        mumfordIm = smooth_ms(grayIm, 0.6, 300);
%         figure, imshow(mumfordIm);

        % Global Thresholding 
        bwIm = imbinarize(mumfordIm, 0.3);
        
        dpimage.preThresh = mumfordIm;
        dpimage.rawThresh = bwIm;

        % Filtering by object size
        somaIm = Helper.sizeFilter(bwIm,lsb, 3000);

        % Resulting binary image of the soma
%         figure, imshow(somaIm);

        % Soma image overlayed with the original grayscale image
        finalIm = imoverlay(grayIm, imcomplement(somaIm),'yellow');
%         figure, imshow(finalIm);
% 
%         figure;
%         subplot(2,2,1), imshow(input_image);
%         subplot(2,2,2), imshow(mumfordIm);
%         subplot(2,2,3), imshow(bwIm);
%         subplot(2,2,4), imshow(finalIm);
        
    elseif alg == 2
        
        grayIm = rgb2gray(dpimage.image);
        adjusted = grayIm + (255-mean(grayIm(:)));
        manipulated = Tools.smooth_mt(adjusted,10);
        dpimage.preThresh = manipulated; 
        
        %THRESHOLD RESULT%
        somaIm = imbinarize(manipulated,th);
        
        dpimage.rawThresh = somaIm;

        %Filter Image
        somaIm = Helper.sizeFilter(somaIm,lsb,100000);
    else
        error('Incorrect Parameter: Specify 0 or 1 or 2 for the alg parameter.');
    end
    
    dpimage.somaMask = somaIm;
    comp = bwconncomp(imcomplement(somaIm));
    %figure, imshow(somaIm);

    % Load classifier

    file = load('+ML/classifier_asma_2.mat'); %TODO load only once
    classifier = file.classifier;

    list = {};
    for i=1:comp.NumObjects
        [row,col] = ind2sub(comp.ImageSize,comp.PixelIdxList{i});
        
        prepared = prepare_soma(DPCell([col,row],dpimage)); 
        for j=1:size(prepared,2)
            dpcell = prepared{j};            
%             if (predict_valid(classifier,dpcell))
%                 list{end+1} = dpcell;
%             end
            
            %UNCOMMENT IF THIS STEP SHOULD BE VISUALIZED            
            if (~predict_valid(classifier,dpcell))
                dpcell.isFalsePositive = 1;
            end
            list{end+1} = dpcell;

        end
    end    
    dp = dpimage;
end

