function [ flag, somas ] = resolve_clump( dpcell )

    somas = 0;
    flag = 0;

    Iobrcbr = dpcell.oImage;

    Iobrcbr = imadjust(Iobrcbr);
    adjusted = imadjust(Iobrcbr,[0; 0.2],[0; 1]);
    out = imregionalmin(adjusted);
    
    out = imdilate(out,strel('disk',1));
    out = imcomplement(out);
    
    comp = bwconncomp(imcomplement(out));  
    

    
    somas = {};
    for i=1:comp.NumObjects
        [row,col] = ind2sub(comp.ImageSize,comp.PixelIdxList{i}); 
        
        row = row + dpcell.TL(2); %convert to image coordinates
        col = col + dpcell.TL(1); %convert to image coordinates

        if (size(row,1) < 100)
           continue;  %too small- discard
        end
        
        centr = round(sum([col,row],1)/size(row,1)); %x-y coordinates
        good = pixelListBinarySearch(round(dpcell.pixelList),round(centr));
        
        if (good == 0)
           continue; %not part of original soma
        end

        soma = DPCell([col,row],dpcell.referenceDPImage);
        

        soma.isClump = 1;
        soma = prepare_soma(soma);
        somas{end+1} = soma{1};
    end
    
    r = dpcell.area/size(somas,1); %average area per soma
    if (r < 150) %probably too small
        somas = 0;
        return;
    end
    
    if (size(somas,1) > 0)
       flag = 1; 
    end
end

