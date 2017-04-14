function [ out ] = smooth_ms( in, l, a, e)
    if nargin == 4       
        out = fastms(in, 'lambda', l, 'alpha', a, 'edge', e);
    elseif nargin == 3
        out = fastms(in, 'lambda', l, 'alpha', a);        
    end
end

