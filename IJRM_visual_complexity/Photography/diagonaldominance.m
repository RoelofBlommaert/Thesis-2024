function diagonal_dom = diagonaldominance(img,center_salient)

x1=0;y1=0; % origin is the top left corner. 
x2 = size(img,1); 
y2 = size(img,2);

x0 = center_salient(1); %x of center of salient region
y0 = center_salient(2); %y of center of salient region

dist1 = abs((x2*-y0-x0*-y2))/sqrt(x2^2+y2^2); %distance to diagonal from topleft to bottomright
dist2 = abs((x2*(y2-y0)-y2*x0))/sqrt(x2^2+y2^2); % distance to diagonal from bottomleft to topright

mdist = (x2*y2/2)/sqrt(x2^2+y2^2);%max distance to diagonals

diagonal_dom = 1-min(dist1,dist2)/mdist; % negative of min distance, 0 is perfect score
