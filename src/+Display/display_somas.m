function [] = display_somas( somaList )
    %Displays soma subarray
    
    length = size(somaList,1);
    width = ceil(sqrt(length));
    height = ceil(length/width);
    
    figure;
    for i=1:length
        if i == round((length/100)*ceil(100*i/length))
            fprintf('%d%%\n',round(i*100/length));
        end
        
        soma = somaList{i};
        subplot(height,width,i), 
        subimage(soma.subImage);
        set(gca,'visible','off');
    end


end

