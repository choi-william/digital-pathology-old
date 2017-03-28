function [ list ] = load_training_features( )
%LOAD_FEATURES Summary of this function goes here
%   Detailed explanation goes here
    global dataPath;
    testdata_path = strcat(dataPath,'/test_data');
    load(strcat(testdata_path,'/microglia_features.mat'));
    for i=1:size(list,2)
        cell = list{i};
        if (strcmp(cell.classification, 'tp'))
            image_path = strcat(testdata_path,'/truePositives/',cell.subImageName);
            list{i}.subImage = imread(image_path);
        elseif (strcmp(cell.classification, 'fp'))
            image_path = strcat(testdata_path,'/falsePositives/',cell.subImageName);
            list{i}.subImage = imread(image_path);
        end
    end
end

