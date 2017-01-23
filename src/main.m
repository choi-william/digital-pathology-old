close all;

run('init.m');
A = DPImage('A.tif');
B = DPImage('B.tif');
C = DPImage('C.tif');
D = DPImage('D.tif');
E = DPImage('E.tif');

[mask, list] = prepare.extractSoma(A, 1);
prepare.testPoints.evaluate(list);
