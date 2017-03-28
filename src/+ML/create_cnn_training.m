function [] = create_cnn_training()

    out_path = uigetdir('../../data/output','Choose destination');

    class1 = 'truePositives';
    class2 = 'falsePositives';
    
    mkdir(out_path,class1);
    mkdir(out_path,class2);

    path1 = strcat(out_path,strcat('\',class1));
    path2 = strcat(out_path,strcat('\',class2));

    dps = Pipeline.import_dp([],'trainNosham');
    count=1;
    for i=1:size(dps,2)
        list = Verify.evaluate_soma(Segment.Soma.extract_soma(dps(i),0,0.8,100),0);
        for j=1:size(list,2)
            soma = list{j};

            if (soma.isCorrect == 1)
                imwrite(soma.subImage,strcat(path1,'\',num2str(count),'.tif'));
            elseif (soma.isCorrect == 0)
                imwrite(soma.subImage,strcat(path2,'\',num2str(count),'.tif'));                
            elseif (soma.isCorrect == -1)
            end
            count = count+1;
        end
        fprintf('done %d of %d\n',i,size(dps,2));
    end
   
end

