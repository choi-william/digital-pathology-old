close all;
clear;

import Prepare.*;
import Display.*;

run('init.m');

A = DPImage('test','A');
B = DPImage('test','B');
C = DPImage('test','C');
D = DPImage('test','D');
E = DPImage('test','E');
cellA  = imread('cellA.tif');
cellB  = imread('cellB.tif');f
im23 = DPImage('tom','23');

% [soma_list,dp] = extract_soma(im23, 0, 0.4, 100);
% microglia_list = cell_pipeline(soma_list);
% 
% % for i =1:1
%   i = 8;
%     figure,
%     subplot(1,3,1), imshow(microglia_list{i}.binaryIm);
%     subplot(1,3,2), imshow(microglia_list{i}.skelIm);
%     subplot(1,3,3), imshow(microglia_list{i}.referenceDPSoma.subImage);
% % end

% Verify.Learn.learn(100, 0.005, [0 0; 1 1000 ], [0.02 5], [0.6 350] );


dps = Pipeline.import_dp([],'allver');
size(dps)
dps = Pipeline.import_dp([65,48,74,111],'');

for i=1:5
   randomInd = round(rand()*(size(dps,2)-1)+1);
   Verify.evaluate_soma(Prepare.extract_soma(dps(randomInd),0,0.8,100),1);
end


[list,dp] = Prepare.extract_soma(A, 0);


Display.display_overlay(dp);
