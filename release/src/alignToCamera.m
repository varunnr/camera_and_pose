function [Xnew]=alignToCamera(X,R,t,Rnew,tnew)
% [Xnew]=alignToCamera(X,R,t,Rnew,tnew)
%
% R, t - Current Camera
% Rnew, tnew - Camera to be aligned to.
%
%

Xnew = R*X' + repmat(t,1,length(X));
Xnew = Rnew*Xnew+repmat(tnew,1,length(X));

Xnew = Xnew';