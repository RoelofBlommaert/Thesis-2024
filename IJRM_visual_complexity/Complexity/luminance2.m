function lumi = luminance2(img)
kernel = [-1, -1, -1; -1, 8, -1;-1, -1,-1]/8;
diff = abs(conv2(double(rgb2gray(img)),kernel,'valid'));
lumi = mean2(diff);