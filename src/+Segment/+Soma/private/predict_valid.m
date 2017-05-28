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

