function numofcolors = numofcolors(img) %normalized number of colors
[rows, columns, numberOfColorChannels] = size(img);

rgb_columns = reshape(img, [], 3);
unique_colors  = unique(rgb_columns,'rows');
numofcolors =size(unique_colors,1)/(rows*columns);