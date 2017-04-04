function [ dpims ] = import_dp(ids,action)

    %TODO make this interface more robust to support basic querying. Maybe
    %we should use a querying library?
    
    dpims = [];

    global config;
    imRoot = config.GetValues('paths', 'metaPath');
    metaPath = strcat(imRoot,'meta.mat');    
    meta = load(metaPath);
    meta = meta.metaData;
    
    if strcmp(action,'all') %%return all images%%
        for i=1:size(meta,1)
            newDP = DPImage('tom',num2str(meta(i).id));
            dpims = [dpims newDP];            
        end        
    elseif strcmp(action,'allver') %%return all images with test data%%
         for i=1:size(meta,1)
            if (meta(i).roi == 1 && meta(i).test == 1)
                newDP = DPImage('tom',num2str(meta(i).id));
                dpims = [dpims newDP];   
            end
         end 
    elseif strcmp(action,'shamver') %%return all sham images with training data%%
        for i=1:size(meta,1)
            if (strcmp(meta(i).time,'S'))
                if (meta(i).roi == 1 && meta(i).test == 1)
                    newDP = DPImage('tom',num2str(meta(i).id));
                    dpims = [dpims newDP];             
                end
            end
        end 

    elseif strcmp(action,'allsham') %%return all sham images with training data%%
        for i=1:size(meta,1)
            if (strcmp(meta(i).time,'S'))
                newDP = DPImage('tom',num2str(meta(i).id));
                dpims = [dpims newDP];             
            end
        end  
    elseif strcmp(action,'trainNosham') %%return all sham images%%
         for i=1:size(meta,1)
            if (meta(i).roi == 1 && meta(i).test && ~strcmp(meta(i).time,'S'))
                newDP = DPImage('tom',num2str(meta(i).id));
                dpims = [dpims newDP];   
            end
         end 
    else %%return images that have corresponding test data%%
        
        %TODO, this searching algorithm is terrible. Should be improved.
        for i=1:size(meta,1)
            currId = meta(i).id;
            if (any(ids == currId))
                ids = ids(find(ids~=currId));
                newDP = DPImage('tom',num2str(currId));
                dpims = [dpims newDP];   
            end
        end
    end
end

