box_length = 25;

global dataPath;
out_path = uigetdir(dataPath,'Choose data folder');

mkdir(out_path, 'test_data5');
out_path = strcat(out_path, '/test_data5');

tp_class = 'truePositives';
fp_class = 'falsePositives';

mkdir(out_path,tp_class);
mkdir(out_path,fp_class);

path_tp = strcat(out_path,strcat('/',tp_class));
path_fp = strcat(out_path,strcat('/',fp_class));

load('+Verify/classification_data.mat');

count = 1;
dps = unique(data(:,2));
for i=1:size(dps,1)
    dpnum = dps(i);
    dpim = Pipeline.import_dp('ids',dpnum);
    
    cells = data((data(:,2) == dpnum),:);
    
    
    for j=1:size(cells,1)
        cent = [cells(j,3) cells(j,4)];
        
        W = size(dpim.image,2);
        H = size(dpim.image,1);

        L = cent(1) - box_length;
        R = cent(1) + box_length;
        T = cent(2) - box_length;
        B = cent(2) + box_length;

        ex = max([-L+1 -T+1 R-W B-H]);
        if (ex > 0)
            L = L+ex;
            R = R-ex;
            T = T+ex;
            B = B-ex;
        end
        
        newim = imcrop(dpim.image,[[L,T],R-L, B-T]);   
        image_name = strcat(num2str(count),'.tif');
        count = count+1;
        
        if (cells(j,1) == 1)
            imwrite(newim,strcat(path_tp,'/',image_name));
        elseif (cells(j,1) == -1)
            imwrite(newim,strcat(path_fp,'/',image_name));
        else
            error('something bad happened'); 
        end
    end
end




 