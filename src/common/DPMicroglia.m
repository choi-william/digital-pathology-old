classdef DPMicroglia
    %DPMICROGLIA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
       referenceDPSoma
       
       skelIm     % skeletonized image of the cell
       
       binaryIm     % binary image of the cell
       
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

