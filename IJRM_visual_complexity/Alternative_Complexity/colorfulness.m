function colorfulness = colorfulness(img)
cie = colorspace('Lab<-RGB',img);
a = cie(:,:,2);
b = cie(:,:,3);
Cp =sqrt( a.^2 + b.^2);
muC = mean(Cp(:));

sda = std(a(:));
sdb = std(b(:));

sigab = sqrt(sda^2+sdb^2);
colorfulness = 0.94* muC + sigab;