function lc = luminance_complexity(img)

[rows, columns, numberOfColorChannels] = size(img);

rgb_columns = reshape(img, [], 3);
srgb = imadjust(rgb_columns,[],[],0.5);

Y = 0.299*srgb(:,1) + 0.587 * srgb(:,2) + 0.114*srgb(:,3);

[unique_y, m, p] = unique(Y,'rows');

lumi_counts = accumarray(p,1);

N = rows*columns;

logs = log(lumi_counts/N);

lc = - logs'*lumi_counts/N;
