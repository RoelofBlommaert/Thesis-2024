function cd = colordifference(img,A)
x2 = size(A,1);
y2 = size(A,2);

mask_fg = logical(A); % foreground mask
mask_bg = logical(1-A); %background mask

rc = img(:,:,1); %red channel
gc = img(:,:,2); %green channel
bc = img(:,:,3); %blue channel

fgrm = mean(rc(mask_fg)); 
fggm = mean(gc(mask_fg));
fgbm = mean(bc(mask_fg));

bgrm = mean(rc(mask_bg));
bggm = mean(gc(mask_bg));
bgbm = mean(bc(mask_bg));

cd = sqrt((fgrm-bgrm)^2+(fggm-bggm)^2+(fgbm-bgbm)^2)/441.6730; %441.6730 is the euclidean difference between black (0,0,0) and white(255,255,255) pixels
