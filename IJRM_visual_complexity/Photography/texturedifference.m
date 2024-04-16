function td = texturedifference(img,A)
mask_fg = logical(A); % foreground mask
mask_bg = logical(1-A); %background mask

gray_im = rgb2gray(img);
edged = edge(gray_im,'Canny');

ed_fg = sum(edged(mask_fg))/sum(mask_fg(:));
ed_bg = sum(edged(mask_bg))/sum(mask_bg(:));

td = abs(ed_fg-ed_bg);