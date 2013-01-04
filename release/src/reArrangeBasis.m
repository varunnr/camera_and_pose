function [Bre,mure] = reArrangeBasis(B,mu,numPoints)

for i = 1:size(B,2)
    Btemp = reshape(B(:,i),numPoints,3)';
    Bre(:,i) = Btemp(:);
end 
mutemp = reshape(mu,numPoints,3)';
mure = mutemp(:);