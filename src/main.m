close all;
clear;

run('init.m');
A = DPImage('A.tif');
B = DPImage('B.tif');
C = DPImage('C.tif');
D = DPImage('D.tif');
E = DPImage('E.tif');

[list,dp] = Prepare.extractSoma(A, 0);
Display.displayOverlay(dp);

%Verify.evaluate(prepare.extractSoma(A, 0));
%Verify.evaluate(prepare.extractSoma(B, 0));
%Verify.evaluate(prepare.extractSoma(C, 0));
%Verify.evaluate(prepare.extractSoma(D, 0));
%Verify.evaluate(prepare.extractSoma(E, 0));

