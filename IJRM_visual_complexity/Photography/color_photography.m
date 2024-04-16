function [brightness, saturation, contrast, clarity, warmth] = color_photography(img)
x2 = size(img,1);
y2 = size(img,2);
hsv = colorspace('HSV<-RGB',img);


%brightness
brightness = mean(mean(hsv(:,:,3)));
%saturation
saturation = mean(mean(hsv(:,:,2)));

%contrast
sat_channel = hsv(:,:,2);
contrast = std(sat_channel(:));

%clarity
clarity = sum(sum(hsv(:,:,3)>0.7))/(x2*y2);

% warm
hue = hsv(:,:,1);
warm = ones(x2,y2);
warm(hue<30)=0;
warm(hue>110)=0;
warmth = sum(warm(:))/(x2*y2);
