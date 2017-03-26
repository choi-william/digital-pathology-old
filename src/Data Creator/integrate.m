path = uigetdir('../../data/images','Open folder to integrate');

out_path = uigetdir('Open output folder to modify');

ver_path = strcat(out_path,'\verification');
all_images = dir(strcat(path,'/','*.mat'));

testSet = input('Enter Test Set #');

for i = 1:size(all_images,1)    
    im = all_images(i);
    
    if (im.name(1) == 'T')
       id = im.name(3:end-4);
       
       destFolder = strcat(ver_path,'\',num2str(testSet),'\');
       
       copyfile(strcat(path,'\','ROI',id,'.mat'),strcat(destFolder,'poo.mat'));
       copyfile(strcat(path,'\','TH',id,'.mat'),destFolder);        
    end
end

