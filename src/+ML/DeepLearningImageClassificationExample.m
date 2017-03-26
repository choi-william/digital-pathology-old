%function DeepLearningImageClassificationExample

    rootFolder = fullfile('C:\Users\alexkyriazis\Documents\digital-pathology\data\training');
    categories = {'falsePositives', 'truePositives'};
    
    imds = imageDatastore(fullfile(rootFolder, categories), 'LabelSource', 'foldernames');
    
    tbl = countEachLabel(imds)
    
    minSetCount = min(tbl{:,2}); % determine the smallest amount of images in a category

    % Use splitEachLabel method to trim the set.
    imds = splitEachLabel(imds, minSetCount, 'randomize');

    % Notice that each set now has exactly the same number of images.
    countEachLabel(imds)
    
    % Find the first instance of an image for each category
    falsePositives = find(imds.Labels == 'falsePositives', 1);
    truePositives = find(imds.Labels == 'truePositives', 1);

%     figure
%     subplot(1,2,1);
%     imshow(readimage(imds,falsePositives))
%     subplot(1,2,2);
%     imshow(readimage(imds,truePositives))
    
    cnnMatFile = 'C:\Users\alexkyriazis\Documents\digital-pathology\src\+ML\imagenet-caffe-alex.mat';
    
    % Load MatConvNet network into a SeriesNetwork
    convnet = helperImportMatConvNet(cnnMatFile)
    
    % View the CNN architecture
    convnet.Layers
    
    % Inspect the first layer
    convnet.Layers(1)
    
    % Inspect the last layer
    convnet.Layers(end)

    % Number of class names for ImageNet classification task
    numel(convnet.Layers(end).ClassNames)
    
    % Set the ImageDatastore ReadFcn
    imds.ReadFcn = @(filename)readAndPreprocessImage(filename);
    
    [trainingSet, testSet] = splitEachLabel(imds, 0.7, 'randomize');
    
    % Get the network weights for the second convolutional layer
    w1 = convnet.Layers(2).Weights;

    % Scale and resize the weights for visualization
    w1 = mat2gray(w1);
    w1 = imresize(w1,5);

    % Display a montage of network weights. There are 96 individual sets of
    % weights in the first layer.
%     figure
%     montage(w1)
%     title('First convolutional layer weights')
    
    featureLayer = 'conv5';
    trainingFeatures = activations(convnet, trainingSet, featureLayer, ...
        'MiniBatchSize', 32, 'OutputAs', 'columns');
    
    % Get training labels from the trainingSet
    trainingLabels = trainingSet.Labels;
    
    % Train multiclass SVM classifier using a fast linear solver, and set
    % 'ObservationsIn' to 'columns' to match the arrangement used for training
    % features.
    
    %classifier = fitcecoc(trainingFeatures, trainingLabels, ...
     %   'Learners', 'Linear', 'Coding', 'onevsall', 'ObservationsIn', 'columns');
    classifier = fitensemble(trainingFeatures',trainingLabels,'AdaBoostM1',100,'tree');

    % Extract test features using the CNN
    testFeatures = activations(convnet, testSet, featureLayer, 'MiniBatchSize',32);

    % Pass CNN image features to trained classifier
    predictedLabels = predict(classifier, testFeatures');

    % Get the known labels
    testLabels = testSet.Labels;

    % Tabulate the results using a confusion matrix.
    confMat = confusionmat(testLabels, predictedLabels);

    % Convert confusion matrix into percentage form
    confMat = bsxfun(@rdivide,confMat,sum(confMat,2))
    
    % Display the mean accuracy
    mean(diag(confMat))
    
    
%     % Predict new image
%     newImage = fullfile(rootFolder, 'airplanes', 'image_0690.jpg');
% 
%     % Pre-process the images as required for the CNN
%     img = readAndPreprocessImage(newImage);
% 
%     % Extract image features using the CNN
%     imageFeatures = activations(convnet, img, featureLayer);
%     
%     % Make a prediction using the classifier
%     [label, estimation] = predict(classifier, imageFeatures)
% %end

function Iout = readAndPreprocessImage(filename)

    I = imread(filename);

    % Some images may be grayscale. Replicate the image 3 times to
    % create an RGB image.
    if ismatrix(I)
        I = cat(3,I,I,I);
    end
    
    [p3, p4, b] = size(I);
    q1 = 25; 
    i3_start = floor((p3-q1)/2); % or round instead of floor; using neither gives warning
    i3_stop = ceil((p3+q1)/2);

    i4_start = floor((p4-q1)/2);
    i4_stop = ceil((p4+q1)/2);

    if (i4_start < 1)
        i4_start = 1;
    end
    if (i3_start < 1)
        i3_start = 1;
    end    
    if (i4_stop > size(I,2))
        i4_stop = size(I,2);
    end
    if (i3_stop > size(I,1))
        i3_stop = size(I,1);
    end       

    I = I(i3_start:i3_stop, i4_start:i4_stop, :);

    % Resize the image as required for the CNN.
    Iout = imresize(I, [227 227]);

end