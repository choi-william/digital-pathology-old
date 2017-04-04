function [ good ] = predict_valid(conv,class,cell)
        good = 1;
        return;
        testFeatures = activations(conv, imresize(cell.cnnBox, [227 227]), 'conv5', ...
            'MiniBatchSize',32);

        % Pass CNN image features to trained classifier
        lab = predict(class, testFeatures);

        if (lab == 'truePositives')
            good = 1;
        else
            good = 0;
        end


end

