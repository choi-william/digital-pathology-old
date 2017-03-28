run('init.m');

verIm = DPImage('tom','25');
goodIm = DPImage('tom','152');
testIm = DPImage('tom','132');
%Verify.create(goodIm);

% G= [8,152,23,33,44,55,66,71,72,80,81,91,92]
% for i=1:size(G,2)
%    im = Pipeline.import_dp([G(i)],'');
%    Display.display_soma_seg(im);
% end

%Verify.evaluate_soma(Segment.Soma.extract_soma(verIm,0,0.8,100),2);

%Verify.evaluate_soma(Segment.Soma.extract_soma(DPImage('tom','117'),2,0.8,100),2);


allTest = Pipeline.import_dp([],'allver');
ML.get_features(allTest);


% for i=1:1
%     randomInd = ceil(rand()*size(allTest,2));
%     Verify.evaluate_soma(Segment.Soma.extract_soma(allTest(randomInd),0,0.8,100),2);
% end

%pathology_analysis(goodIm,1);
%Display.display_soma_seg([goodIm]);


