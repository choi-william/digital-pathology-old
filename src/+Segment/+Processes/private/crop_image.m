function [ cropim, rowCoord, colCoord ] = crop_image( matrix, row, col, offset )
%CUTIMAGE Summary of this function goes here
%   Detailed explanation goes here

    numrow = size(matrix,1);
    numcol = size(matrix,2);
    
    topleft = [row-offset,col-offset];
    bottomright = [row+offset,col+offset];
    
    if (topleft(1)<1) topleft(1) = 1; end
    if (topleft(2)<1) topleft(2) = 1; end
    if (bottomright(1)>numrow) bottomright(1) = numrow; end
    if (bottomright(2)>numcol) bottomright(2) = numcol; end
    
    cropim = matrix(topleft(1):bottomright(1),topleft(2):bottomright(2));
    rowCoord = topleft(1);
    colCoord = topleft(2);
end
