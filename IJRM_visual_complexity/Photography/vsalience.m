function visual_salience = vsalience(img)

addpath /Users/gijso/Downloads/SaliencyToolbox/
img2 = initializeImage(img);
params = defaultSaliencyParams;
[salmap,saldata] = makeSaliencyMap(img2,params);
visual_salience =imresize(salmap.data,img2.size(1:2));
