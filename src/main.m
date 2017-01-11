run('init.m');
im = DPImage('A.tif');

% converting image to grayscale
grayIm = rgb2gray(im.image);
A = size(grayIm);
figure, imhist(grayIm);
figure, imshow(grayIm);

% T = adaptthresh(grayIm);
% global thresholding Otsu's Method
BW = imbinarize(grayIm);
figure, imshow(BW);
%thresIm = imregionalmax(I,26);
%imshow(thresIm);

