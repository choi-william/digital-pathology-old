
addpath(genpath('/Users/WilliamChoi/Desktop/ENPH459/digital-pathology'));

run('init.m');
close all;
imA = DPImage('A.tif');
imB = DPImage('B.tif');
imC = DPImage('C.tif');
imD = DPImage('D.tif');
imE = DPImage('E.tif');

figure, imshow(imA.image);
[mask, list] = prepare.extract_soma(imA);
prepare.testPoints.evaluate(list);

