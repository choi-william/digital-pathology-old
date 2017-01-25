%function a = Helper
%  a.CalcDistance=@CalcDistance;
%  a.b = 5;
%end
%%TODO, MAKE THIS MORE VERSATILE IN THE FUTURE
function distance = CalcDistance(p1, p2) 
    distance = sqrt((p1(1)-p2(1))^2+(p1(2)-p2(2))^2); 
end