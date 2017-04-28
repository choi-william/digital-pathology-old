function [ output_args ] = analyze_image( handles, xCoord, yCoord )
%ANALYZE_IMAGE Summary of this function goes here
%   Detailed explanation goes here
    global out_path;
    if (isempty(out_path))
        out_path = '../../data';
    end
    vis_path = strcat(out_path, '/visualization.mat');
    load(vis_path,'outputData1','outputData2');
    
    save_path = '../../data/subImage_test'
    
    axes(handles.axes2);
    imagename = strcat('/',num2str(yCoord+(xCoord-1)*size(outputData1,1)), '.tif');
    imagepath = strcat(out_path,'/BlockImg',imagename);
    if outputData1(yCoord,xCoord) >= 0
        image =imread(imagepath);
        imshow(image);
        imwrite(image,strcat(save_path,imagename));
    else
        imshow('../anoush.png');
    end

end

