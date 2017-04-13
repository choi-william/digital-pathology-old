function [] = create_training_data()

    global dataPath;
    out_path = uigetdir(dataPath,'Choose destination');

    mkdir(out_path, 'test_data');
    out_path = strcat(out_path, '/test_data');

    tp_class = 'truePositives';
    fp_class = 'falsePositives';
    
    mkdir(out_path,tp_class);
    mkdir(out_path,fp_class);

    path_tp = strcat(out_path,strcat('/',tp_class));
    path_fp = strcat(out_path,strcat('/',fp_class));

    dps = Pipeline.import_dp([],'allver');
    num_dpimage = size(dps,2);
    list = {};
    
    count=1;
    for i=1:num_dpimage
        fprintf('Getting features from %d of %d\n',i,num_dpimage);
        cell_list = Verify.evaluate_soma(dps(i),0);
        num_cells = size(cell_list,2);
        
        for j=1:num_cells
            soma = cell_list{j};
            
            if(soma.isCorrect ~= -1)
                dpfeature = DPFeatures(soma);
                image_name = strcat(num2str(count),'.tif');
                dpfeature.subImageName = image_name;
                if (soma.isCorrect == 1)
                    imwrite(soma.subImage,strcat(path_tp,'/',image_name));
                elseif (soma.isCorrect == 0)
                    imwrite(soma.subImage,strcat(path_fp,'/',image_name));
                end
                list{end+1} = dpfeature;
                count = count + 1;
            end
        end
        
        fprintf('done %d of %d\n',i,num_dpimage);
    end
    save(strcat(out_path,'/microglia_features.mat'),'list');  
end

