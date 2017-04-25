load('../results/visualization.mat'); %hardcoded right now

a = outputData1;

bg = find(a==-2);
gm = find(a==-1);

maxval = max(a(:)); %find maximum intensity
map = colormap; %get current colormap (usually this will be the default one)
a = floor((a+2)./(maxval+2)*length(map));
a_copy=ind2rgb(a, map);

[xbg, ybg] = ind2sub(size(a_copy),bg);
[xgm, ygm] = ind2sub(size(a_copy),gm);


for indx = 1:length(xbg)
      a_copy(xbg(indx),ybg(indx),:) = [1 1 1];
end
for indx = 1:length(xgm)
      a_copy(xgm(indx),ygm(indx),:) = [0.5 95/255 101/255];
end

figure;
image(a_copy);
