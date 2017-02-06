function [ list, cell_count ] = cell_pipeline( soma_list )
%
%
%
    import prepare.*;
    import prepare.fractalDim.*;
    
    length = size(soma_list,1);
    list = cell([length, 1]);
    
    for i=1:length
        list{i} = DPMicroglia(soma_list{i});
        
        somaIm = soma_list{i}.subImage;
        
        % Processes Segmentation
        bwIm = extract_processes(somaIm, struct('vesselness', false));
        list{i}.binaryIm = bwIm;
        
        % Feature Extraction
        [endpoints, junctions, skelIm] = skeleton_analysis(bwIm);
        list{i}.skelIm = skelIm;
        list{i}.numEndpoints = endpoints;
        list{i}.numJunctions = junctions;
        
        list{i}.fractalDim = hausDim(bwIm);
        
    end 
    
end

