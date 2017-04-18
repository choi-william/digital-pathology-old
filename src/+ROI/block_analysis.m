function [] = block_analysis( svs_path, analysis_output_path )

    global TEST_PATH  RESULTS_PATH; 
    
    if (svs_path(end) ~= '/')
       svs_path = [svs_path '/']; 
    end
    if (analysis_output_path(end) ~= '/')
       analysis_output_path = [analysis_output_path '/']; 
    end

    TEST_PATH    = svs_path;
    RESULTS_PATH = analysis_output_path;
    
    run;
    
    clear;
    close all;
end

