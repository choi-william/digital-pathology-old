function [ output_args ] = testCellLocations( dpimage )
    % creates an image, and allows a user to generate an array of points that
    % define microlgia locations
    
    global coords;
    coords = [];

    b = imshow(dpimage.image);
    hold on;
    
    set(b,'ButtonDownFcn',@clickPoint)
    
    btn = uicontrol('Style', 'pushbutton', 'String', 'Save',...
        'Callback', @savePoints, 'HorizontalAlignment','center'); 
    
    function savePoints (objectHandle, eventData)
        [FileName,PathName] = uiputfile('*.mat','Save data as');
        saveLoc = strcat(PathName,FileName)
        save(saveLoc,'coords');
    end
    
    function clickPoint (objectHandle , eventData )
       axesHandle  = get(objectHandle,'Parent');
       coordinates = get(axesHandle,'CurrentPoint'); 
       coordinates = coordinates(1,1:2);

       type = get(gcf,'Selectiontype');

       if (strcmp(type,'normal')) %% left click
           plot(coordinates(1,1),coordinates(1,2),'.','MarkerSize',20,'color','green','tag',encode(coordinates));
           coords = [coords; coordinates];
           fprintf('Added point (%.1f,%.1f)\n',coordinates(1,1),coordinates(1,2));
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

    
end

