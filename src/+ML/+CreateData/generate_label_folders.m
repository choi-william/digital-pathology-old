% University of British Columbia, Vancouver, 2017
%   Alex Kyriazis
%   William Choi

% This file creates ready to use classification training data of cells
% (true positive or false positive)

% A repository of cell images based on the
% manual classification training performed in analyze.m is generated. 
% It reads out the output file created from analyze.m and generates all the
% cell images so they can be trained in a CNN or another classifcation framework.

%Note: make sure that the loaded classification data is the desired data

box_side = 20;

global dataPath;
out_path = uigetdir(dataPath,'Choose output folder');

tp_class = 'truePositives';
fp_class = 'falsePositives';

mkdir(out_path,tp_class);
mkdir(out_path,fp_class);

path_tp = strcat(out_path,strcat('/',tp_class));
path_fp = strcat(out_path,strcat('/',fp_class));

load('+ML/+CreateData/classification_data.mat');

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

        L = cent(1) - box_side/2;
        R = cent(1) + box_side/2;
        T = cent(2) - box_side/2;
        B = cent(2) + box_side/2;

        ex = max([-L+1 -T+1 R-W B-H]);
        if (ex > 0)
            continue;
            L = L+ex;
            R = R-ex;
            T = T+ex;
            B = B-ex;
        end
        
        newim = imcrop(dpim.image,[[L,T],R-L, B-T]);   
        image_name = strcat(num2str(count),'.tif');
        count = count+1;
        
        newim = newim(:,:,3);
        %newim = rgb2gray(newim);
        
        newim = imadjust(newim,[0; mean(newim(:))/255],[0; 1]);
        
        if (cells(j,1) == 1)
            imwrite(newim,strcat(path_tp,'/',image_name));
        elseif (cells(j,1) == -1)
            imwrite(newim,strcat(path_fp,'/',image_name));
        else
            error('something bad happened'); 
        end
    end
end




 