function [ output_args ] = visualize_slide( vis_type )
%VISUALIZE_CELLCOUNT Summary of this function goes here
%   vis_type = 1 cell count
%   vis_type = 2 cell morphology
    global out_path;
    if (isempty(out_path))
        out_path = '../../data';
    end
    vis_path = strcat(out_path, '/visualization.mat');
    load(vis_path,'outputData1','outputData2'); %hardcoded right now
    
    if vis_type == 1
        a = outputData1;
    else
        a = outputData2;
    end

    bg = find(a==-2);
    gm = find(a==-1);
    
    owm = a(a>=0);

    maxval = max(owm(:)); %find maximum intensity
    minval = min(owm(:)); %find maximum intensity

    map = colormap; %get current colormap (usually this will be the default one)
    a = floor((a-minval)./(maxval-minval)*length(map));
    a_copy=ind2rgb(a, map);

    [xbg, ybg] = ind2sub(size(a_copy),bg);
    [xgm, ygm] = ind2sub(size(a_copy),gm);


    for indx = 1:length(xbg)
    a_copy(xbg(indx),ybg(indx),:) = [1 1 1];
    end
    for indx = 1:length(xgm)
    a_copy(xgm(indx),ygm(indx),:) = [0.5 95/255 101/255];
    end

    image(a_copy,'Tag','slideImage');
    colorbar;
    ax = gca;
    box on;
    set(ax,'xtick',[],'ytick',[]);
    ax.XColor = [1 1 1];
    ax.YColor = [1 1 1];

    set (gcf, 'WindowButtonMotionFcn', @mouseMoveSimple);

    
    function [ output_args ] = mouseMoveSimple( src, event )
    %MOUSEMOVESIMPLE Summary of this function goes here
    %   Detailed explanation goes here

        handles = guidata(src);

        cursor = get (handles.axes1, 'CurrentPoint');
        curX = round(cursor(1,1));
        curY = round(cursor(1,2));

        xLimits = get(handles.axes1, 'xlim');
        yLimits = get(handles.axes1, 'ylim');

        if (curX > min(xLimits) && curX < max(xLimits) && curY > min(yLimits) && curY < max(yLimits))
            set(handles.text1, 'String', ['(' num2str(curX) ', ' num2str(curY) ').'])
            
            axes(handles.axes2);
            imagepath = strcat(out_path,'/BlockImg/',num2str(curY+(curX-1)*size(outputData1,1)), '.tif');
            if outputData1(curY,curX) >= 0
                imshow(imagepath);
            else
                imshow('../imunavail.png');
            end
            
            if handles.visCount
                set(handles.text2, 'String', ['Cell Count:  ' num2str(outputData1(curY, curX))])
            elseif handles.visMorph
                set(handles.text2, 'String', ['Cell Morphology:  ' num2str(outputData2(curY, curX))])
            end
        else
            set(handles.text1, 'String', 'Cursor is outside bounds of image.')
        end
    end

end



