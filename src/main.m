close all;

run('init.m');
A = DPImage('A.tif');
B = DPImage('B.tif');
C = DPImage('C.tif');
D = DPImage('D.tif');
E = DPImage('E.tif');

figure; prepare.extractSoma(A);
figure; prepare.extractSoma(B);
figure; prepare.extractSoma(C);
figure; prepare.extractSoma(D);
figure; prepare.extractSoma(E);



%seg = prepare.mumford.chenvese(adjusted,'whole',1000,1,'multiphase'); % ability on gray image

%-- End 

