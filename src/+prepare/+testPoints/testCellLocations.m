function [ output_args ] = testCellLocations( dpimage )
    % creates an image, and allows a user to generate an array of points that
    % define microlgia locations
    
    global coords;
    coords = [];

    b = imshow(dpimage.image);
    hold on;
    set(b,'ButtonDownFcn',@prepare.testPoints.imageClickCallback)
end

