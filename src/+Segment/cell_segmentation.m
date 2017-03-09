function [ cell_list ] = cell_segmentation( dpimage )
%CELL_SEGMENTATION Summary of this function goes here
%   Handles cell segmentation; soma segmentation followed by processes
%   segmentation of the cells
%

    % Soma Segmentation
    [cell_list,dp] = Segment.Soma.extract_soma(dpimage, 0, 0.4, 100);
    
    % Processes Segmentation
    length = size(cell_list,2);
    for i=1:length
        %  binaryIm = extract_processes(cell_list{i}.subImage, struct('fastmarching', true));
        % TODO: cell centroid should be adjusted to have coordinates in the
        % subimage
        binaryIm = Segment.Processes.process_segmentation(cell_list{i}.subImage, cell_list{i}.centroid);
        cell_list{i}.binaryIm = binaryIm;
    end
    
end

