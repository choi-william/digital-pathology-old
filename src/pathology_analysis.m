function [ cell_list, cell_count ] = pathology_analysis( dpimage )
%PATHOLOGY_ANALYSIS Summary of this function goes here
%   Detailed explanation goes here

    cell_list = Segment.cell_segmentation(dpimage);

    cell_list = Analysis.feature_analysis(cell_list);
    cell_count = size(cell_list,2);
    
%     fracDim = zeros(cell_count,1);
%     
%     for i =1:cell_count
%         fracDim(i) = cell_list{i}.fractalDim;
%     end
% 
%     figure, histogram(fracDim,10);
end

