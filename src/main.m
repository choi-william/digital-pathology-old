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

[soma_list,dp] = extract_soma(im23, 0, 0.4, 100);
microglia_list = cell_pipeline(soma_list);

