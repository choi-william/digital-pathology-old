
    %brings in 'data'
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
