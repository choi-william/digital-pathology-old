run('init.m');
% 
% allTest = Pipeline.import_dp([], 'allver');
% Verify.evaluate_soma(allTest(20), 2);


% 
% im23 = DPImage('tom','23');
% % figure, imshow(im23.image,'InitialMagnification','fit');
% % [cell_list, cell_count] = pathology_analysis(im23,1);
% 

verIm = DPImage('tom','25');
goodIm = DPImage('tom','152');
testIm = DPImage('tom','132');
%Verify.create(goodIm);

% Verify.evaluate_soma(im23, 2);
% [cell_list,dp] = Segment.Soma.extract_soma(im23, 0, 0.75, 100);

% % for i = 1:10
% %     bwIm = Segment.Processes.process_segmentation(cell_list{44}.subImage, [5,5]);
% % end
% 
% image = Pipeline.import_dp([152],'');
% 
% [cell_list, cell_count] = pathology_analysis(image(1),1);

goodIm = DPImage('tom','132');
% 
% G= [8,152,23,33,44,55,66,71,72,80,81,91,92]
% for i=1:size(G,2)
%    im = Pipeline.import_dp([G(i)],'');
%    Display.display_soma_seg(im);
% end

%Verify.evaluate_soma(Segment.Soma.extract_soma(verIm,0,0.8,100),2);

%Verify.evaluate_soma(Segment.Soma.extract_soma(DPImage('tom','117'),2,0.8,100),2);


allTest = Pipeline.import_dp([],'trainNosham');
ML.get_features(allTest);


% for i=1:1
%     randomInd = ceil(rand()*size(allTest,2));
%     Verify.evaluate_soma(Segment.Soma.extract_soma(allTest(randomInd),0,0.8,100),2);
% end
