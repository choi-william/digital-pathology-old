function [ output_args ] = interface( input_args )
%INTERFACE Summary of this function goes here
%   Detailed explanation goes here

    global dataPath;

    filePath = strcat(dataPath, '/DP_Slide.mat');
    load(filePath);
    
    sizeDPslide = size(DPslide,2);
    
    blockSize = 256;
    
    topleft = DPslide(1).Pos{1};
    bottomright = DPslide(15372).Pos{2};
    
    numcols = (bottomright(1) - topleft(1)+1)/blockSize;
    numrows = (bottomright(2) - topleft(2)+1)/blockSize;
    
%     image = reshape(DPslide,[numrows, numcols]);
    
    slide = zeros(numrows,numcols);

    for i=1:numcols
        for j=1:numrows
            slide(j,i) = DPslide((i-1)*numrows+j).Label;
        end
    end
    
    imagesc(slide);
    slide
end

