function ed = edge_density(img)
   
[rows, columns, numberOfColorChannels] = size(img);
gray = rgb2gray(img);
canny = edge(gray,'canny');
ed = sum(sum(canny))/(rows*columns);
