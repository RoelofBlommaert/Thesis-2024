function lumi = luminance3(img) % luminance contrast

kernel = [-1, -1, -1; -1, 8, -1;-1, -1,-1]/8;

if size(img,3)==3
    Y = 0.299*img(:,:,1) + 0.587 * img(:,:,2) + 0.114*img(:,:,3);
else
    Y = img(:,:,1);
end

diff = abs(conv2(Y,kernel,'valid'));
lumi = mean2(diff);