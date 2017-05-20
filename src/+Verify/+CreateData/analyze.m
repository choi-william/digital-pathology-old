function [ output_args ] = analyze( dp,id_param )


    thresh = (dp.avInt*0.3+25)/100 +0.05;

    somaList = Segment.Soma.extract_soma(dp, 0, 0.8, thresh);
    length = size(somaList,2);
    
    figure;
    b = imshow([dp.image dp.image]);
    hold on;
    
    %brings in 'data'
    data=[];
    load('+Verify/+CreateData/classification_data_asma.mat');
    
    global P;
    P = [];
    for i=1:length
        soma = somaList{i};
        plot(soma.centroid(1),soma.centroid(2),'.','MarkerSize',20,'color','green','tag',encode([soma.centroid(1) soma.centroid(2)]));
        P = [P; soma.centroid(1) soma.centroid(2) 0];
    end
    
    set(b,'ButtonDownFcn',@clickPoint)
    btn = uicontrol('Style', 'pushbutton', 'String', 'Save',...
        'Callback', @savePoints, 'HorizontalAlignment','center');
    
    
    fprintf('Image %s\n',dp.filename);
    
    function savePoints (objectHandle, eventData)
        
        for j=1:size(P,1)
            if P(j,3) == 1 || P(j,3) == -1
               data = [data; P(j,3) id_param P(j,1) P(j,2)];  
            end
        end
        
        close all;
        save('+Verify/+CreateData/classification_data_asma.mat','data');
    end
    
    function clickPoint (objectHandle , eventData )
       axesHandle  = get(objectHandle,'Parent');
       coordinates = get(axesHandle,'CurrentPoint'); 
       coordinates = coordinates(1,1:2);
       

       type = get(gcf,'Selectiontype');

       if (strcmp(type,'normal')) %% left click
           %plot(coordinates(1,1),coordinates(1,2),'.','MarkerSize',20,'color','green','tag',);

           closestPointInd = -1;
           minTest = intmax;
           for i=1:size(P,1)
               A = P(i,:);
               x = A(1);
               y = A(2);
               c = A(3);
               point = [x y];
               d = Helper.CalcDistance(point,coordinates);
               if d < minTest
                  minTest = d;
                  closestPointInd = i;
               end
           end
           
           if (closestPointInd ~= -1)
               
               A = P(closestPointInd,:);
               x = A(1);
               y = A(2);
               c = A(3);
               
               id = encode([x y]);
               obj = (findobj(gca,'tag',id));
               

               
               c = c+1;
               if (c == 2) 
                   c = -1;
               end
               
               P(closestPointInd,3) = c;
               
               if (c==-1)
                    set(obj, 'color','red');
               elseif (c==0)
                    set(obj, 'color','green');                   
               elseif (c==1)
                    set(obj, 'color',[1 0 1]);                   
               end
               
               fprintf('Modified point (%.1f,%.1f)\n',x,y);
            end           
       end
    end
    function b = encode(coord)
        b = strcat(num2str(coord(1,1)),'|',num2str(coord(1,2)));
    end
end

