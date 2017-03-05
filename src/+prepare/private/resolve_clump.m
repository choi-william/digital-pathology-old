function [ flag, somas ] = resolve_clump( dpsoma )

    somas = 0;
    flag = 0;
    return;
    Iobrcbr = dpsoma.oImage;

    Iobrcbr = imadjust(Iobrcbr);
    adjusted = imadjust(Iobrcbr,[0; 0.2],[0; 1]);
    out = imregionalmin(adjusted);
    
    out = imdilate(out,strel('disk',1));
    out = imcomplement(out);
    
    comp = bwconncomp(imcomplement(out));  
    
    r = dpsoma.area/comp.NumObjects; %average area per soma
    if (r < 150) %probably too small
        return;
    end
    
    somas = {};
    for i=1:comp.NumObjects
        [row,col] = ind2sub(comp.ImageSize,comp.PixelIdxList{i}); 
        
        row = row + dpsoma.TL(2); %convert to image coordinates
        col = col + dpsoma.TL(1); %convert to image coordinates
        

        %we need to make sure that the centroid of [row col] is not found
        %in dpsoma's mask pixelList [row col]

        if (size(row,1) < 100)
           continue;  %too small- discard
        end
        
        
        %This is slowing down the procedure significantly
        %TODO this can be converted to a binary search
        
        centr = round(sum([col,row],1)/size(row,1)); %x-y coordinates
        good = pixelListBinarySearch(round(dpsoma.pixelList),round(centr));
        
       
%         good = 0;
%         centr = round(sum([col,row],1)/size(row,1)); %x-y coordinates
%         for j=1:size(dpsoma.pixelList,1)
%             p = round(dpsoma.pixelList(j,:));
%             if (isequal(p,centr))
%                good = 1;
%                break; 
%             end
%         end
        
        
        if (good == 0)
           continue; %not part of original soma
        end

        soma = DPSoma([col,row],dpsoma.referenceDPImage);
        soma.isClump = 1;
        soma = prepare_soma(soma);
        somas{end+1} = soma{1};
    end
    
    if (size(somas,1) > 0)
       flag = 1; 
    end
end

