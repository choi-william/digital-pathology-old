box_side = 20;

load('+Verify/+CreateData/classification_data_asma.mat');

count = 1;
dps = unique(data(:,2));

in_path = uigetdir(dataPath,'Choose input folder');


newList=[];
for i=1:size(dps,1)
    dpnum = dps(i);
    dpim = DPImage('real',[in_path '/' num2str(dpnum) '.tif']); %%fix this

    cells = data((data(:,2) == dpnum),:);
    
    
    for j=1:size(cells,1)
        cent = [cells(j,3) cells(j,4)];
        
        W = size(dpim.image,2);
        H = size(dpim.image,1);

        L = cent(1) - box_side/2;
        R = cent(1) + box_side/2;
        T = cent(2) - box_side/2;
        B = cent(2) + box_side/2;

        ex = max([-L+1 -T+1 R-W B-H]);
        if (ex > 0)
            continue;
            L = L+ex;
            R = R-ex;
            T = T+ex;
            B = B-ex;
        end
        
        newim = imcrop(dpim.image,[[L,T],R-L, B-T]);   
        image_name = strcat(num2str(count),'.tif');
        count = count+1;
        
        newim = newim(:,:,3);
        %newim = rgb2gray(newim);
        
        newim = imadjust(newim,[0; mean(newim(:))/255],[0; 1]);
        
        if (cells(j,1) == 1)
            newList = [newList; {'tp',ML.extract_manual_features(newim)}];
        elseif (cells(j,1) == -1)
            newList = [newList; {'fp',ML.extract_manual_features(newim)}];
        else
            error('something bad happened'); 
        end
    end
end

training_percentage = 0.7;
    
setlength = randperm(size(newList,1));

training = newList(setlength(1:floor(size(setlength,2)*training_percentage)),:);
test = newList(setlength((floor(size(setlength,2)*training_percentage)+1):end),:);

trainingFeatures = [];
trainingLabels = {}; 

for j=1:size(training,1)
    trainingLabels{end+1,1} = training{j,1};
    trainingFeatures = [trainingFeatures; training{j,2}]; 
end
trainingLabels = categorical(trainingLabels);

testFeatures = [];
testLabels = [];

for j=1:size(test,1)
    testLabels{end+1,1} = test{j,1};
    testFeatures = [testFeatures; test{j,2}];
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



 