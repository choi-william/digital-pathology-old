close all;
clear;

import Prepare.*;
import Display.*;
import Pipeline.*;
import Verify.*;

run('init.m');

A = DPImage('test','A');
B = DPImage('test','B');
C = DPImage('test','C');
D = DPImage('test','D');
E = DPImage('test','E');
im23 = DPImage('tom','23');
figure, imshow(im23.image);
% [cell_list, cell_count] = pathology_analysis(im23);

[cell_list,dp] = Segment.Soma.extract_soma(im23, 0, 0.4, 100);
for i = 1:size(cell_list,2)
    bwIm = Segment.Processes.process_segmentation(cell_list{i}.subImage, [5,5]);
end

% 
% rgbCellImage = im22.image;
%  cellIm = imadjust(rgbCellImage(:,:,3));
%  cellIm = double(cellIm);
% cellIm = fastguidedfilter(cellIm,cellIm, 4, 0.1^2, 4);
% cellIm = cellIm*255;
%     
%     % IMAGE QUANTIZATION using Otsu's mutilevel iamge thresholding
%     N = 15; % number of thresholds % temporary changed to 13 from 20
%     thresh = multithresh(cellIm, N);
%     quantIm = imquantize(cellIm, thresh);
% 
%     averageIntensity = sum(sum(cellIm))/(size(cellIm,1)*size(cellIm,2));
% 
%     % SOMA DETECTION
%     minSomaSize = 100;
%     newQuantIm = zeros(size(cellIm));
% 
%     addedObjects = zeros(size(cellIm));
%     numCountedObjects = zeros(1, N+1);
%     for i = 1:N+1
%         levelIm = quantIm == i;
%         levelIm = levelIm + addedObjects + (newQuantIm>0);
% 
%         countedObjects = bwareaopen(levelIm, minSomaSize)- (newQuantIm>0);
%         addedObjects = xor(levelIm, countedObjects); % removing objects greater than soma size
%     %     CC = bwconncomp(countedObjects);
%     %     numCountedObjects(i) = CC.NumObjects;
% 
%         % size filtered level added to the newly quantized image
%         newQuantIm = newQuantIm + (countedObjects*i);
%         B = newQuantIm ~= 0;
%         CC = bwconncomp(B);
%         numCountedObjects(i) = CC.NumObjects;
% 
%   end
%     toc;
%     figure, imshow(im22.image);
% figure, imshow(label2rgb(quantIm));
% figure,imshow(label2rgb(newQuantIm));
% 
% 
% grayIm = rgb2gray(label2rgb(newQuantIm));
% bwIm = imbinarize(grayIm,0.88);
% 
% bwIm = Helper.sizeFilter(imcomplement(bwIm), 80,500);
% figure,imshow(bwIm);
% 
