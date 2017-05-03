function [ output_args ] = display_stages( dp )

    [somaList,dp] = Segment.Soma.extract_soma(dp, 0, 0.8, 100);
    totalIm = [dp.image dp.image repmat(dp.preThresh,1,1,3) repmat(dp.somaMask*255,1,1,3)];
    imshow(totalIm);
    hold on;
    length = size(somaList,2);
    
    for i=1:length
        soma = somaList{i};
        plot(soma.centroid(1),soma.centroid(2),'.','MarkerSize',20,'color','cyan');
    end
end

