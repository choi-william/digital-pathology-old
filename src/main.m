run('init.m');
% 
allTest = Pipeline.import_dp([], 'test2');

for i=1:size(allTest,2)
    Verify.evaluate_soma(allTest(i), 2);
end


% data = [];
% for i=1:size(allTest,2)
%     [ updatedList,tp,fp,gt]=Verify.evaluate_soma(allTest(i), 1);
%     data = [data; tp fp gt];
% end
% data;


% Verify.evaluate_soma(allTest(20), 2);


% 
% im23 = DPImage('tom','23');
% % figure, imshow(im23.image,'InitialMagnification','fit');
% % [cell_list, cell_count] = pathology_analysis(im23,1);
% 

%verIm = DPImage('tom','25');
%goodIm = DPImage('tom','152');
testIm = DPImage('tom','265');
G = DPImage('test','G');

%Verify.create(goodIm);
%Display.display_soma_points(testIm);
%Verify.evaluate_soma(G, 2);
% [cell_list,dp] = Segment.Soma.extract_soma(im23, 0, 0.75, 100);

% % for i = 1:10
% %     bwIm = Segment.Processes.process_segmentation(cell_list{44}.subImage, [5,5]);
% % end
% 
% image = Pipeline.import_dp([152],'');
% 
% [cell_list, cell_count] = pathology_analysis(image(1),1);

% 
% G= [8,152,23,33,44,55,66,71,72,80,81,91,92]
% for i=1:size(G,2)
%    im = Pipeline.import_dp([G(i)],'');
%    Display.display_soma_seg(im);
% end

%Verify.evaluate_soma(Segment.Soma.extract_soma(verIm,0,0.8,100),2);

%Verify.evaluate_soma(Segment.Soma.extract_soma(DPImage('tom','117'),2,0.8,100),2);


%[cell_list, cell_count] = pathology_analysis(testIm,1);


% 
% A= [];
% B =[];
% shams = Pipeline.import_dp([],'shamver');
% for i=1:size(shams,2)
%     randomInd = i;
%     im = shams(randomInd);
%     area = sum(im.roiMask(:));
%     tic
%     %Display.display_soma_points(allTest(randomInd));
%     %Verify.evaluate_soma(allTest(randomInd),2);
%     [cell_list, cell_count] = pathology_analysis(im,0);
%     
%     %cell_count = size(im.testPoints,1);
%     A = [A cell_count/area];
%     toc
% end
% 
% notShams = Pipeline.import_dp([],'trainNosham');
% for i=1:size(notShams,2)
%     randomInd = i;
%     im = notShams(randomInd);
%     area = sum(im.roiMask(:));
%     tic
%     %Display.display_soma_points(allTest(randomInd));
%     %Verify.evaluate_soma(allTest(randomInd),2);
%     [cell_list, cell_count] = pathology_analysis(im,0);
%     %cell_count = size(im.testPoints,1);
%     B = [B cell_count/area];
%     toc
% end
% A'
% B'
% 