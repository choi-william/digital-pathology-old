function [ out ] = smooth_ms( in, l, a, e)
    if nargin == 4       
        out = prepare.mumford_shah.fastms(in, 'lambda', l, 'alpha', a, 'edge', e);
    elseif nargin == 3
        out = prepare.mumford_shah.fastms(in, 'lambda', l, 'alpha', a);        
    end
end

