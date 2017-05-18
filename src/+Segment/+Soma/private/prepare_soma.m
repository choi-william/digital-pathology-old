function [dpsomas ] = prepare_soma( dpsoma )


        flag = 0;
        
        MIN_CLUMP_AREA = 1000;

        dpsoma = somaBoundBox(dpsoma,0); %adds box properties to the soma

        dpsoma = cnnTrainBox(dpsoma); %adds CNN training data
        
        % now try to resolve clumps
        
        if (dpsoma.isClump == 0 && dpsoma.area > MIN_CLUMP_AREA)
            [flag,somas] = resolve_clump(dpsoma); 
        end
        
        if (flag == 1)
            dpsomas = somas;
        else
            dpsomas = {dpsoma}; 
        end
end

