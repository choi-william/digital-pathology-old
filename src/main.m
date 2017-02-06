close all;
clear;

import prepare.*;
import Display.*;

run('init.m');
A = DPImage('A.tif');
B = DPImage('B.tif');
C = DPImage('C.tif');
D = DPImage('D.tif');
E = DPImage('E.tif');

[soma_list,dp] = extract_soma(A, 0);
display_overlay(dp);
microglia_list = cell_pipeline(soma_list);

%Verify.evaluate_soma(prepare.extractSoma(A, 0));
%Verify.evaluate_soma(prepare.extractSoma(B, 0));
%Verify.evaluate_soma(prepare.extractSoma(C, 0));
%Verify.evaluate_soma(prepare.extractSoma(D, 0));
%Verify.evaluate_soma(prepare.extractSoma(E, 0));
