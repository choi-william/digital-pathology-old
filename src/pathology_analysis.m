function [ output_args ] = pathology_analysis( dpimage )
%PATHOLOGY_ANALYSIS Summary of this function goes here
%   Detailed explanation goes here

    cell_list = Segment.cell_segmentation(dpimage);
    
    cell_list = Analysis.feature_analysis(cell_list);
    
    cell_count = size(cell_list,2);
end

