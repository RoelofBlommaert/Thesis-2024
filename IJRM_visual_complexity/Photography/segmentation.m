function [regions,Lseg, Label,segs_lab,L1] = segmentation(img,cluster)


SE = 3;



L1=w_MMGR_WT(img,SE);

L2=imdilate(L1,strel('square',2));
[~,~,Num,centerLab]=Label_image(img,L2);

[Label, ~,~,~]=w_super_fcm(L2,centerLab,Num,cluster);
[Lseg,~,~,segs_lab]=Label_image(img,Label);

regions=superpixels(Lseg,10);


