function [] = roi_finder( svs_path, analysis_output_path )

    global TEST_PATH  RESULTS_PATH; 
    

    if (analysis_output_path(end) ~= '/')
       analysis_output_path = [analysis_output_path '/']; 
    end

    TEST_PATH    = svs_path;
    RESULTS_PATH = analysis_output_path;
    
    Run;
    
    clear;
    close all;
end

