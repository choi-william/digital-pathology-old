close all;

run('init.m');
im = DPImage('A.tif');

% converting image to grayscale
grayIm = rgb2gray(im.image);
%A = size(grayIm);
%figure, imhist(grayIm);
%figure, imshow(grayIm);

seg = prepare.mumford.chenvese(im.image,'whole',400,0.1,'multiphase'); % ability on gray image

%T = adaptthresh(grayIm);
% global thresholding Otsu's Method
%BW = imbinarize(grayIm,60/255);
%figure, imshow(BW);
%thresIm = imregionalmax(I,26);
%imshow(thresIm);

%-- End 

