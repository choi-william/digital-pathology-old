run('init.m');

im23 = DPImage('tom','23');
% figure, imshow(im23.image,'InitialMagnification','fit');
% [cell_list, cell_count] = pathology_analysis(im23,1);

% [cell_list,dp] = Segment.Soma.extract_soma(im23, 0, 0.75, 100);
% for i = 1:10
%     bwIm = Segment.Processes.process_segmentation(cell_list{44}.subImage, [5,5]);
% end

image = Pipeline.import_dp([152],'');

[cell_list, cell_count] = pathology_analysis(image(1),1);

% % Display.display_visual_soma_seg(image(1));

% images = Pipeline.import_dp([],'trainNosham');

% for i=1:5
%      randomInd = floor(rand()*size(images,2))+1;
%      figure; imshow(images(randomInd).image);
%      new = imadjust(imadjust(Tools.smooth_ocbrc(rgb2gray(images(randomInd).image),3)),[0,0.5],[0,1]);
%      figure; imshow(new);
% end

%ML.get_features(images);
% 
%  for i=1:5
%      randomInd = floor(rand()*size(images,2))+1;
%      Verify.evaluate_soma(Segment.Soma.extract_soma(images(randomInd),2,0.9,200),2);
%  end



% 
% [cell_list,dp] = Segment.Soma.extract_soma(im23, 0, 0.4, 100);
% for i = 1:size(cell_list,2)
%     bwIm = Segment.Processes.process_segmentation(cell_list{i}.subImage, [5,5]);
% end
