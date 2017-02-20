function bwIm = extract_processes( soma_image, options )
%EXTRACTPROCESSES Summary of this function goes here
%   Detailed explanation goes here
%
    import prepare.frangi_filter.*;
    import prepare.bfilter2.*;
    import prepare.guided_filter.*;
    
    default_options = struct('vesselness', false, 'kmeans', false, 'guidedfilter', false, 'mumfordshah', false, 'openclose', false, 'watershed', false, 'fastmarching', false);

    if ~exist('options','var')
        options = default_options;
    else
        tags = fieldnames(default_options);
        for i=1:length(tags)
            if (~isfield(options,tags{i}))
                options.(tags{i}) = default_options.(tags{i});
            end
        end
        if length(tags)~=length(fieldnames(options))
            warning('Extract Processes: Unknown options found.');
        end
    end
   
    % Solely using the blue channel
    grayIm = soma_image(:,:,3);
    grayIm = medfilt2(grayIm); % median filter to remove salt and pepper noise
    adjustedIm = imadjust(grayIm);
    adjustedIm = imsharpen(adjustedIm);

    if options.vesselness
        % Vesselness; frangi filter applied
        I = double(adjustedIm);
        vesselIm = FrangiFilter2D(I);
        bwIm = imcomplement(vesselIm);
    elseif options.kmeans
        % Kmeans on lab color space
        imsegkmeans(soma_image, 2);
    elseif options.guidedfilter
        % Anisotropic smoothing
        downscaledIm = double(grayIm)/255;
        fastguidedIm = fastguidedfilter(downscaledIm,downscaledIm, 4, 0.1^2, 4);
        sharpenedIm = imadjust(fastguidedIm);
        sharpenedIm = imsharpen(sharpenedIm, 'Threshold',0, 'Amount', 2);

        mumfordIm = prepare.mumford_shah.fastms(sharpenedIm, 'lambda', 0.6, 'alpha', 5, 'edges', false);
        
        % Supressing regions with low gradients
        minsupress = imhmin(im2uint8(sharpenedIm), 35);
        figure, imshow([minsupress, imsharpen(minsupress)]);
        minsupress = imadjust(minsupress,[0; 0.6],[0; 1], 1.1);
        enhancedIm = downscaledIm - (downscaledIm-sharpenedIm)*0.5;
        figure, imshow([downscaledIm, fastguidedIm, sharpenedIm, mumfordIm, enhancedIm]);
        figure, imshow(minsupress), title('adjust');
        binaryIm = imbinarize(imsharpen(minsupress), 0.75);
        figure, imshow(binaryIm), title('binarize');
        se1 = strel('rectangle', [1 2]);
        se2 = strel('rectangle', [2,1]);
        bwIm = imdilate(imcomplement(binaryIm), [se1 se2]);
        bwIm = imcomplement(imfill(bwIm, 'holes'));
        figure, imshow(bwIm), title('dilated gradient mask');

        outline = bwperim(bwIm);
        outlinedIm = grayIm;
        outlinedIm(outline) = 255;
        figure, imshow([grayIm, bwIm, outlinedIm]);

    elseif options.mumfordshah
        % Mumford-Shah applied to the grayscale image
        mumfordIm = prepare.mumford_shah.fastms(adjustedIm, 'lambda', 0.07, 'alpha', 1);
%         mumfordIm = prepare.mumford_shah.fastms(mumfordIm, 'lambda', 0.07, 'alpha', 1000);
        mumfordIm = imadjust(mumfordIm,[0; 0.6],[0; 1], 1.1); % remove the blurred regions
        figure, imshow(mumfordIm);
        mumfordIm = imadjust(mumfordIm);
        guidedIm = imguidedfilter(mumfordIm);
        bwIm = imbinarize(guidedIm, 0.75);
        figure, imshow(grayIm);
        figure, imshow(bwIm);
        figure, imshow(guidedIm);
    elseif options.openclose
        % Opening and Closing by reconstruction 
        ocbrIm = smooth_ocbrc(adjustedIm,5);
        guidedIm = imguidedfilter(ocbrIm);
        orgguidedIm = imguidedfilter(grayIm);
        bwIm = imbinarize(ocbrIm,0.35);
        figure,imshow([grayIm,ocbrIm, guidedIm, orgguidedIm]);
        figure, imshow(edge(orgguidedIm, 'Canny'));
    elseif options.watershed
        hy = fspecial('sobel');
        hx = hy';
        Iy = imfilter(double(adjustedIm), hy, 'replicate');
        Ix = imfilter(double(adjustedIm), hx, 'replicate');
        gradmag = sqrt(Ix.^2 + Iy.^2);
        bwIm = grayIm;
        figure,
        imshow([bwIm,gradmag]), title('Gradient magnitude (gradmag)');
   
    elseif options.fastmarching
        guidedIm = imguidedfilter(adjustedIm);
        points = detectHarrisFeatures(guidedIm);
        figure, imshow(grayIm);
        hold on;
        plot(points);
        
        figure, imshow(grayIm);
        [x, y] = getpts;
        mask = false(size(adjustedIm));
        mask(round([x,y])) = true;
%         mask = false(size(adjustedIm));
%         for i = 1:length(points)
%             mask(round(points(i).Location)) = true;
%         end
        W = graydiffweight(guidedIm, mask, 'GrayDifferenceCutoff', 25);
        [bwIm, D] = imsegfmm(W, mask, 0.1);
        figure, imshow(bwIm);
        figure, imshow(D);
        figure, imshow(guidedIm);f
    end

end

