function [ list, cell_count ] = cell_pipeline( soma_list )
%
%   Handles cell analysis following soma segmentation
%
    import Prepare.*;
    
    length = size(soma_list,2);
    list = cell([length, 2]);
    length =1; % remove when not testing
    for i=1:length
        list{i} = DPMicroglia(soma_list{i});
        
        somaObj = soma_list{i};
        
        % Processes Segmentation
        % bwIm = extract_processes(somaObj.subImage, struct('fastmarching', true));
        bwIm = cell_segmentation(somaObj);
        
        list{i}.binaryIm = bwIm;
        
        % Feature Extraction
        [endpoints, junctions, skelIm] = skeleton_analysis(bwIm);
        list{i}.skelIm = skelIm;
        list{i}.numEndpoints = endpoints;
        list{i}.numJunctions = junctions;
        
        list{i}.fractalDim = hausDim(bwIm);
        
    end 
    
end

