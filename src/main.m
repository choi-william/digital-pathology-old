close all;

run('init.m');
A = DPImage('A.tif');
B = DPImage('B.tif');
C = DPImage('C.tif');
D = DPImage('D.tif');
E = DPImage('E.tif');

%list = prepare.extractSoma(A, 0);
%figure; imshow(A.image);
%Display.displaySomas(list);
%prepare.testPoints.evaluate(list);

prepare.testPoints.testCellLocations(B);
