function [dpcell_list] = cell_pipeline( dpcell_list )
%
%   Handles cell analysis following soma segmentation
%
    
    length = size(dpcell_list,2);
    for i=1:length

        % Feature Extraction
        [endpoints, junctions, skelIm] = skeleton_analysis(dpcell_list{i}.binaryIm);
        dpcell_list{i}.skelIm = skelIm;
        dpcell_list{i}.numEndpoints = endpoints;
        dpcell_list{i}.numJunctions = junctions;
        
        dpcell_list{i}.fractalDim = hausDim(dpcell_list{i}.binaryIm);
        
    end 

end

