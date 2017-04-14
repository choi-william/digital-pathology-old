function [ output_args ] = pathology_analysis()
%INTERFACE Summary of this function goes here
%   Detailed explanation goes here

    parpool;
    
    global dataPath;
    
    
    %%% - PROMPT USER FOR BRAIN SLIDE PATH
    
    %%% - USE SHAHRIARS PART TO GET ALL SLIDE INFO
    
    %%% - USE SLIDE INFO BELOW

    filePath = strcat(dataPath, '/DP_Slide.mat');
    load(filePath);
    
    sizeDPslide = size(DPslide,2);
    
    blockSize = 256; % size of each image subblock, change to 128 when new data is available
    
    topleft = DPslide(1).Pos{1};
    bottomright = DPslide(sizeDPslide).Pos{2};
    
    numcols = (bottomright(1) - topleft(1)+1)/blockSize;
    numrows = (bottomright(2) - topleft(2)+1)/blockSize;
    
%   image = reshape(DPslide,[numrows, numcols]);
    
    slide = zeros(numrows,numcols);
    outputData1 = -1*ones(numrows,numcols);
    outputData2 = -1*ones(numrows,numcols);

    tic
    for i=1:numcols
        for j=1:numrows
            linInd = (i-1)*numrows+j;
            fprintf('%d out of %d\n',linInd,numcols*numrows);
            slide(j,i) = DPslide(linInd).Label;
            
            if slide(j,i) == -99
                slide(j,i) = -1;
            end
            
            if slide(j,i) == 0
                outputData1(j,i)=0;
                outputData2(j,i)=0;
            end
            
            if (slide(j,i) == 1)
                im = DPImage('real',num2str(DPslide(linInd).Id));
                [cell_count, average_fractal] = block_analysis( im, 0 );
                outputData1(j,i) = cell_count;
                outputData2(j,i) = 1+10*average_fractal;
                
            end
        end
    end
    toc
    
    imagesc(outputData1);
    title('cell count');
    
    imagesc(outputData2);
    title('average fractal');
    im;
end

