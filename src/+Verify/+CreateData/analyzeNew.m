    %brings in 'data'
data=[];
load('+Verify/+CreateData/classification_data_asma.mat');

if (isempty(data))
    used = [];
else
    used = unique(data(:,2));
end

remaining = setdiff(goodIms,used);

randInd = ceil(rand*size(remaining,2));

im = Pipeline.import_dp('ids',randInd);
Verify.CreateData.analyze(im);
