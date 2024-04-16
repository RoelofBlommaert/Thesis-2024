function [ch,numregions] = color_harmony(img,K) % to calculate color harmony, plus #ofregions M8 and M11
[~,~,regions,seg,L1]=segmentation(img,K);
numregions = max(L1(:));

props = regionprops(regions);
area = [props.Area];

cutoff = 0.025*size(img,1)*size(img,2);

T = size(seg,1);
if T > 1
    combos = nchoosek(1:T,2);
    T2= size(combos,1);


    harmonies = zeros(T2,1);
    for i=1:T2
        harmonies(i) = ch_helper(seg(combos(i,1),:),seg(combos(i,2),:));
    end
    
    finder = find(area<cutoff);
    if isempty(finder)
        ch = min(harmonies);
    else
        harmonies(finder)=[];
        ch = min(harmonies);
    end
else 
    ch = 0;
    numregions = 0;
end

if isnan(ch)==1
    ch=0
end


    
    



