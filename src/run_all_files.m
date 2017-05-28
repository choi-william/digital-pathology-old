function [ output_args ] = run_all_files( analysis_type )
%RUN_ALL_FILES Summary of this function goes here
%   Detailed explanation goes here

    filePath = uigetdir('','Choose the folder containing the images to be analyzed.');
    
    cd(filePath);
    imageList = dir('**/*.tif');
    
    global srcPath;
    cd(srcPath);
    
    outPath = uigetdir('','Choose the folder to output the results.');
    
    for i=1:size(imageList,1)
        saveDir = strcat(outPath,'/','analysis_',imageList(i).name);
        pathology_analysis(analysis_type, strcat(imageList(i).folder,'/',imageList(i).name), saveDir);
    end
end

