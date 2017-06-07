% University of British Columbia, Vancouver, 2017
%   Alex Kyriazis
%   William Choi
% 
% Generates a box around the cell center that will be the input to a CNN
%

function [soma] = cnnTrainBox( soma )

    sub = soma.referenceDPImage.image;
    cent = round(soma.centroid);
    
    bsize = 20;
    
    W = size(sub,2);
    H = size(sub,1);
    
    
    L = cent(1) - bsize/2;
    R = cent(1) + bsize/2;
    T = cent(2) - bsize/2;
    B = cent(2) + bsize/2;
    
    ex = max([-L+1 -T+1 R-W B-H]);
    if (ex > 0)
        L = L+ex;
        R = R-ex;
        T = T+ex;
        B = B-ex;
    end
    newim = imcrop(soma.referenceDPImage.image,[[L,T],R-L, B-T]);
    %newim = rgb2gray(newim);
    newim = newim(:,:,3);
    if (mean(newim(:))~=0)
        newim = imadjust(newim,[0; mean(newim(:))/255],[0; 1]);
    end
    soma.cnnBox = newim;   
    
end

