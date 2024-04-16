function ff = freqfactor(img)

[srad, S] = specxture(img); %needs helper functions specxture.m and intline.m
x=find(cumsum(srad)>=0.99.*sum(srad));
ff=x(1)/(length(srad)*2);