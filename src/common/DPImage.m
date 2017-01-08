classdef DPImage
    % Digital Pathology Image (DPImage)
    %   A representation of an image relevant to this project that 
    %   also contains relevant metadata
    
    properties
        image %raw image data (3D array)
        
        %file metadata
        
        %slide metadata
        mag %image magnification (multiplication factor)
        
        %injury parameters
        elapsedTime %elapsed time since injury (hours)
        impactEnergy %injury impact energy (J)
    end
    
    methods
        function obj = DPImage(path)
            global config;
            imPath = strcat(config.GetValues('paths', 'imagePath'),path)
            obj.image = imread(imPath);
            
            %TODO - devise a way to import metadata... As of now, the best
            %way I can think of doing this is by having a map file in the
            %data folder that contains all the metadata that the image
            %cannot directly have.
        end        
    end
    
end

