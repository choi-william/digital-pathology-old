function [ features ] = extract_manual_features( im )   

    %format image
    grayIm = im(im~=255);
    binIm = imbinarize(im,254/255);
    
    %calculate centroid
    sumR = 0; sumC = 0; count = 0;
    for i=1:size(binIm,1)
        for j=1:size(binIm,2)
            if (binIm(i,j) == 1)
                count = count+1;
                sumR = sumR + i;
                sumC = sumC + j;
            end
        end
    end
    centroid = round([sumR,sumC]/count);
    
    %calculate moment
    sq = 0;
    for i=1:size(binIm,1)
        for j=1:size(binIm,2)
            if (binIm(i,j) == 1)
                sq = sq + (i-centroid(1))^2 + (j-centroid(2))^2;
            end
        end
    end
    moment = sq/count;
    
    %max inscribed circle
    flag = true;
    r=0;
    while (flag)
        r = r+1;
        nump = 2*pi*r;
        for a=1:nump
            rad = a/r;
            point = round(r*[cos(rad) sin(rad)])+[centroid(1) centroid(2)];
            
            if (point(1)<1 || point(1)>size(binIm,1) || point(2)<1 || point(2)>size(binIm,2))
                flag = false;
                break;
            end
            if (any(isnan(point)))
                flag = false;
                break;
            end
            if (binIm(point(1),point(2)) == 1)
                flag = false;
                break;
            end
        end
    end
    
    %circularity
    perim = bwperim(binIm);
    circularity = sum(perim(:))/sum(binIm(:));
    
    %Discrete Cosine transform
    [f1,f2,f3,f4,f5,f6] = DCT(im);
    mean_f1 = mean2(f1);
    mean_f2 = mean2(f2);
    mean_f3 = mean2(f3);
    mean_f4 = mean2(f4);
    mean_f5 = mean2(f5);
    mean_f6 = mean2(f6);

    std_f1 = std2(f1);
    std_f2 = std2(f2);
    std_f3 = std2(f3);
    std_f4 = std2(f4);
    std_f5 = std2(f5);
    std_f6 = std2(f6);
    
    features = [mean2(im),std2(im),moment,r,circularity, sum(binIm(:))...
            mean_f1, std_f1, mean_f2, std_f2, mean_f3, std_f3, ...
            mean_f4, std_f4, mean_f5, std_f5, mean_f6, std_f6];
end


function [f1,f2,f3,f4,f5,f6] = DCT(grayim)
    % Divide patch into 4 blocks and take Discrete Cosine Transform of it
    D = cell(4);
    endr = size(grayim,1);
    endc = size(grayim,2);
    for i = 1:4
        for j = 1:4
            D{i,j} = dct(im2single(grayim((i-1)*floor(endr/4)+1 : i*floor(endr/4), ...
                                           (j-1)*floor(endc/4)+1 : j*floor(endc/4))));
        end
    end

    f1 = D{1,1};
    f2 = abs(D{2,1});
    f3 = abs(D{1,2});

    f4 = 0;
    for i = 3:4
        for j = 1:2
            f4 = f4+abs(D{i,j})/4;
        end
    end

    f5 = 0;
    for i = 1:2
        for j = 3:4
            f5 = f5+abs(D{i,j})/4;
        end
    end

    f6 = 0;
    for i = 3:4
        for j = 3:4
            f6 = f6+abs(D{i,j})/4;
        end
    end
end

