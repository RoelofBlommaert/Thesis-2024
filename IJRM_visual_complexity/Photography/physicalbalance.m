function [vphd hphd] = physicalbalance(img,xCentroids,yCentroids,saliency_region)
x2 = size(img,1);
y2 = size(img,2);
pd_w = (saliency_region )/sum(saliency_region);
wcentroid_y = yCentroids*pd_w;
wcentroid_x = xCentroids*pd_w;

vphd = 1- abs((wcentroid_y-y2/2))/(y2/2); %1 - (distance of weighted centroid to horizontal line)/(max possible distance at the edge)
hphd = 1-abs((wcentroid_x-x2/2))/(x2/2); %1 - (distance of weighted centroid to vertical line)/(max possible distance at the edge)

