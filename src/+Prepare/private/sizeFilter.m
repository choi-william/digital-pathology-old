function [ out ] = sizeFilter( in, L, U )
        compIm = imcomplement(in);
        lb_pixel = L;
        ub_pixel = U;
        boundedIm = xor(bwareaopen(compIm,lb_pixel),bwareaopen(compIm,ub_pixel));
        out = imcomplement(boundedIm);
end

