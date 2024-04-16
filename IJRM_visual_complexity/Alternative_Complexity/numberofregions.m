function numregions = numberofregions(img)
SE = 3;

regions=w_MMGR_WT(img,SE);
numregions = max(regions(:));