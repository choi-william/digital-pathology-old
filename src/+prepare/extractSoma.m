function [ mask,list ] = extractSoma( dpimage )
%EXTRACTSOMA Summary of this function goes here
%   Detailed explanation goes here

    % converting image to grayscale
    grayIm = rgb2gray(dpimage.image);
    grayIm = imadjust(grayIm);
    adjusted = imadjust(grayIm,[0; 0.5],[0; 1]);

    se = strel('disk', 3);
    
    %OPEN BY RECONSTRUCTION%
    Ie = imerode(adjusted, se);
    Iobr = imreconstruct(Ie, adjusted);
    
    %CLOSE BY RECONSTRUCTION%
    Iobrd = imdilate(Iobr, se);
    Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
    Iobrcbr = imcomplement(Iobrcbr);
    
    %THRESHOLD RESULT%
    Imicro = imbinarize(Iobrcbr,0.5);

    %DISPLAY SEGMENTATION%
    boundaries = bwperim(Imicro);
    boundaries = imdilate(boundaries,strel('disk',1));
    
    overlay = dpimage.image;
    
    r = overlay(:,:,1);
    g = overlay(:,:,2);
    b = overlay(:,:,3);
    r(boundaries) = 0;
    g(boundaries) = 255;
    b(boundaries) = 0;
    overlay(:,:,1) = r;
    overlay(:,:,2) = g;
    overlay(:,:,3) = b;

    mask = Imicro;
    dpimage.somaMask = mask;
    comp = bwconncomp(imcomplement(Imicro));

    
    list = cell(comp.NumObjects);
    for i=1:comp.NumObjects
        [X,Y] = ind2sub(comp.ImageSize,comp.PixelIdxList{i});
        list{i} = DPSoma([Y,X],dpimage); %transposed for some reason
    end
end

