classdef DPImage
    % Digital Pathology Image (DPImage)
    %   A representation of an image relevant to this project that 
    %   also contains relevant metadata
    
    properties
        image = 0 %raw image data (3D array)
        
        %file metadata
        filename
        filepath
        id
        originalName

        %verification data
        testPoints = 0;
        
        %soma
        somaMask;
        
        %slide metadata
        mag %image magnification (multiplication factor)
        stain
        time
        age
        date
        group
        
        %injury parameters
        elapsedTime %elapsed time since injury (hours)
        impactEnergy %injury impact energy (J)
    end
    
    methods
        function obj = DPImage(type,id)
            global config;

            

            filename = strcat(id,'.tif');
            
            if strcmp(type,'test')
                imPath = strcat(config.GetValues('paths', 'testPath'),filename);
                verName = strcat(id,'.mat');
                obj.testPoints = load(strcat(config.GetValues('paths', 'testPath'),verName));                 
            elseif strcmp(type,'tom')
    
                imPath = strcat(config.GetValues('paths', 'imagePath'),filename);

                metaPath = strcat(config.GetValues('paths', 'metaPath'),'meta.mat');  
                
                meta = load(metaPath);
                meta = meta.metaData;
                imData = meta(str2num(id));
                
                if (imData.test == -1)
                    error('trying to open a verification file');
                end
                
                %mag = imData.mag; %no magnification info yet
                obj.stain = imData.stain;
                obj.elapsedTime = imData.time;
                obj.age = imData.age;
                obj.date = imData.date;
                obj.group = imData.group;
                
                if (imData.test > 0)
                    verName = strcat('TH',num2str(imData.test),'.mat');
                    obj.testPoints = load(strcat(config.GetValues('paths', 'verPath'),verName));
                    obj.testPoints = obj.testPoints.pointArray; %TODO, this is unnecessary, needs to be corrected in data conversion function
                end
            end
            
            

            obj.filename = filename;
            obj.filepath = imPath;
            obj.image = imread(imPath);
            

    
            %TODO - devise a way to import metadata... As of now, the best
            %way I can think of doing this is by having a map file in the
            %data folder that contains all the metadata that the image
            %cannot directly have.
        end
    end
    
end

