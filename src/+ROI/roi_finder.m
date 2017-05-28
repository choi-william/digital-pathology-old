function [dpslide] = roi_finder( file_path )

    global TEST_PATH  RESULTS_PATH; 
    
    TEST_PATH    = file_path;
    
    Run;
    
    % InterfaceOutput within Run creates DPslide 
    dpslide = DPslide;
    
    clearvars -except dpslide
    close all
end

