function cc = color_complexity(img)
    
[rows, columns, numberOfColorChannels] = size(img);

rgb_columns = reshape(img, [], 3);
[unique_colors, m, p ] = unique(rgb_columns,'rows');

color_counts = accumarray(p,1);

N = rows*columns; 

logs = log(color_counts/N);

cc = -logs'*color_counts/N;


