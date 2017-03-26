function [] = display_soma_points(dp)

    somaList = Segment.Soma.extract_soma(dp, 0, 0.8, 100);
    length = size(somaList,2);
    
    figure;
    imshow(dp.image);
    hold on;
    for i=1:length
        
        soma = somaList{i};
        if (soma.isClump == 0)
            plot(soma.centroid(1),soma.centroid(2),'.','MarkerSize',20,'color','cyan');   
        else
            plot(soma.centroid(1),soma.centroid(2),'.','MarkerSize',20,'color','green');
        end        
    end
    
    h = zeros(2, 1);
    h(1) = plot(NaN,NaN,'cyan','MarkerSize',20);
    h(2) = plot(NaN,NaN,'green','MarkerSize',20);
    legend(h, 'regular','clump');
    
    fprintf('Image %s\n',dp.filename);
end

