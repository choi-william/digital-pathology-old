tic;
fprintf('\n---SLQExampleImageDenoising---\n');
fprintf('loading image... ');

clear;
%%settings
sigma = 30;
scales = 4;
thresholdingFactor = 3;

%%load data
X = imread('barbara.jpg');
X = double(X);

%%add noise
Xnoisy = X + sigma*randn(size(X));

elapsedTime = toc;
fprintf([num2str(elapsedTime), ' s\n']);
tic;
fprintf('decomposition, thresholding and reconstruction... ');

%%decomposition, thresholding and reconstruction
Xrec = SLQdecThreshRec(Xnoisy,4,sigma*[3 3 3 3 3]);

elapsedTime = toc;
fprintf([num2str(elapsedTime), ' s\n']);

PSNR = SLcomputePSNR(X,Xrec);

fprintf(['PSNR: ' num2str(PSNR) '\n']);

%
%  Copyright (c) 2014. Rafael Reisenhofer
%
%  Part of ShearLab3D v1.1
%  Built Mon, 10/11/2014
%  This is Copyrighted Material
%
%  If you use or mention this code in a publication please cite the website www.shearlab.org and the following paper:
%  G. Kutyniok, W.-Q. Lim, R. Reisenhofer
%  ShearLab 3D: Faithful Digital SHearlet Transforms Based on Compactly Supported Shearlets.
%  ACM Trans. Math. Software 42 (2016), Article No.: 5.
