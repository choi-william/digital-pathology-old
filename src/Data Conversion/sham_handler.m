%this is only useful for one particular case I used it in, but I figured I'd keep it

path = uigetdir('../../data/images','Open thresholds');

all_images = dir(strcat(path,'/*.tif'))


for i = 1:size(all_images,1)
    
    fprintf('%d out of %d\n',i,round(size(all_images,1)));
    
    im = all_images(i);
    im_im = imread(strcat(im.folder,'\',im.name));
    im_im = imbinarize(rgb2gray(im_im),0);
    imwrite(im_im,strcat(path,'\','1',im.name));
end