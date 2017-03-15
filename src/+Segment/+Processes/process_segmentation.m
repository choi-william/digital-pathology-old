function [ bwIm ] = process_segmentation( rgbCellImage, cellCentroid )
%CELL_SEGMENTATION Summary of this function goes here
%   dpsoma - input soma object

    cellIm = imadjust(rgbCellImage(:,:,3));
    centroid = round(cellCentroid);
    centroid = [5, 5]; % to be removed once centroid is adjusted
    averageIntensity = sum(sum(cellIm))/(size(cellIm,1)*size(cellIm,2));
    cellIm = imadjust(cellIm,[0; averageIntensity/255],[0; 1]); % removing pixels above average intensity
    
    % IMAGE QUANTIZATION using Otsu's mutilevel iamge thresholding
    N = 15; % number of thresholds % temporary changed to 13 from 20
    thresh = multithresh(cellIm, N);
    quantIm = imquantize(cellIm, thresh);

    averageIntensity = sum(sum(cellIm))/(size(cellIm,1)*size(cellIm,2));

    % SOMA DETECTION
    minSomaSize = 50;
    newQuantIm = zeros(size(cellIm));

    addedObjects = zeros(size(cellIm));
    numCountedObjects = zeros(1, N+1);
    for i = 1:N+1
        levelIm = quantIm == i;
        levelIm = levelIm + addedObjects + (newQuantIm>0);

        countedObjects = bwareaopen(levelIm, minSomaSize)- (newQuantIm>0);
        addedObjects = xor(levelIm, countedObjects); % removing objects greater than soma size
    %     CC = bwconncomp(countedObjects);
    %     numCountedObjects(i) = CC.NumObjects;

        % size filtered level added to the newly quantized image
        newQuantIm = newQuantIm + (countedObjects*i);
        B = newQuantIm ~= 0;
        CC = bwconncomp(B);
        numCountedObjects(i) = CC.NumObjects;

    end

    x = 1:N+1;
%     figure, scatter(x,numCountedObjects);

    % Determining the Backgound level
    backgroundLevel = sum(thresh < averageIntensity);

    % Determining the level at which soma appears
    firstSomaLevel = find(numCountedObjects > 0, 1, 'first');
    lastSomaLevel = firstSomaLevel;
    for i = firstSomaLevel+1:backgroundLevel
        if numCountedObjects(i) == numCountedObjects(lastSomaLevel)
            lastSomaLevel = i;
        end
        if lastSomaLevel == backgroundLevel
            lastSomaLevel = round((firstSomaLevel+backgroundLevel)/2); % could potentially be changed
        end
    end

    somaLevel = round((firstSomaLevel + lastSomaLevel)/2);

    subplot(6,5,[1,7]), imshow(rgbCellImage), title('Original Image');
    subplot(6,5,[11,17]), imshow(label2rgb(quantIm)), title('Quantized Image');
    subplot(6,5,[21,27]), imshow(zeros(size(quantIm))+255), title('Final Binarized Image');
    subplot(6,5,[18,30]), imshow(zeros(size(newQuantIm)));
    
    % SEED SAMPLING at each quantized level
    seedIm = zeros(size(cellIm));
    for i = somaLevel:backgroundLevel
        levelIm = newQuantIm == i; 
        if i == somaLevel
            A = newQuantIm > 0;
            B = newQuantIm <= somaLevel;
            levelIm = and(A,B);
            % seeds will be sampled from the perimeter of the soma 
            levelIm = bwperim(levelIm); % 4 connectivity (default)
        end
        originalIm = cellIm;
        originalIm(imcomplement(levelIm)) = 255; % overlaying binary mask on the original image
        compositeIm = cat(3,levelIm,originalIm);

        blockSize = [i+2-somaLevel i+2-somaLevel];
        func = @generate_seeds;
        seeds = blockproc(compositeIm, blockSize, func);
        
        seedIm = seedIm + seeds*i;
        
        subplot(6,5, [3,15]);
        imshow(seedIm); % uncomment to see seeds at each stage
        hold on;
        pause(0.02);
    end



    % Minimum spanning tree
    cellCentroid = zeros(size(cellIm));
    cellCentroid(centroid) = 1; 

    centroidDistTrans = bwdist(cellCentroid, 'quasi-euclidean');
    somaLayer = seedIm == somaLevel;
    somaSeedDist = centroidDistTrans.*somaLayer;
    minVal = min(somaSeedDist(somaSeedDist > 0));
    [rootRow, rootCol] = find(somaSeedDist == minVal, 1); % root node;

    seed = zeros(size(cellIm));
    seed(rootRow, rootCol) = 1;
    currRow = rootRow;
    currCol = rootCol;

    finalTree = zeros(size(cellIm));
    finalTree(rootRow, rootCol) = 1;
    
    for i = somaLevel:backgroundLevel
        seeds = seedIm == i;
        numSeeds = sum(sum(seeds));
        if i ~= somaLevel
            levelIm = newQuantIm == i;
            if i <= round((somaLevel*2+backgroundLevel)/3)
                cellArea = cellArea + levelIm.*(i+1-somaLevel);
            elseif i <= round((somaLevel+2*backgroundLevel)/3)
                cellArea = cellArea + levelIm.*(i+1-somaLevel)^2;
            else
                cellArea = cellArea + levelIm.*(i+1-somaLevel)^3;
            end
        else
            A = newQuantIm <= somaLevel;
            B = newQuantIm > 0;
            cellArea  = and(A,B);
            % root node is one of the seeds in the soma layer
            numSeeds = numSeeds - 1;
        end
        
        mask = double(cellArea);
        mask(mask == 0) = inf;

        distTrans1 = graydist(mask, logical(seed), 'quasi-euclidean');
        
        for i = 1:numSeeds
            seedDist = distTrans1.*seeds; % no need to worry about inf as seeds are all in the mask area
            seedDist(isnan(seedDist)) = 0;
            minVal = min(seedDist(seedDist > 0));
            [nxtRow, nxtCol] = find(seedDist == minVal, 1);

            seeds(currRow, currCol) = 0;
            seed(currRow, currCol) = 0;
            seed(nxtRow, nxtCol) = 1;

            distTrans2 = graydist(mask, logical(seed), 'quasi-euclidean');

            if minVal ~= inf
                sumDistTrans = distTrans1 + distTrans2;
                sumDistTrans = round(sumDistTrans.*8) / 8;
                path = imregionalmin(sumDistTrans);

                thinnedPath = bwmorph(path, 'thin', inf);

                %draw line bettween current coordinates and next coordinate
                finalTree = or(finalTree,thinnedPath);
            end

            distTrans1 = distTrans2;

            finalTree(nxtRow, nxtCol) = 1;
            currRow = nxtRow;
            currCol = nxtCol;
        end
        subplot(6,5,[18,30]);
        imshow(finalTree); % uncomment to see the tree at each stage
        hold on;
        pause(0.001);
    end

    % overlaying the soma image on the tree
    A = newQuantIm > 0;
    B = newQuantIm <= somaLevel;
    somaIm = and(A,B);
    finalTree =  or(finalTree, somaIm); 

    % filling small holes
    filled = imfill(finalTree,'holes');
    holes = and(filled, ~finalTree);
    bigHoles = bwareaopen(holes, 15); % 15 pixel size limit on holes
    smallHoles = and(holes, ~bigHoles);
    bwIm = imcomplement(or(finalTree, smallHoles));

    % pruning - should be improved
    bwIm = bwmorph(bwIm, 'spur', 5);
    
    
    subplot(6,5,[21,27]), imshow(bwIm), title('Final Connected Tree');
    pause(0.3);
%     figure; 
%     subplot(2,3,1), imshow(rgbCellImage), title('Original Image');
%     subplot(2,3,2), imshow(label2rgb(quantIm)), title('Quantized Image');
%     subplot(2,3,3), imshow(label2rgb(newQuantIm)), title('Newly Quantized Image');
%     subplot(2,3,4), imshow(seedIm), title('Seed Image');
%     subplot(2,3,5), imshow(bwIm), title('Final Connected Tree');
end
