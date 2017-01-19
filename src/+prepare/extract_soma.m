function [output_args] = extract_soma(input_image)
    %figure, imshow(input_image);
    cd /Users/WilliamChoi/Desktop/ENPH459/digital-pathology/src/+prepare/mumford_shah;
    % converting image to gray scale 
    grayIm = rgb2gray(input_image);
    grayIm = imadjust(grayIm);
    
    mumfordIm = fastms(grayIm, 'lambda', 0.6, 'alpha', 300);
    figure, imshow(mumfordIm);
    
    bwIm = imbinarize(mumfordIm, 0.35);
    compIm = imcomplement(bwIm);
    figure, imshow(compIm);
    
    lb_pixel = 40;
    ub_pixel = 500;
    boundedIm = xor(bwareaopen(compIm,lb_pixel),bwareaopen(compIm,ub_pixel));
    
    %somaIm = imcomplement(boundedIm);
    %figure, imshow(somaIm);
    
    finalIm = imoverlay(grayIm, boundedIm,'yellow');
    figure, imshow(finalIm);
    
    figure
    subplot(2,2,1), imshow(input_image);
    subplot(2,2,2), imshow(mumfordIm);
    subplot(2,2,3), imshow(bwIm);
    subplot(2,2,4), imshow(finalIm);
    
    
    %mumfordImProcesses = prepare.mumford_shah.fastms(grayIm, 'lambda', 0.1, 'alpha', 10);
    %bwImProcesses = imbinarize(mumfordImProcesses, 0.5);
    %figure, imshow(mumfordImProcesses);
    %figure, imshow(bwImProcesses);
end