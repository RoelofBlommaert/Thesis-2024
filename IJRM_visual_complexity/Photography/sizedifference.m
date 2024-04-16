function size_diff = sizedifference(A)
x2 = size(A,1);
y2 = size(A,2);

fgsize = sum(sum(A)); %foreground pixels are labeled 1

size_diff = fgsize/((x2-1)*(y2-1)); 