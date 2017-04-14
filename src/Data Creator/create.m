% creates an image, and allows a user to generate an array of points that
% define microlgia locations

close all;
clear;

global name; 
global coords; 
global image;
global roiPoints;
global out_path;
global roiMask;

%file management
[f,p] = uigetfile('*.tif','Select the .tif image file');
image = imread(strcat(p,f));
name = f(1:end-4);
out_path = uigetdir('','Choose output data destination');


%FOR GETTING ROI DATA
a = imshow(image);
title('SELECT ROI');
roiPoints = [];

set(a,'ButtonDownFcn',@roiPoint)

btn_a = uicontrol('Style', 'pushbutton', 'String', 'Done',...
    'Callback', @closeRoi, 'HorizontalAlignment','center');

waitfor(gcf);

%FOR GETTING TEST POINTS
coords = [];

onlyRoi = image;
onlyRoi(roiMask == 0) = 255;
b = imshow(onlyRoi);
title('SELECT MICROGLIA');

hold on;
set(b,'ButtonDownFcn',@clickPoint)
btn = uicontrol('Style', 'pushbutton', 'String', 'Save',...
    'Callback', @savePoints, 'HorizontalAlignment','center'); 

function savePoints (objectHandle, eventData)
    global out_path;
    global name; 
    global coords; 
    global image;
    global roiPoints;    
    global roiMask;

    data = coords;
    save(strcat(out_path,'/TH',name,'.mat'),'data');               

    data = roiMask;
    save(strcat(out_path,'/ROI',name,'.mat'),'data');
    
    close all;
end

function roiPoint (objectHandle , eventData )
   axesHandle  = get(objectHandle,'Parent');
   coordinates = get(axesHandle,'CurrentPoint'); 
   coordinates = coordinates(1,1:2);

   type = get(gcf,'Selectiontype');
   
   global roiPoints;

   if (strcmp(type,'normal')) %% left click
       roiPoints = [roiPoints; coordinates];

       handle = findobj('tag', 'poly');   
       delete(handle);
       
       patch(roiPoints(:,1),roiPoints(:,2),'green','tag','poly','FaceAlpha',0.3);
       
   end
end

function closeRoi(objectHandle , eventData )

    global roiPoints;
    global roiMask;
    global image;
    
    roiMask = poly2mask(roiPoints(:,1),roiPoints(:,2),size(image,1),size(image,2));
    close all;
end

function clickPoint (objectHandle , eventData )
   axesHandle  = get(objectHandle,'Parent');
   coordinates = get(axesHandle,'CurrentPoint'); 
   coordinates = coordinates(1,1:2);

   type = get(gcf,'Selectiontype');
   
   global coords;
   global roiMask;

   if (strcmp(type,'normal')) %% left click
       
       if (roiMask(round(coordinates(1,2)),round(coordinates(1,1))))
         
           plot(coordinates(1,1),coordinates(1,2),'.','MarkerSize',20,'color','green','tag',encode(coordinates));
           coords = [coords; coordinates];
           fprintf('Added point (%.1f,%.1f)\n',coordinates(1,1),coordinates(1,2));         
       else
           fprintf('WARNING: OUTSIDE OF ROI - NOT ADDED\n');         
       end

   elseif (strcmp(type,'alt')) %% right click
       minTest = intmax;
       closestPointInd = -1;
       for i=1:size(coords,1)
           point = coords(i,:);
           d = Helper.CalcDistance(point,coordinates);
           if d < minTest
              minTest = d;
              closestPointInd = i;
           end
       end
       %delete point
       if (closestPointInd ~= -1)
           dpoint = coords(closestPointInd,:);
           id = encode(dpoint);
           obj = (findobj(gca,'tag',id));
           delete(obj);
           coords(closestPointInd,:)= [];
           fprintf('Deleted point (%.1f,%.1f)\n',dpoint(1,1),dpoint(1,2));

       end
   end

   function b = encode(coord)
       b = strcat(num2str(coord(1,1)),'|',num2str(coord(1,2)));
   end
end


