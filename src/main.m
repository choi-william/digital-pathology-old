run('init.m');

allTest = Pipeline.import_dp([], 'allver');
Verify.evaluate_soma(allTest(20), 2);


% 
% im23 = DPImage('tom','23');
% % figure, imshow(im23.image,'InitialMagnification','fit');
% % [cell_list, cell_count] = pathology_analysis(im23,1);
% 

% Verify.evaluate_soma(im23, 2);
% [cell_list,dp] = Segment.Soma.extract_soma(im23, 0, 0.75, 100);

% % for i = 1:10
% %     bwIm = Segment.Processes.process_segmentation(cell_list{44}.subImage, [5,5]);
% % end
% 
% image = Pipeline.import_dp([152],'');
% 
% [cell_list, cell_count] = pathology_analysis(image(1),1);

% goodIm = DPImage('tom','152');
% 
% G= [8,152,23,33,44,55,66,71,72,80,81,91,92]
% for i=1:size(G,2)
%    im = Pipeline.import_dp([G(i)],'');
%    Display.display_soma_seg(im);
% end

%allTest = Pipeline.import_dp([],'allVer');

%Verify.evaluate_soma(Segment.Soma.extract_soma(allTest(20),0,0.8,100),2);


% pathology_analysis(goodIm,1);
% Display.display_soma_seg([goodIm]);


