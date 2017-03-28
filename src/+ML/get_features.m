function [] = get_features( dpimages )
%DISTINGUISH Summary of this function goes here
%   Detailed explanation goes here

    list = {};
      
    for i=1:size(dpimages,2)
        
        fprintf('Getting features from %d of %d\n',i,size(dpimages,2));
        

        somalist = Verify.evaluate_soma(Segment.Soma.extract_soma(dpimages(i),0,0.8,100),0);
  
        for j=1:size(somalist,2)
            soma = somalist{j};            
            list{end+1} = DPFeatures(soma);
        end
    end
    save('+ML/soma_features.mat','list');  
end

