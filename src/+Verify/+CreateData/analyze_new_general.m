% University of British Columbia, Vancouver, 2017
%   Alex Kyriazis
%   William Choi

% See AnalyzeNew.m's description. This generalizes the process a little
% more by allowing to pull images from a custom directory **specificed
% below in path** rather than the regular directory where the images are
% found.

data=[];
load('+Verify/+CreateData/classification_data_asma.mat');
if (isempty(data))
    used = [];
else
    used = unique(data(:,2));
end

path = ['../' 'tif_09_1' '/BlockImg'];
files = dir(path);


num = files(randi(length(files))).name(1:end-4);
while (ismember(str2num(num),used))
    num = files(randi(length(files))).name(1:end-4);
end


im = DPImage('real',[path '/' num '.tif']);
Verify.CreateData.analyze(im,str2num(num));
