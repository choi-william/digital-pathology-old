function [] = classification_trainer()

    list = load_training_features();
    
    %only get two classes
    newList = {};
    for j=1:size(list,2)
        obj = list{j};
        if (strcmp(obj.classification,'fp') || strcmp(obj.classification,'tp'))
            newList{end+1} = obj;
        end
    end
    
    training_percentage = 0.7;
    
    setlength = randperm(size(newList,2));
    
    training = newList(setlength(1:floor(size(setlength,2)*training_percentage)));
    test = newList(setlength((floor(setlength*training_percentage)+1):end));
    
    trainingFeatures = [];
    trainingLabels = {}; 
    
    for j=1:size(training,2)
        obj = training{j};
        trainingLabels{end+1,1} = obj.classification;
        trainingFeatures = [trainingFeatures; double(obj.circularity)]; %not correct
    end
    trainingLabels = categorical(trainingLabels);
    
    testFeatures = [];
    testLabels = [];
    
    for j=1:size(test,2)
        obj = test{j};
        testLabels{end+1,1} = obj.classification;
        testFeatures = [testFeatures; double(obj.area) double(obj.thresh) double(obj.circularity)];
    end
    testLabels = categorical(testLabels);
    
    classifier = fitcecoc(trainingFeatures, trainingLabels, ...
         'ClassNames',{'fp','tp'}, ....
            'Learners', 'Linear', 'Coding', 'onevsall', 'ObservationsIn', 'rows');

    % Pass CNN image features to trained classifier
    predictedLabels = predict(classifier, testFeatures);
    predictedLabels = categorical(predictedLabels);
    
    
    % Tabulate the results using a confusion matrix.
    confMat = confusionmat(testLabels, predictedLabels);

    % Convert confusion matrix into percentage form
    confMat = bsxfun(@rdivide,confMat,sum(confMat,2))
    
    % Display the mean accuracy
    mean(diag(confMat))
    
end

