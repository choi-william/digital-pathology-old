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
F = DPImage('test','F'); %clumps
im23 = DPImage('tom','23');

% 
% shams = import_dp([],'sham');
% reg = import_dp([],'allver');

% for i=1:3
%    randInd = floor(rand()*(size(shams,2)))+1;
%    Verify.evaluate_soma(Prepare.extract_soma( shams(randInd), 0 , 0.8, 100 ),2);
%    title(strcat('Random Sham ',num2str(i)));
% end
% for i=1:5
%    randInd = floor(rand()*(size(reg,2)))+1;
%    Verify.evaluate_soma(Prepare.extract_soma( reg(randInd), 0 , 0.8, 100 ),2);
%    title(strcat('Random image ',num2str(i)));
% end

tic;
pathology_analysis(im23);
toc;
