function [ output_args ] = pathology_analysis( dpimage )
%PATHOLOGY_ANALYSIS Summary of this function goes here
%   Detailed explanation goes here

    [soma_list,dp] = extract_soma(dpimage.image, 0, 0.4, 100);
    microglia_list = cell_pipeline(soma_list);
    
end

