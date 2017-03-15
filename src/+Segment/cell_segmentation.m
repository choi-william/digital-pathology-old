function [ cell_list ] = cell_segmentation( dpimage, visual )
%CELL_SEGMENTATION Summary of this function goes here
%   Handles cell segmentation; soma segmentation followed by processes
%   segmentation of the cells
%

    if (nargin == 1) visual = 0; end

    % Soma Segmentation
    [cell_list,dp] = Segment.Soma.extract_soma(dpimage, 0, 0.8, 100);
    length = size(cell_list,2);

    
    im = dp.image;
    

    
    if (visual)
        
        h = figure; 
        imshow(im); %put to left side of screen
        hold on;
        for i=1:length
            im = Tools.colour_overlay(im,cell_list{i}.pixelList,'blue');
            imshow(im);
            pause(0.02);
        end
    end
    
    
    % Processes Segmentation
    for i=1:length
        
        if (visual)
            set(0,'CurrentFigure',h);
            im = Tools.colour_overlay(im,cell_list{i}.pixelList,'red');
            imshow(im);
            pause(0.01);
        end
        
        %  binaryIm = extract_processes(cell_list{i}.subImage, struct('fastmarching', true));
        % TODO: cell centroid should be adjusted to have coordinates in the
        % subimage       
        binaryIm = Segment.Processes.process_segmentation(cell_list{i}.subImage, cell_list{i}.centroid);
        cell_list{i}.binaryIm = binaryIm;
        
        pause(0.1);
        if (visual)
            set(0,'CurrentFigure',h);
            im = Tools.colour_overlay(im,cell_list{i}.pixelList,'green');
            imshow(im);
            pause(0.01);
        end
    end

end

