classdef DPMicroglia
    %DPMICROGLIA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
       referenceDPSoma
       
       binaryIm     % binary image of the cell
         
       skelIm     % skeletonized image of the cell
       
       % Skeleton Analysis
       numJunctions   % number of junctions in a skeletonized image
       
       numEndpoints    % number of endpoints in a skeletonized image
       
       % Fractal Analysis
       fractalDim
       
       morphology
       
       centroid
       
       somaSize
       
    end
    
    methods
        function obj = DPMicroglia(refDPSoma)
           obj.referenceDPSoma = refDPSoma; 
        end
    end
    
end

