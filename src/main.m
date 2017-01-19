
addpath(genpath('/Users/WilliamChoi/Desktop/ENPH459/digital-pathology'));

run('init.m');
imA = DPImage('A.tif');
imB = DPImage('B.tif');
imC = DPImage('C.tif');
imD = DPImage('D.tif');
imE = DPImage('E.tif');

figure, imshow(imA.image);
prepare.extract_soma(imA.image);
%BW = rgb2gray(imA.image);
%cannyIm = edge(BW, 'Canny',0.35);
%figure, imshow(imA.image);
%figure, imshow(cannyIm);
%prepare.extract_soma(imB.image);
%prepare.extract_soma(imC.image);
%prepare.extract_soma(imD.image);
%prepare.extract_soma(imE.image);
%converting image to grayscale
%grayIm = rgb2gray(im.image);
%A = size(grayIm);
%figure, imhist(grayIm);
%figure, imshow(grayIm);

% T = adaptthresh(grayIm);
% global thresholding Otsu's Method
%BW = imbinarize(grayIm);
%figure, imshow(BW);
%thresIm = imregionalmax(I,26);
%imshow(thresIm);

