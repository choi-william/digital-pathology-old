function [ list, cell_count ] = cell_pipeline( soma_list )
%
%   Handles cell analysis following soma segmentation
%
    import Prepare.*;
    
    length = size(soma_list,1);
    list = cell([length, 1]);
    length =10;
    for i=1:length
        list{i} = DPMicroglia(soma_list{i});
        
        somaIm = soma_list{i}.subImage;
        
        % Processes Segmentation
        bwIm = extract_processes(somaIm, struct('fastmarching', true));
        list{i}.binaryIm = bwIm;
        
        % Feature Extraction
        [endpoints, junctions, skelIm] = skeleton_analysis(bwIm);
        list{i}.skelIm = skelIm;
        list{i}.numEndpoints = endpoints;
        list{i}.numJunctions = junctions;
        
        list{i}.fractalDim = hausDim(bwIm);
        
    end 
    
end

