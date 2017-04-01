function [ sta ] = computeStat( feat )
%COMPUTESTAT Row wise features

sta = [mean(feat) median(feat) std(feat) max(feat) min(feat) ];

end

