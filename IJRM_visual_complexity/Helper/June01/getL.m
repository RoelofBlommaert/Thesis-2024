function [out] = getL(in)[m,n] = size(in);out = in(:,n/2+1:3*n/4);return;