function [fc se] 
addpath /Users/gijso/Downloads/VCMatlab/June01/

dc_vc = zeros(1548,1) ;

for i = 1:1548

[fc im ] = getClutter_FC(filenames{i});

dc_vc(i) = fc;

i

end


