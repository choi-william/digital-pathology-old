% University of British Columbia, Vancouver, 2017
%   Alex Kyriazis
%   William Choi
% 
% OUTDATED - this creates training data images and puts them in separate
% folders based on training data from the lab. This training data is not
% too good and does not lead to good classification. 
function [] = create_classification_folders()

    global dataPath;
    out_path = uigetdir(dataPath,'Choose destination');

    mkdir(out_path, 'test_data2');
    out_path = strcat(out_path, '/test_data2');

    tp_class = 'truePositives';
    fp_class = 'falsePositives';
    
    mkdir(out_path,tp_class);
    mkdir(out_path,fp_class);

    path_tp = strcat(out_path,strcat('/',tp_class));
    path_fp = strcat(out_path,strcat('/',fp_class));

    dps = Pipeline.import_dp([],'trainNosham');
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
                    imwrite(soma.cnnBox,strcat(path_tp,'/',image_name));
                elseif (soma.isCorrect == 0)
                    imwrite(soma.cnnBox,strcat(path_fp,'/',image_name));
                end
                list{end+1} = dpfeature;
                count = count + 1;
            end
        end
        
        fprintf('done %d of %d\n',i,num_dpimage);
    end
    save(strcat(out_path,'/microglia_features.mat'),'list');  
end

