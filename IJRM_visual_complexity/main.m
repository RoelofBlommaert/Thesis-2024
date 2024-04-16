
addpath ~/VCMatlab/
addpath ~/VCMatlab/Photography/
addpath ~/VCMatlab/Complexity/
addpath ~/VCMatlab/Helper/SFFCMCode/SFFCMCode/
addpath ~/VCMatlab/Helper/June01/ %
addpath ~/VCMatlab/Helper/SaliencyToolbox/
addpath ~/VCMatlab/Alternative_Complexity/


img = imread('/path/to/image/');

%% Visual Complexity

lc = luminance_complexity(img); % luminance complexity
cc = colorfulness(img); % color complexity
ed = edge_density(img); % edge density 
ff = freqfactor(img); % feature complexity control: frequency factor
[ah av irv] =arrangement(img); % asymmetry horizontal, asymmetry vertical, irregularity of object arrangement
[~, num_reg]=color_harmony(img,10); % design complexity control: number of regions

name =  'darknet53-coco';
detector = yolov3ObjectDetector(name);
oc = object(img)

%% Alternative Complexity 
% Corchs et al. (2014) complexity measures, m6 is equal to edge density, m7 is jpeg file size
[m1, m2, m3, m4] = complexity1_4(img);
m5 = freqfactor(img);
m9 = colorfulness(img);
m10 = numofcolors(img);
[m11, m8]=color_harmony(img,10);
oc = objectcomplexity(objects(k,:)); % object complexity measure used in Shin et al. (2021)
[fc, se] = clutter(img); % clutter, feature congestion and subband entropy


%visual saliency calculation

regs = superpixels(img,10); 
[vis_sal] = vsalience(img); %input same RGB image

% determine salient region
saliency_region = zeros(max(max(regs)),1);
for i=1:max(max(regs))
    saliency_region(i) =mean(mean(vis_sal(regs==i)));
end

a=regionprops(regs,'Centroid'); %find centers for each region
centroids = [a.Centroid];
xCentroids = centroids(1:2:end);
yCentroids = centroids(2:2:end);

m = find(saliency_region==max(saliency_region));
center_salient = [xCentroids(m) yCentroids(m)];

%% Photography Variables developed based on the photography constructs as used in Zhang et al. 2017, Zhang and Luo 2018
%diagonal dominance 

diag_dom = diagonaldominance(img, center_salient);

%rule of thirds
rot = ruleofthirds(img, center_salient);

% physical balance
[vphd, hphd] = physicalbalance(img, xCentroids,yCentroids,saliency_region);

% color balance
[horizontal, vertical] = colorbalance(img);


%% figure-ground

A = figureground(img);

% size-difference
size_dif = sizedifference(A);
% color-difference
col_dif = colordifference(img,A);

% texture difference
text_dif = texturedifference(img,A);

%depth of field 
%hsv = colorspace('HSV<-RGB',img);

%wavelet = dbaux(hsv(:,:,1));
%% color 

[brightness, saturation, contrast, clarity, warmth] = color_photography(img);








