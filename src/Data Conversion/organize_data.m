
path = uigetdir('../../data/images','Open folder to organize');
out_path = uigetdir('../../data/output','Choose destination');

mkdir(out_path,'verification')
v_path = strcat(out_path,'\verification');

all_images = dir(strcat(path,'/**/*.tif'))

metaData = [];
testMetaData = [];
id = 0;
th_id = 0;

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
        if (size(strfind(th.name,key),1) ~= 0)

            
            th_id = th_id + 1;            
            newTh.id = th_id;
            newTh.originalName = th.name;
            newTh.time = C{1};
            newTh.age = C{2};
            newTh.date = C{3};
            newTh.group = C{4};
            newTh.type = 'test';
            newTh.stain = 'iba1';
            newTh.test = -1;
            newObj.test = th_id;
            
            th_im = imread(strcat(th.folder,'\',th.name));
            pointArray = convert_soma_data(th_im);
            save(strcat(v_path,'\TH',num2str(th_id),'.mat'),'pointArray');
            
            testMetaData = [testMetaData; newTh];
            break;
        end
    end
    metaData = [metaData; newObj];
end

save(strcat(v_path,'\','metaTest.mat'),'testMetaData');
save(strcat(out_path,'\','meta.mat'),'metaData');