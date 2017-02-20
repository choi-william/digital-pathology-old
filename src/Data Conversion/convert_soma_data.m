function [ point_array ] = convert_soma_data( im )

    point_array = [];
    binIm = imbinarize(im,0.5);
    
    comp = bwconncomp(imcomplement(binIm));
    
    for i=1:comp.NumObjects
        [row,col] = ind2sub(comp.ImageSize,comp.PixelIdxList{i});
        L = [col,row];
            
        sumX = 0;
        sumY = 0;
        for j=1:size(L,1)
            p = L(j,:);
            sumX = sumX + p(1);
            sumY = sumY + p(2);
        end
            
        centroid = [sumX,sumY]/size(L,1);
        point_array = [point_array; centroid];
    end    
    


    
    

end