function [contrast, correlation, energy, homogeneity] = complexity1_4(img)
if size(img,3)<3 
    glcm = graycomatrix(img);
else 
    glcm = graycomatrix(rgb2gray(img));
end

props = graycoprops(glcm);

contrast = props.Contrast;
correlation = props.Correlation;
energy = props.Energy;
homogeneity = props.Homogeneity;