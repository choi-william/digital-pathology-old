function [cell_count, average_fractal] = block_analysis( dpimage, visual )
%PATHOLOGY_ANALYSIS Summary of this function goes here
%   Detailed explanation goes here

    if (nargin == 1) visual = 0; end

    cell_list = Segment.cell_segmentation(dpimage,visual);

    cell_list = Analysis.feature_analysis(cell_list);
    cell_count = size(cell_list,2);

    % Any visualization stuff goes here
    fracDim = zeros(cell_count,1);

    for i =1:cell_count
        fracDim(i) = cell_list{i}.fractalDim;
    end
    average_fractal = mean(fracDim(i));
    
   % figure, histogram(fracDim,10);
end

