function [ fp,fn,matchings ] = evaluate(somaList)
    % Performs a comparison between automatic soma segmentation and manual soma
    % segmentation
    
    dp = somaList{1}.referenceDPImage;
        
    fp = ones(size(somaList,1),1);
    fn = ones(size(dp.testPoints,1),1);
    matchings = (-1)*ones(size(somaList,1),2);
    for i=1:size(dp.testPoints)
        tp = round(dp.testPoints(i,:));
        flag = 0;
        for j=1:size(somaList,1)
            soma = somaList{j};
            d = CalcDistance(tp,soma.centroid);
            if (d < soma.maxRadius)
                for k =1:size(soma.pixelList)
                    pixel = soma.pixelList(k,:);
                    if (pixel(1) == tp(1) && pixel(2) == tp(2))
                       matchings(j,:) = tp;   
                       fp(j) = 0;
                       fn(i) = 0;
                       flag = 1;
                       break;   
                    end
                end
                if (flag == 1)
                   break; 
                end
            end
        end
    end
    
    %PLOT SUCCESS VISUALISATION
    figure;
    imshow(dp.somaMask); 
    hold on;
    for j=1:size(fp,1)
        soma = somaList{j};
        
        if (fp(j) == 1)
            plot(soma.centroid(1),soma.centroid(2),'.','MarkerSize',20,'color','red');   
        else
            plot(soma.centroid(1),soma.centroid(2),'.','MarkerSize',20,'color',[1 0 1]);
        end
    end  
    for j=1:size(fn,1)
        if (fn(j) == 1)
            tp =round(dp.testPoints(j,:));
            plot(tp(1),tp(2),'.','MarkerSize',20,'color','blue');
        end
    end
    
    %ALLOWS FOR CUSTOM LEGEND
    h = zeros(3, 1);
    h(1) = plot(NaN,NaN,'.r','MarkerSize',20);
    h(2) = plot(NaN,NaN,'.b','MarkerSize',20);
    h(3) = plot(NaN,NaN,'.','color',[1 0 1],'MarkerSize',20);
    legend(h, 'False Positive','False Negative','Match');
    
    %CALCULATE STATISTICS
    a = size(dp.testPoints,1); %number to find
    b = size(fn,1)-sum(fn); %number found
    c = 100*b/a; %percentage found
    d = sum(fp); %false positives
    
    fprintf('For image %s : Out of %d soma to extract, %d were found (%.0f%%), with %d false positives ',dp.filename,a,b,c,d);
end

