function rot = ruleofthirds(img, center_salient)
%rule of thirds
x2 = size(img,1);
y2 = size(img,2);

P1 = [x2/3 y2/3]; % top left intersection of lines of thirds
P2 = [x2/3 2*y2/3]; % bottom left intersection
P3 = [2*x2/3 y2/3]; % top right intersection
P4 = [2*x2/3 2*y2/3]; % bottom right intersection

d1 =sqrt((P1(1)-center_salient(1))^2+(P1(2)-center_salient(2))^2);
d2 =sqrt((P2(1)-center_salient(1))^2+(P2(2)-center_salient(2))^2);
d3 =sqrt((P3(1)-center_salient(1))^2+(P3(2)-center_salient(2))^2);
d4 =sqrt((P4(1)-center_salient(1))^2+(P4(2)-center_salient(2))^2);

md = sqrt(x2^2 + y2^2) /3 ; %max distance is any corner 

rot = 1-min([d1,d2,d3,d4])/md;
