close all;
clear;

import prepare.*;
import Display.*;
import prepare.fractalDim.*
import prepare.bfilter2.*;
import prepare.guided_filter.*;

run('init.m');
A = DPImage('A.tif');
B = DPImage('B.tif');
C = DPImage('C.tif');
D = DPImage('D.tif');
E = DPImage('E.tif');
cellA = DPImage('test_microglia/cellA.tif');
% figure, imshow(A.image);
% mask =roipoly;
% W = graydiffweight(rgb2gray(A.image), mask, 'GrayDifferenceCutoff', 25);
% thresh = 0.01;
% [BW, D] = imsegfmm(W, mask, thresh);
% figure
% imshow(BW)
% title('Segmented Image')
% 
% cform = makecform('srgb2lab');
% labIm = applycform(cellA.image,cform);
% 
% ab = double(labIm(:,:,2:3));
% nrows = size(ab,1);
% ncols = size(ab,2);
% ab = reshape(ab,nrows*ncols,2);
% 
% nColors = 3;
% [cluster_idx, cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean','Replicates',3);
% pixel_labels = reshape(cluster_idx,nrows,ncols);
% figure, imshow(pixel_labels,[]), title('image labeled by cluster index');
% 
% segmented_images = cell(1,3);
% % rgb_label = repmat(pixel_labels,[1 1 3]);
% 
% for k = 1:nColors
% %     color = cellA.image;
% %     color(rgb_label ~= k) = 0;
% %     segmented_images{k} = color;
% end
% 
% figure, imshow(segmented_images{1}), title('objects in cluster 1');
% figure, imshow(segmented_images{2}), title('objects in cluster 2');
% figure, imshow(segmented_images{3}), title('objects in cluster 3');

% grayIm =rgb2gray(A.image);
% grayIm = imadjust(grayIm);
% laplacian = fspecial('laplacian', 0.2);
% filteredIm = imfilter(grayIm, laplacian, 'replicate');
% 
% sharpenedIm = imadjust(filteredIm,[0; 0.1],[0; 1], 1.1);
% figure, imshow(imsharpen(sharpenedIm));
% 
% medfiltIm = medfilt2(grayIm);
% figure, imshow([grayIm, medfiltIm]);
% 
% figure, imshow(grayIm);

[soma_list,dp] = extract_soma(A, 0);
% for i=1:30
%     figure, imshow(rgb2gray(soma_list{i}.subImage));
%     figure, histogram(rgb2gray(soma_list{i}.subImage));
% end
% 
% grayIm = rgb2gray(cellA.image);
% % grayIm = imadjust(grayIm);
% % figure, imshow(grayIm);
% % grayIm = imguidedfilter(grayIm);
% % % grayIm = bfilter2(double(grayIm)/255, 5, [3 0.1]);
% % figure, imshow(grayIm);
% % grayIm = imsharpen(grayIm);
% % figure,imshow(grayIm);
% 
% se = strel('disk',3);
% 
% 
%     %OPEN BY RECONSTRUCTION%
%     Ie = imerode(grayIm, se);
%     Iobr = imreconstruct(Ie, grayIm);
% 
%     %CLOSE BY RECONSTRUCTION%
%     Iobrd = imdilate(Iobr, se);
%     Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
%     out = imcomplement(Iobrcbr);
% 
% figure, imshow(out);
% out = imadjust(out);    
% % out = imsharpen(out);
% % out = imcomplement(out);
% % figure,imshow(out);
% % figure, imshow(grayIm);
% %     hi = out - imadjust(grayIm);
%     hi = imguidedfilter(out);
%     figure, imshow(hi);
%         hi = imguidedfilter(hi);
% figure, imshow(hi);
% bw = imbinarize(hi, 'adaptive', 'Sensitivity', 0.9);
% figure, imshow(bw);

% display_overlay(dp);

microglia_list = cell_pipeline(soma_list);
% extract_soma(A,0);
% extract_processes(cellA.image, struct('mumfordshah', true));
% Verify.evaluate_soma(prepare.extract_soma(A, 0));
%Verify.evaluate_soma(prepare.extractSoma(B, 0));
%Verify.evaluate_soma(prepare.extractSoma(C, 0));
%Verify.evaluate_soma(prepare.extractSoma(D, 0));
%Verify.evaluate_soma(prepare.extractSoma(E, 0));
