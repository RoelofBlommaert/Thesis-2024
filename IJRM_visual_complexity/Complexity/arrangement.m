function [av ah ir] = arrangement(img);

pool_sigma = 7/2;
numlevels = 3;
% The input image, im, had better be a MxNx3 matrix, in which case we assume it is an RGB image.
    %   If it's MxN, it's probably gray, and this program is not appropriate.
[m, n, d] = size(img);
if d==3
  % we first convert it into the perceptually-based CIELab color space
  Lab = RGB2Lab(img);
else
    [av ah ir] = 0;
end
 % Get Gaussian pyramid for the luminance channel
L_pyr = RRgaussianPyramid(Lab(:,:,1), numlevels);



[clutter_levels] = computeOrientationClutter(L_pyr);

kernel_1d = [0.05 0.25 0.4 0.25 0.05];
kernel_2d = conv2(kernel_1d, kernel_1d');
clutter_map = clutter_levels{1}{1};
for scale=2:numlevels
    clutter_here = clutter_levels{scale}{1};
    for kk = scale:-1:2
        clutter_here = upConv(clutter_here, kernel_2d, 'reflect1', [2 2]);
    end
    common_sz = min(size(clutter_map), size(clutter_here));
    clutter_map(1:common_sz(1), 1:common_sz(2)) = max(clutter_map(1:common_sz(1), 1:common_sz(2)), clutter_here(1:common_sz(1), 1:common_sz(2)));
end

ir = mean(clutter_map(:));

horz = 0;
for i = 1:n
    for j = 1:m/2
       tmp =sqrt((clutter_map(j,i)-clutter_map(end-j+1,i))^2);
       horz = horz+tmp;
    end
end
ah= horz/(m*n/2); 

%horizontal

vert = 0;
for i = 1:m
    for j = 1:n/2
       tmp =sqrt((clutter_map(i,j)-clutter_map(i,end-j+1))^2);
       vert = vert+tmp;
    end
end
av=vert/(m*n/2); 

