function [ output_args ] = display_stages( dp )
    figure;
    thresh = (dp.avInt*0.3+25)/100;
 
%     thresh = (dp.avInt*0.3+25)/100 +0.05;
    
    [somaList,dp] = Segment.Soma.extract_soma(dp, 1, thresh, 80);
    totalIm = [dp.image dp.image repmat(dp.preThresh,1,1,3) repmat(dp.rawThresh*255,1,1,3) repmat(dp.somaMask*255,1,1,3)];
    imshow(totalIm);
    hold on;
    length = size(somaList,2);
    
    for i=1:length
        soma = somaList{i};
        if (soma.isFalsePositive == 1)
            plot(soma.centroid(1),soma.centroid(2),'.','MarkerSize',20,'color','red');
        else
            plot(soma.centroid(1),soma.centroid(2),'.','MarkerSize',20,'color','cyan');
        end 
        if (soma.isClump==1)
            plot(soma.centroid(1),soma.centroid(2),'.','MarkerSize',10,'color','black');            
        end
    end
    
    h = zeros(2, 1);
    h(1) = plot(NaN,NaN,'cyan','MarkerSize',20);
    h(2) = plot(NaN,NaN,'red','MarkerSize',20);
    legend(h, 'true positive','false positive');
    
    
end

