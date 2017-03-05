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
F = DPImage('test','F'); %clumps


%[soma_list,dp] = extract_soma(A, 0, 0.4, 100);
% microglia_list = cell_pipeline(soma_list);

%extract_processes(soma_list{35}.subImage,struct('vesselness',true));

% Verify.Learn.learn(100, 0.005, [0 0; 1 1000 ], [0.02 5], [0.6 350] );

clu = Pipeline.import_dp([56],'');
tic
Display.display_soma_points(Prepare.extract_soma(clu(1),0,0.8,100));
toc
%dps = Pipeline.import_dp([],'allver');

%Display.display_soma_points(Prepare.extract_soma(F,0,0.8,100));

%dps = Pipeline.import_dp([65,48,74,111],'');

%for i=1:5
%    randomInd = round(rand()*(size(dps,2)-1)+1);
%    Display.display_soma_points(Prepare.extract_soma(dps(randomInd),0,0.8,100));
%end

% for i=1:5
%     randomInd = round(rand()*(size(dps,2)-1)+1);
%     Verify.evaluate_soma(Prepare.extract_soma(dps(randomInd),0,0.8,100),2);
%     
% end

%AAA = [];
%randomInd = round(rand()*(size(dps,2)-1)+1);
%[list,dp] = Prepare.extract_soma(dps(randomInd),0,0.8,100);
%for i=1:size(list,1)
%    AAA= [AAA; list{i}.area];
%end


%Display.display_overlay(dp);
