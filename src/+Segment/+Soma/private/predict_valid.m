function [ good ] = predict_valid(conv,class,cell,type)
        good = 1;
        %return;
        %TODO MAKE CLASSIFIER FORMAT CONSISTENT
        
        
        
        if type == 1        
            
            I = cell.cnnBox;
            if ismatrix(I)
                I = cat(3,I,I,I);
            end
            I = imresize(I, [227 227]);
            
            testFeatures = activations(conv, I, 'conv5', ...
                'MiniBatchSize',32);
            lab = predict(class, testFeatures);
            
            if (lab == 'truePositives')
                good = 1;
            elseif (lab == 'falsePositives')
                good = 0;
            end
            
        elseif type == 0
            testFeatures = [double(cell.area) double(cell.preThreshIntensity) double(cell.circularity)];
            lab = predict(class, testFeatures);

            lab = lab{1};
            if (lab == 'tp')
                good = 1;
            elseif (lab == 'fp')
                good = 0;
            end        
        end
end

