
run('init.m');


% %asma images
% im1 = DPImage('real',[dataPath '\subImage_test' '\1250.tif']);
% im2 = DPImage('real',[dataPath '\subImage_test' '\948.tif']);
% im3 = DPImage('real',[dataPath '\subImage_test' '\912.tif']);

% %rachel images
% im4 = DPImage('real',[dataPath '\subImage_test' '\11476.tif']);
% im5 = DPImage('real',[dataPath '\subImage_test' '\14613.tif']);
 %im6 = DPImage('real',[dataPath '\subImage_test' '\1329.tif']);
 
 %testbox set
% im1 = DPImage('real',[dataPath '\subImage_test' '\11.tif']);
% im2 = DPImage('real',[dataPath '\subImage_test' '\21.tif']);
% im3 = DPImage('real',[dataPath '\subImage_test' '\31.tif']);
% im4 = DPImage('real',[dataPath '\subImage_test' '\12.tif']);
% im5 = DPImage('real',[dataPath '\subImage_test' '\22.tif']);
% im6 = DPImage('real',[dataPath '\subImage_test' '\32.tif']);
% im7 = DPImage('real',[dataPath '\subImage_test' '\13.tif']);
% im8 = DPImage('real',[dataPath '\subImage_test' '\23.tif']);
% im9 = DPImage('real',[dataPath '\subImage_test' '\33.tif']);
% % % 
% Display.display_stages(im1);
% Display.display_stages(im2);
% Display.display_stages(im3);
% Display.display_stages(im4);
% Display.display_stages(im5);
% Display.display_stages(im6);
% Display.display_stages(im7);
% Display.display_stages(im8);
% Display.display_stages(im9);

%DONT WORRY ABOUT THIS%
%run_all_files(0);


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





