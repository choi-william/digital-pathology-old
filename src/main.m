close all;
clear;

run('init.m');

A = DPImage('test','A');
%B = DPImage('test','B');
%C = DPImage('test','C');
%D = DPImage('test','D');
%E = DPImage('test','E');

Pipeline.import_dp([],'allver')

%[list,dp] = Prepare.extractSoma(A, 0);
%Display.displayOverlay(dp);

%Verify.evaluate_soma(prepare.extractSoma(A, 0));
%Verify.evaluate_soma(prepare.extractSoma(B, 0));
%Verify.evaluate_soma(prepare.extractSoma(C, 0));
%Verify.evaluate_soma(prepare.extractSoma(D, 0));
%Verify.evaluate_soma(prepare.extractSoma(E, 0));

