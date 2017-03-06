function [ updatedList ] = evaluate_soma(somaList,shouldPlot)
    % Performs a comparison between automatic soma segmentation and manual soma
    % segmentation
    if (size(somaList,2) == 0)
        score = 100;
        return
        %TODO, this is bad but I am lazy. We should pass the dpimage
        %separately to the soma
    end
    dp = somaList{1}.referenceDPImage;
    
    RM = dp.roiMask;
    if (isscalar(RM))
       RM = ones(size(dp.image(:,:,1)));
    end
        
    fp = ones(size(somaList,2),1);
    fn = ones(size(dp.testPoints,1),1);
    matchings = (-1)*ones(size(somaList,2),2);
    
    
    for i=1:size(dp.testPoints)
        tp = round(dp.testPoints(i,:));
        if (isInROI(tp,RM) == 0)
            fn(i) = -1;
        end    
    end
    for j=1:size(somaList,2)
        soma = somaList{j};
        if (isInROI(soma.centroid,RM) == 0)
            fp(j) = -1;
        end
    end
    
    for i=1:size(dp.testPoints)
        if (fn(i) == -1)
           continue; 
        end
        
        tp = round(dp.testPoints(i,:));
        flag = 0;
        for j=1:size(somaList,2)  
            if (fp(j) == -1)
               continue; 
            end
            
            soma = somaList{j};            
            d = Helper.CalcDistance(tp,soma.centroid);
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
                if (d < 10)
                   matchings(j,:) = tp;   
                   fp(j) = 0;
                   fn(i) = 0;
                   flag = 1;                   
                end
                if (flag == 1)
                   break; 
                end
            end
        end
    end
    
    %PLOT SUCCESS VISUALISATION
    if (shouldPlot == 2)
        figure('units','normalized','outerposition',[0 0 1 1]);
        %subplot(1,3,1);
        %if (~isscalar(dp.ocbrc))
        %    imshow(dp.ocbrc);   
        %end
        %subplot(1,3,2);
        %imshow(dp.somaMask);         
        %subplot(1,3,3);
        imshow(dp.image); 
        hold on;
        for j=1:size(fp,1)
            soma = somaList{j};

            if (fp(j) == 1)
                plot(soma.centroid(1),soma.centroid(2),'.','MarkerSize',20,'color','red');   
            elseif (fp(j) == 0)
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
    end
    
    %CALCULATE STATISTICS
    a = size(fn(fn>=0),1); %number to find
    b = size(fn(fn>=0),1)-sum(fn(fn>=0)); %number found
    c = 100*b/a; %percentage found
    d = sum(fp(fp>=0)); %false positives
    score = 100*(sum(fp(fp>=0))+2*sum(fn(fn>=0)))/a;
    
    if (shouldPlot ~= 0)
        fprintf('For image %s : %d soma to extract, %d were found (%.0f%%), with %d false positives. Score: %.0f\n',dp.filename,a,b,c,d,score);
    end
    
    for j=1:size(somaList,2)
        if (fp(j) == 0)
             somaList{j}.isCorrect = 1;
        elseif (fp(j) == 1)
             somaList{j}.isCorrect = 0;
        else
             somaList{j}.isCorrect = fp(j); %-1 case
        end
    end   
    updatedList = somaList;
end

