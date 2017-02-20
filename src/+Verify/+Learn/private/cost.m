function [score] = cost( dps, P )
    score = 0;
    
    %TESTING FUNCTION
    %score = sin(P(1)*pi/2)*sin(P(2)*pi/2) - 1; 
    
    for i=1:size(dps,2)
        score = score + Verify.evaluate_soma(Prepare.extract_soma(dps(i),0,P(1),round(P(2))),0);
    end
    score = score/size(dps,2);
end

