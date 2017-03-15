classdef DPCell
    % Digital Pathology Cell (DPImage)
    %   A Cell Representation
    
    properties
        pixelList 

        referenceDPImage

        TL %top left coordinate of subImage box wrt dpiamge. In (x,y)
        subImage
        oImage %ocbrc image
        rCentroid

        area
        preThreshIntensity
        circularity

        isClump = 0;  % true if the component contains multiple cells

        %file metadata
        centroid %centroid of pixels
        maxRadius %largest containing radius

        isCorrect = -1; %whether it matches test data or not

        % Following Processes Segmentation
        
        binaryIm     % binary image of the cell

        skelIm     % skeletonized image of the cell

        % Skeleton Analysis
        numJunctions   % number of junctions in a skeletonized image

        numEndpoints    % number of endpoints in a skeletonized image

        % Fractal Analysis
        fractalDim

        morphology

        somaSize
        
    end
    
    methods
        function obj = DPCell(L,RDPI)
            
         
            
            obj.pixelList = L; %[col, row]
            obj.referenceDPImage = RDPI;
            obj.area = size(obj.pixelList,1);

            
            dim = size(RDPI.image);
            mask = false(dim(1:2));
            
            for i=1:size(L,1)
                mask(round(L(i,2)),round(L(i,1))) = 1;                
            end
            perim = regionprops(mask,'Perimeter');
            perim = perim.Perimeter;
            
            obj.circularity = (perim .^ 2) ./ (4 * pi * obj.area);
            
            sumX = 0;
            sumY = 0;
            for j=1:size(obj.pixelList,1)
                p = obj.pixelList(j,:);
                sumX = sumX + p(1);
                sumY = sumY + p(2);
            end
            
            obj.centroid = round([sumX,sumY]/obj.area);
            
            obj.preThreshIntensity = RDPI.preThresh(obj.centroid(2),obj.centroid(1));
            
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

