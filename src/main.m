close all;
clear;

run('init.m');

%A = DPImage('test','A');
%B = DPImage('test','B');
%C = DPImage('test','C');
%D = DPImage('test','D');
%E = DPImage('test','E');


Verify.Learn.learn(100, 0.005, [0 0; 1 1000 ], [0.02 5], [0.6 350] );


%dps = Pipeline.import_dp([],'allver');
%size(dps)
%dps = Pipeline.import_dp([65,48,74,111],'');

%for i=1:5
%    randomInd = round(rand()*(size(dps,2)-1)+1);
%    Verify.evaluate_soma(Prepare.extract_soma(dps(randomInd),0,0.8,100),1);
%end


%[list,dp] = Prepare.extract_soma(A, 0);


%Display.display_overlay(dp);

