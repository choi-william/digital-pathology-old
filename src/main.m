
run('init.m');

%%% IF YOU WANT TO TEST A PARTICULAR BLOCK THAT YOU SAVED FROM THE
%%% VISUALIZATION STEP
% im1 = DPImage('real',[dataPath '/subImage_test' '/11476.tif']);
% im2 = DPImage('real',[dataPath '/subImage_test' '/20685.tif']);
% im3 = DPImage('real',[dataPath '/subImage_test' '/14613.tif']);
% 
% Display.display_stages(im1);
% Display.display_stages(im2);
% Display.display_stages(im3);


%%% IF YOU WANT TO RUN THE FULL ANALYSIS ON AN .SVS or .TIF IMAGE
pathology_analysis(0);


%steps to running:
%
% run the analysis above ^^^^
%
% it will prompt for a slide to analyze, select it
%
% it will prompt for a directory to save analysis, select a folder where
% all the files will go in
%
% the output folder now contains a visualization.mat and a /blockImg folder
%
% move those two files into /data, and run +GUI/main.m to visualize the
% analysis


%TODO:::::
% -optimize the analysis runtime by not rereading every block image file
% from disk. Analysis can be done during the white matter classification
% code.
%
% -optimize classification by not using CNNs (Alex will do this)
%
% -streamline program so that the GUI visualization code is performed
% immediately after analysis





