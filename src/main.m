run('init.m');

goodIm = DPImage('tom','152');
% 
% G= [8,152,23,33,44,55,66,71,72,80,81,91,92]
% for i=1:size(G,2)
%    im = Pipeline.import_dp([G(i)],'');
%    Display.display_soma_seg(im);
% end

%allTest = Pipeline.import_dp([],'allVer');

%Verify.evaluate_soma(Segment.Soma.extract_soma(allTest(20),0,0.8,100),2);


pathology_analysis(goodIm,1);
%Display.display_soma_seg([goodIm]);


