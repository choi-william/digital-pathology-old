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
        grayIm = rgb2gray(dpimage.image);
        grayIm = imadjust(grayIm);
        adjusted = imadjust(grayIm,[0; 0.5],[0; 1]);

        % open and close by reconstruction
        Iobrcbr = smooth_ocbrc(adjusted,2);
        dpimage.intermediate = Iobrcbr;
        
        %THRESHOLD RESULT%
        somaIm = imbinarize(Iobrcbr,th);
        
        %Filter Image
        somaIm = sizeFilter(somaIm,lsb,1500);
        
    elseif alg == 1
        input_image = dpimage.image;
        
        % Converting image to grayscale, increasing contrast.
        grayIm = rgb2gray(input_image);
        grayIm = imadjust(grayIm);
        
        % Mumford-Shah smoothing
        mumfordIm = smooth_ms(grayIm, 0.6, 300);
        figure, imshow(mumfordIm);

        % Global Thresholding 
        bwIm = imbinarize(mumfordIm, th);
        
        % Filtering by object size
        somaIm = sizeFilter(bwIm,lsb,700);

        % Resulting binary image of the soma
        figure, imshow(somaIm);

        % Soma image overlayed with the original grayscale image
        finalIm = imoverlay(grayIm, imcomplement(boundedIm),'yellow');
        figure, imshow(finalIm);

        figure
        subplot(2,2,1), imshow(input_image);
        subplot(2,2,2), imshow(mumfordIm);
        subplot(2,2,3), imshow(bwIm);
        subplot(2,2,4), imshow(finalIm);
    else
        error('Incorrect Parameter: Specify 0 or 1 for the alg parameter.');
    end
    
    dpimage.somaMask = somaIm;
    comp = bwconncomp(imcomplement(somaIm));
    list = cell([comp.NumObjects,1]);
    
    for i=1:comp.NumObjects
        [row,col] = ind2sub(comp.ImageSize,comp.PixelIdxList{i});
        list{i} = DPSoma([col,row],dpimage); % flipped to conform to cartesian coordinates
        list{i}.subImage = getSomaBox(list{i});
    end    
    dp = dpimage;
end

