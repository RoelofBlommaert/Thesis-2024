function [horizontal vertical] = colorbalance(img)
img_d = double(img);
x2 = size(img,1);
y2 = size(img,2);

horz = 0;
for i = 1:y2
    for j = 1:x2/2
       tmp =sqrt((img_d(j,i,1)-img_d(end-j+1,i,1))^2+(img_d(j,i,2)-img_d(end-j+1,i,2))^2+(img_d(j,i,3)-img_d(end-j+1,i,3))^2);
       horz = horz+tmp;
    end
end
horizontal =1- (horz/(y2*x2/2))/441.6730; %441.6730 is the euclidean difference between black (0,0,0) and white(255,255,255) pixels

%horizontal

vert = 0;
for i = 1:x2
    for j = 1:y2/2
       tmp =sqrt((img_d(i,j,1)-img_d(i,end-j+1,1))^2+(img_d(i,j,2)-img_d(i,end-j+1,2))^2+(img_d(i,j,3)-img_d(i,end-j+1,3))^2);
       vert = vert+tmp;
    end
end
vertical= 1- (vert/(y2*x2/2))/441.6730;

