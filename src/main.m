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

tic;
pathology_analysis(im23);
toc;
