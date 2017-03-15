function [P_f, C ] = learn(iterations, step_length, bounds, p_jump, P_o )

    %iterations is number of iterations
    %p_jump is the scale of the basic jump unit for each parameters
    %P_o is the initial parameters
    %bounds are the min and max bounds of each parameters
    %step_length represents the maximum step traversal represented as a
    %   decimal percentage of bound size

    dps = Pipeline.import_dp([],'trainNosham');
    size(dps);
    P = zeros(iterations,size(P_o,2));
    P(1,:) = P_o; %initial parameters
    
    C = zeros(iterations,1);
    G = zeros(size(P_o,2),1);
    
    B = bounds(2,:) - bounds(1,:);
    
    for i=1:iterations
       C(i) = cost(dps,P(i,:));
       fprintf('Score (i=%d): %f with (%f,%f)\n',i,C(i),P(i,1),P(i,2));
      
       for j = 1:size(P_o,2) %calculate gradients
           b=zeros(1,size(p_jump,2));
           b(j) = 1;
           dP = b.*p_jump;
           G(j) = (cost(dps, P(i,:)+dP)-C(i))/(sum(dP));
       end
       G = G.*B'; %to correct for gradient biasing
       G = G.*B'; %to correct for how parameters are adjusted
       
       if (norm(G) == 0)
           fprintf('hit a gradient 0 point\n');
           break;
       end
       
       G = (G)*step_length/norm(G./B');
       
       if (i == iterations)
           P_f = P(i,:);
           break;
       end
       
       P(i+1,:) = P(i,:) - G';
       
       for j = 1:size(P_o,2)
          if (P(i+1,j) < bounds(1,j))
             P(i+1,j) = bounds(1,j); 
          end
          if (P(i+1,j) > bounds(2,j))
             P(i+1,j) = bounds(2,j);
          end
       end
    end

end

