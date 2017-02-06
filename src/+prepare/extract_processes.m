function [bwIm] = extract_processes( soma_image, options )
%EXTRACTPROCESSES Summary of this function goes here
%   Detailed explanation goes here
%
    import prepare.frangi_filter.*;
    
    default_option = struct('vesselness', false);

    if ~exist('options','var')
        options = default_option;
    else
        tags = fieldnames(options);
        if length(tags) ~= 1 || ~strcmp(tags{1}, 'vesselness')
            warning('Unknown options found. Please provide only the vesselness option.');
        end
    end
   
    grayIm = rgb2gray(soma_image);
    grayIm = imadjust(grayIm);
    
    % Vesselness; frangi filter applied
    if options.vesselness
        I = double(grayIm);
        vesselIm = FrangiFilter2D(I);
        grayIm = imcomplement(vesselIm);
    end

    % Mumford-Shah applied to the grayscale image
    mumfordIm = prepare.mumford_shah.fastms(grayIm, 'lambda', 0.01, 'alpha', 10, 'edges', false);
    bwIm = imbinarize(mumfordIm, 0.3);    
end

