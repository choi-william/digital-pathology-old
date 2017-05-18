function [ output_args ] = analyze_image( handles, xCoord, yCoord )
%ANALYZE_IMAGE Summary of this function goes here
%   Detailed explanation goes here
    global out_path;
    if (isempty(out_path))
        out_path = '../../data';
    end
    vis_path = strcat(out_path, '/analysis.mat');

    load(vis_path,'outputData1','outputData2','im','blockSize');
    
    save_path = '../../data/subImage_test'
    
    axes(handles.axes2);
    currentIm = imcrop(im,[(xCoord-1)*blockSize,(yCoord-1)*blockSize,blockSize,blockSize]);

    if outputData1(yCoord,xCoord) >= 0
        imwrite(currentIm,strcat(save_path,['/' num2str(xCoord) num2str(yCoord) '.tif']));
    else
        imshow('../anoush.png');
    end

end

