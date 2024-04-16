function fg = figureground(img)
x2 = size(img,1);
y2 = size(img,2);

L = superpixels(img,500); %label image with a lot of super pixels

C = zeros(x2,y2); 

C(2:end-1,2:end-1)=1;

fg = grabcut(img,L,logical(C));
