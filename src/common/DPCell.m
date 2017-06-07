% University of British Columbia, Vancouver, 2017
%   Alex Kyriazis
%   William Choi

% A representation of a cell and all its properties


classdef DPCell
    % Digital Pathology Cell (DPImage)
    %   A Cell Representation
    
    properties
        pixelList %list of pixels that belong to this cell (dpimage referenced)

        referenceDPImage %the DP image this belongs to

        TL %top left coordinate of subImage box wrt dpimage. In (x,y)
        subImage %a smaller cropping of the cell out of the DPImage
        oImage %image after a step of smoothing
        rCentroid %relative centroid of the subImage in the DPImage
        
        cnnBox %box around cell created for CNN

        area %are of cell
        preThreshIntensity %intensity at the centroid of the cell before thresholding
        circularity %circularity of cell (currently unimplemented)

        isClump = 0;  % true if the component contains multiple cells

        isFalsePositive = 0; %classifier flag
        
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


            obj.circularity = 0; %want to remove but not sure
            
            % SOMA CENTER CALCULATION
            for i=1:5
                newmask = imerode(mask,strel('disk',1));
                if (any(newmask(:)))
                   mask = newmask; 
                else
                   break;
                end
            end

            sumX = 0; sumY = 0;
            for i=1:size(mask,1)
                for j=1:size(mask,2)
                    if (mask(i,j)==1)
                       sumX = sumX + j;
                       sumY = sumY + i;
                    end
                end
            end
            if (round(sumY/sum(mask(:)==1))==202)
               sumY; 
            end
            obj.centroid = round([sumX,sumY]/sum(mask(:)==1));
            %round([sumX,sumY]/sum(mask(:)==1))
            %b = bwmorph(mask,'shrink',Inf);
            
            
%             %MEAN CALCULATION%
%             sumX = 0; sumY = 0;
%             for j=1:size(obj.pixelList,1)
%                 p = obj.pixelList(j,:);
%                 sumX = sumX + p(1); sumY = sumY + p(2);
%             end
%             obj.centroid = round([sumX,sumY]/obj.area);
% 
%             %MEDIAN CALCULATION%
%             temparr = obj.pixelList(:,1);
%             medx = temparr(ceil(size(temparr,1)/2));
%             temparr = obj.pixelList(obj.pixelList(:,1)==medx,2); %TODO could speed up by exploiting sorted array
%             medy = temparr(ceil(size(temparr,1)/2));
%             obj.centroid = round([medx,medy]);
            
            obj.preThreshIntensity = RDPI.preThresh(obj.centroid(2),obj.centroid(1));
            
            obj.maxRadius = 0;
            for j=1:size(obj.pixelList,1)
                p = obj.pixelList(j,:);
                r = Helper.CalcDistance(obj.centroid,p);
                if (r > obj.maxRadius)
                    obj.maxRadius = r;
                end
            end
            obj.maxRadius = round(obj.maxRadius);
        end        
    end
end

