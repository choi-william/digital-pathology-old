classdef DPSoma
    % Digital Pathology Soma (DPImage)
    %   A Soma Representation
    
    properties
        pixelList 
        
        referenceDPImage
        
        TL %top left coordinate of subImage box wrt dpiamge. In (x,y)
        subImage
        oImage %ocbrc image
        rCentroid
        
        area
        
        isClump = 0;  % true if the component contains multiple cells
        
        %file metadata
        centroid %centroid of pixels
        maxRadius %largest containing radius

    end
    
    methods
        function obj = DPSoma(L,RDPI)
            obj.pixelList = L;
            obj.referenceDPImage = RDPI;
            
            obj.area = size(obj.pixelList,1);
            
            sumX = 0;
            sumY = 0;
            for j=1:size(obj.pixelList,1)
                p = obj.pixelList(j,:);
                sumX = sumX + p(1);
                sumY = sumY + p(2);
            end
            
            obj.centroid = [sumX,sumY]/obj.area;
            
            obj.maxRadius = 0;
            for j=1:size(obj.pixelList,1)
                p = obj.pixelList(j,:);
                r = Helper.CalcDistance(obj.centroid,p);
                if (r > obj.maxRadius)
                    obj.maxRadius = r;
                end
            end            
        end        
    end
end

