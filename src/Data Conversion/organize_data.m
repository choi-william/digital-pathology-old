
path = uigetdir('../../data/images','Open folder to organize');
out_path = uigetdir('../../data/output','Choose destination');

mkdir(out_path,'verification')
mkdir(strcat(out_path,'\verification'),'1');
v_path = strcat(out_path,'\verification\1');

all_images = dir(strcat(path,'/**/*.tif'))

metaData = [];
testMetaData = [];
id = 0;


for i = 1:size(all_images,1)
    
    fprintf('%d out of %d\n',i,round(size(all_images,1)));
    
    im = all_images(i);
    %META DATA PROCESSING
    
    newObj = [];
    impath = im.folder;
    impath = impath((size(path,2)+2):end);
    impath = strrep(impath,'/','\'); %I anticipate that there will be problems on Mac without this
    C = strsplit(impath,'\'); 
    
    if ~strcmp(C{5},'image')
        continue;
    end
    
    %CREATE METADATA
    id = id + 1;
    newObj.id = id;
    newObj.originalName = im.name;
    newObj.time = C{1};
    newObj.age = C{2};
    newObj.date = C{3};
    newObj.group = C{4};
    newObj.type = 'image';
    newObj.stain = 'iba1';
    newObj.test = 0;
    newObj.roi = 0;
    newObj.testSet = 0; 
    
    im_im = imread(strcat(im.folder,'\',im.name));
    imwrite(im_im,strcat(out_path,'\',num2str(id),'.tif'));
    
    %FIND VERIFICATION
    key = strsplit(im.name,' ');
    key = key{end};
    key = strsplit(key,'.');
    key = key{1};
    
    all_th = dir(strcat(path,'\',C{1},'\',C{2},'\',C{3},'\',C{4},'\','threshold','\*.tif')); %possibly a problem on mac
    
    for j=1:size(all_th)
        th = all_th(j);
        if (size(strfind(lower(th.name),lower(key)),1) ~= 0)

            %FIND ROI (only if verification file is found)
            all_roi = dir(strcat(path,'\',C{1},'\',C{2},'\',C{3},'\',C{4},'\','roi','\*.roi')); %possibly a problem on mac
            for j=1:size(all_roi)
                ro = all_roi(j);
                
                if (size(strfind(lower(ro.name),lower(key)),1) ~= 0)
                    %found the roi file.
                    
                    newObj.roi = 1; %TODO replace X
                    
                    if strcmp(newObj.time,'S')
                        %sham without an ROI
                        data = rgb2gray(im_im); %define all as roi
                        data(:,:) = 1.0;      
                        save(strcat(v_path,'\ROI',num2str(id),'.mat'),'data');
                        break;
                    end
                    [roi_obj] = read_roi(strcat(ro.folder,'\',ro.name));
                    data = poly2mask(roi_obj.mnCoordinates(:,1),roi_obj.mnCoordinates(:,2), size(im_im,1), size(im_im,2));  %roi mask        
                    save(strcat(v_path,'\ROI',num2str(id),'.mat'),'data');               
                    break;
                end
            end
            
            newObj.test = 1;
            newObj.testSet = 1;
            
            th_im = imread(strcat(th.folder,'\',th.name));
            data = convert_soma_data(double(th_im)); %array of points
            save(strcat(v_path,'\TH',num2str(id),'.mat'),'data');
            break;
        end
    end
    metaData = [metaData; newObj];
end

save(strcat(out_path,'\','meta.mat'),'metaData');