function [] = analyze_features()
%ANALYZE_FEATURES Summary of this function goes here
%   Detailed explanation goes here

    list = load_training_features();
    %list is loaded
    
    A_t = [];
    A_f = [];
    T_t = [];
    T_f = [];
    C_t = [];
    C_f = [];
    
    for j=1:size(list,2)
        fet = list{j};
        
        if (strcmp(fet.classification,'tp'))
            A_t = [A_t fet.area];
            T_t = [T_t fet.thresh];
            C_t = [C_t fet.circularity];
        elseif(strcmp(fet.classification,'fp'))
            A_f = [A_f fet.area];
            T_f = [T_f fet.thresh];
            C_f = [C_f fet.circularity];            
        elseif(~strcmp(fet.classification,'na'))
           fprintf('something bad happened'); 
        end

    end
    

    b_A = linspace(1,max([A_t A_f]),100);
    b_T = linspace(0,255,100);   
    b_C = linspace(1,max([C_t C_f]),100);

    figure;
    [c,d] = hist(A_t,b_A);
    [e,f] = hist(A_f,b_A);
    bar(d,c,'g','facealpha',0.75);hold on;
    bar(f,e,'r','facealpha',0.75);hold off;
    title('area');
    
    figure;
    [c,d] = hist(T_t,b_T);
    [e,f] = hist(T_f,b_T);
    bar(d,c,'g','facealpha',0.75);hold on;
    bar(f,e,'r','facealpha',0.75);hold off;
    title('threshold');

    figure;
    [c,d] = hist(C_t,b_C);
    [e,f] = hist(C_f,b_C);
    bar(d,c,'g','facealpha',0.75);hold on;
    bar(f,e,'r','facealpha',0.75);hold off;
    title('circularity'); 

end

