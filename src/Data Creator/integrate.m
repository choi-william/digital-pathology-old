path = uigetdir('../../data/images','Open folder to integrate');

out_path = uigetdir('Open output folder to modify');

ver_path = strcat(out_path,'\verification');
all_images = dir(strcat(path,'/','*.mat'));

testSet = input('Enter Test Set #');

metaPath = strcat(out_path,'\','meta.mat');    
meta = load(metaPath);
metaData = meta.metaData;

for i = 1:size(all_images,1)    
    im = all_images(i);
    
    if (im.name(1) == 'T')
        id = im.name(3:end-4);

        destFolder = strcat(ver_path,'\',num2str(testSet),'\');
        if ~exist(destFolder, 'dir')
            mkdir(destFolder); 
        end
        copyfile(strcat(path,'\','ROI',id,'.mat'),destFolder);
        copyfile(strcat(path,'\','TH',id,'.mat'),destFolder); 

        for i=1:size(metaData,1)
            currId = metaData(i).id;   
            if (currId == str2num(id))
                metaData(i).testSet = [metaData(i).testSet testSet];
                metaData(i).test = 1;
                metaData(i).roi = 1;
            end
        end      
    end
end
save(metaPath,'metaData');

