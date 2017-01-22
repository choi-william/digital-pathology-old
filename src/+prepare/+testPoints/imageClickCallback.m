function imageClickCallback (objectHandle , eventData )
   axesHandle  = get(objectHandle,'Parent');
   coordinates = get(axesHandle,'CurrentPoint'); 
   coordinates = coordinates(1,1:2)
   plot(coordinates(1,1),coordinates(1,2),'.','MarkerSize',20,'color','green');
   
   global coords;
   coords = [coords; coordinates];
end