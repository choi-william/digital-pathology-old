function [dpslide] = roi_finder( file_path, analysis_output_path )

    global TEST_PATH  RESULTS_PATH; 
    

    if (analysis_output_path(end) ~= '/')
       analysis_output_path = [analysis_output_path '/']; 
    end

    TEST_PATH    = file_path;
    RESULTS_PATH = analysis_output_path;
    
    Run;
    
    % InterfaceOutput within Run creates DPslide 
    dpslide = DPslide;
    
    clearvars -except dpslide
    close all
end

