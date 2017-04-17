% University of British Columbia, Vancouver, 2017
%   Dr. Guy Nir
%   Shahriar Noroozi Zadeh
%   Amir Refaee
%   Lap-Tak Chu

[fpath, NumSVSslides,~,~,~,~,~] = RunTimeInformation([],[],'r',0,0,0);
if ~isTrained
    disp('Saving Training Variables ...');
    save([fpath,'/TrainingInfo'],'cls_mdl','blk_feat_all_slides_mean','blk_feat_all_slides_std');
    isTrained = true;
else
    save([fpath,'/TestingInfo'],'Slide');
end