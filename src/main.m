close all;
clear;

run('init.m');
A = DPImage('A.tif');
B = DPImage('B.tif');
C = DPImage('C.tif');
D = DPImage('D.tif');
E = DPImage('E.tif');

%list = prepare.extractSoma(A, 0);
%figure; imshow(A.image);
%Display.displaySomas(list);

prepare.testPoints.evaluate(prepare.extractSoma(A, 0));
prepare.testPoints.evaluate(prepare.extractSoma(B, 0));
prepare.testPoints.evaluate(prepare.extractSoma(C, 0));
prepare.testPoints.evaluate(prepare.extractSoma(D, 0));
prepare.testPoints.evaluate(prepare.extractSoma(E, 0));

