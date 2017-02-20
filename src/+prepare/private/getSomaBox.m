function [im] = getSomaBox( soma )

    bigImage = soma.referenceDPImage.image;
    [maxh,maxw] = size(bigImage);
    
    factor = 4;
    TL = soma.centroid - ones(1,2)*soma.maxRadius*factor;
    BR = soma.centroid + ones(1,2)*soma.maxRadius*factor;
    
    if TL(1) < 0
        TL(1) = 0;
    end
    if TL(2) < 0
        TL(2) = 0;
    end    
    if BR(1) > maxh
        BR(1) = maxh;
    end    
    if BR(2) > maxw
        BR(2) = maxw;
    end 
    
    C = BR-TL;
    im = imcrop(bigImage,[TL, C(2), C(1)]);
end

