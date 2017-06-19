% University of British Columbia, Vancouver, 2017
%   Alex Kyriazis
%   William Choi
% 
% Finds features based on extraction performed in DPFeatures
%

function [] = get_features( dpimages )
%DISTINGUISH Summary of this function goes here
%   Detailed explanation goes here
    
    numimage = size(dpimages,2);
    list = {};
    for i=1:numimage
        
        fprintf('Getting features from %d of %d\n',i,numimage);

        somalist = Verify.evaluate_soma(dpimages{i},0);
        numsoma = size(somalist,2);
        celllist = cell(1,numsoma);
        
        for j=1:numsoma
            soma = somalist{j};            
            celllist{j} = DPFeatures(soma);
        end
        list = [list celllist];
    end
    save('+ML/soma_features.mat','list');  
end

