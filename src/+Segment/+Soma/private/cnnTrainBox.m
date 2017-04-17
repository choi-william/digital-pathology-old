function [soma] = cnnTrainBox( soma )

    sub = soma.subImage;
    cent = round(soma.rCentroid);
    
    bsize = 25;
    
    W = size(sub,2);
    H = size(sub,1);
    
    
    L = cent(1) - bsize;
    R = cent(1) + bsize;
    T = cent(2) - bsize;
    B = cent(2) + bsize;
    
    ex = max([-L+1 -T+1 R-W B-H]);
    if (ex > 0)
        L = L+ex;
        R = R-ex;
        T = T+ex;
        B = B-ex;
    end
    soma.cnnBox = imcrop(soma.referenceDPImage.image,[soma.TL+[L,T],R-L, B-T]);
end

