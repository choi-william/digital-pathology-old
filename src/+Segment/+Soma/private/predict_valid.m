% University of British Columbia, Vancouver, 2017
%   Alex Kyriazis
%   William Choi
% 
% A function that classifies the cell based on the passed in model
%

function [ good ] = predict_valid(class,cell)
        good = 1;
        return;
        %TODO MAKE CLASSIFIER FORMAT CONSISTENT
            
        I = cell.cnnBox;
%         if ismatrix(I)
%             I = cat(3,I,I,I);
%         end
%         I = imresize(I, [227 227]);
        
        testFeatures = ML.extract_manual_features(I);
        lab = predict(class, testFeatures);

        if (strcmp(lab{1},'tp'))
            good = 1;
        elseif (strcmp(lab{1},'fp'))
            good = 0;
        end

end

