function [ bwIm ] = cell_segmentation( cellIm )
%CELL_SEGMENTATION Summary of this function goes here
%   cellImage - gray scale image of the cell


% IMAGE QUANTIZATION using Otsu's mutilevel iamge thresholding
N = 20; % number of thresholds
thresh = multithresh(cellIm, N);
quantIm = imquantize(cellIm, thresh);

averageIntensity = sum(sum(cellIm))/(size(cellIm,1)*size(cellIm,2));

figure, imshow(label2rgb(quantIm));

% SOMA DETECTION
minSomaSize = 100;
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
figure, scatter(x,numCountedObjects);

% Determining the Backgound level
backgroundLevel = sum(thresh < averageIntensity) - 1;

% Determining the level at which soma appears
firstSomaLevel = find(numCountedObjects > 0, 1, 'first');
somaLevel = firstSomaLevel;
for i = firstSomaLevel+1:backgroundLevel
    if numCountedObjects(i) == numCountedObjects(somaLevel)
        somaLevel = i;
    end
    if somaLevel == backgroundLevel
        somaLevel = round((firstSomaLevel+backgroundLevel)/2); % could potentially be changed
    end
end


figure, imshow(label2rgb(newQuantIm));

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
    fun = @generate_seeds;
    seeds = blockproc(compositeIm, blockSize, fun);
    figure, imshow(seeds);
    
    seedIm = seedIm + seeds*i;
end

figure, imshow(seedIm);

% Minimum spanning tree
% A = newQuantIm <= backgroundLevel;
% B = newQuantIm > 0;
% cellArea =and(A,B);
cellCentroid = zeros(size(cellIm));
cellCentroid([50, 50]) = 1; % TODO:dynamically choose cell centroid

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
    A = newQuantIm <= i;
    B = newQuantIm > 0;
    cellArea =and(A,B);
    seeds = seedIm == i;
    numSeeds = sum(sum(seeds));
    if i == somaLevel
        % root node is one of the seeds in the soma layer
        numSeeds = numSeeds - 1;
    end
    for i = 1:numSeeds
        distTrans = bwdistgeodesic(cellArea, logical(seed), 'quasi-euclidean');
        distTrans1 = distTrans;
        distTrans(isnan(distTrans)) = 0;
        seedDist = distTrans.*seeds;
        minVal = min(seedDist(seedDist > 0));
        [nxtRow, nxtCol] = find(seedDist == minVal, 1);
        
        seeds(currRow, currCol) = 0;
        seed(currRow, currCol) = 0;
        seed(nxtRow, nxtCol) = 1;
        
        if minVal ~= inf
            distTrans2 = bwdistgeodesic(cellArea, logical(seed), 'quasi-euclidean');
            sumDistTrans = distTrans1 + distTrans2;
            sumDistTrans = round(sumDistTrans*8) / 8;
            sumDistTrans(isnan(sumDistTrans)) = inf;
            path = imregionalmin(sumDistTrans);

            thinnedPath = bwmorph(path, 'thin', inf);

            %draw line bettween current coordinates and next coordinate
            finalTree = or(finalTree,thinnedPath);
        end
        
        finalTree(nxtRow, nxtCol) = 1;
        currRow = nxtRow;
        currCol = nxtCol;
    end
    figure, imshow(finalTree);
end
bwIm = finalTree;
figure, imshow(finalTree), title('finalTree');