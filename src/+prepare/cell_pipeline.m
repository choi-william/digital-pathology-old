function [ list ] = cell_pipeline( soma_list )
%
%
%
import prepare.*;
    length = size(soma_list,1);
    list = cell([length, 1]);
    
    for i=1:length
        list{i} = DPMicroglia(soma_list{i});
        
        somaIm = soma_list{i}.subImage;
        
        % Processes Segmentation
        [bwIm, skelIm] = extract_processes(somaIm);
        list{i}.binaryIm = bwIm;
        list{i}.skelIm = skelIm;
        
        % Feature Extraction
        
        
    end 
end

