close all;
clear;

run('init.m');
A = DPImage('A.tif');
B = DPImage('B.tif');
C = DPImage('C.tif');
D = DPImage('D.tif');
E = DPImage('E.tif');

[list,dp] = Prepare.extract_soma(A, 0);
Display.display_somas(list);

%Verify.evaluate_soma(prepare.extractSoma(A, 0));
%Verify.evaluate_soma(prepare.extractSoma(B, 0));
%Verify.evaluate_soma(prepare.extractSoma(C, 0));
%Verify.evaluate_soma(prepare.extractSoma(D, 0));
%Verify.evaluate_soma(prepare.extractSoma(E, 0));

