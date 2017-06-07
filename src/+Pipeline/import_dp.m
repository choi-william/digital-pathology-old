% University of British Columbia, Vancouver, 2017
%   Alex Kyriazis
%   William Choi
% 
% Interface to import DPImages by name and query
%

function [ dpims ] = import_dp(varargin)

    p = inputParser;
    
    addOptional(p,'ids',[]);
    addOptional(p,'class','all', @(x) any(validatestring(x,{'all','sham','not_sham'})));
    addOptional(p,'test',-1, @isnumeric);    
    addOptional(p,'setnum',-1, @isnumeric);
    
    parse(p,varargin{:})
    args = p.Results;

    %TODO make this interface more robust to support basic querying. Maybe
    %we should use a querying library?
    
    dpims = [];

    global config;
    imRoot = config.GetValues('paths', 'metaPath');
    metaPath = strcat(imRoot,'meta.mat');    
    meta = load(metaPath);
    meta = meta.metaData;
    

    for i=1:size(meta,1)
        currId = meta(i).id;
        if args.setnum == -1 || (sum(meta(i).testSet == args.setnum) > 0)
            if strcmp(args.class,'all') || (strcmp(meta(i).time,'S') && strcmp('sham',args.class)) || (~strcmp(meta(i).time,'S') && strcmp('not_sham',args.class))         
                if args.test == -1 || meta(i).test == args.test          
                    if isempty(args.ids)
                        dpims = [dpims DPImage('tom',num2str(currId))];                           
                    elseif (any(args.ids == currId))
                        dpims = [dpims DPImage('tom',num2str(currId))];                           
                    end
                end
            end
        end
    end
    
end

