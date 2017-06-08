% University of British Columbia, Vancouver, 2017
%   Alex Kyriazis
%   William Choi

% Opens a user interface that allows one to manually select microglia on
% DPImages so that they can be used for training data for CNNs or other
% classification frameworks

%This file in particular selects a new image that hasn't already been
%analyzed in the set specified by the .mat file where the training data is
%being saved to

%NOTE: the file that you are loading here should be the same file you are
%saving to in Verify.CreateData.manual_label(im)


data=[];
load('+ML/+CreateData/classification_data_asma.mat');
if (isempty(data))
    used = [];
else
    used = unique(data(:,2));
end

path = ['../' 'tif_09_1' '/BlockImg']; %CHANGE THIS
files = dir(path);


num = files(randi(length(files))).name(1:end-4);
while (ismember(str2num(num),used))
    num = files(randi(length(files))).name(1:end-4);
end


im = DPImage('real',[path '/' num '.tif']);
ML.CreateData.manual_label(im,str2num(num));
