function [camera]= estimateWPCamera(xy,XY)
%[Raff, taff, R, scale,t,Rproc,tproc]=
%estimateOrthoCamera(xy,XY,scaleFactor)
xy=xy(:,1:2);
% xy=scaleFactor*xy;
taff= mean(xy,1);
xy=xy-repmat(taff,[size(xy,1) 1]);


numPoints = size(xy,1);
A = zeros(2*numPoints,size(XY,2)+3);
b = zeros(2*numPoints,1);

for i=1:numPoints
    
   A((i-1)*2+1,:) = [ XY(i,:) 0 0 0]; 
   A(i*2,:) = [ 0 0 0 XY(i,:)];
   
   b((i-1)*2+1) = xy(i,1); 
   b(i*2) = xy(i,2);
    
end

%% Procrustes solution as initial point

x=xy;
X=XY';
meanX=mean(X,2);
X=X-repmat(meanX,1,size(X,2));

M=x'*X'*inv(X*X');
% M = x'/X;
[U,S,V]=svd(M);

Inew=[1 0 0; 0 1 0];
R = U*Inew*V';

r3=cross(R(1,:),R(2,:));
r3=r3/norm(r3);
rinit =[R(1,:) R(2,:)]';


Raff=R;
R=[R; r3];
scaleFactor=0.5*(S(2,2)+S(1,1));

t=[taff';1/scaleFactor];
det(R);
if(sum(abs(diag(U)))>1)
    S = S(1:2,1:2);
else
    S = S(1:2,1:2);
    S = flipud(fliplr(S));
%     disp('Flip scales');
end
% S = U*S;


%%
% %Solve non-linear optimization using fmincon
% options = optimset('Algorithm','interior-point');
% r=fmincon(@(x) objective(x,A,b),rinit,[],[],[],[],[],[], @(x) orthoConstraints(x),options);
% % 
% Raff=[ r(1) r(2) r(3);...
%        r(4) r(5) r(6);];
% % 
% % Find full rotation matrix
% r1=Raff(1,:);
% r2=Raff(2,:);
% r3=cross(Raff(1,:),Raff(2,:));
% r3=r3/norm(r3);
% R=[r1;r2;r3];
% 
% %Estimate average scale
% %scale = mean(r2*XY'./xyunscaled(:,2)');
% %t=[taff';scale];
% 
camera.Raff = Raff;
camera.taff = taff';
camera.R = R; 
camera.t = t;
camera.S = S;
camera.M = S*Raff;







end


function f=objective(x,A,b)
f= (A*x-b)'*(A*x-b);
end

function [c,ceq] = orthoConstraints(x)

ceq = [[x(1) x(2) x(3)]*[x(4) x(5) x(6)]';...
       [x(1) x(2) x(3)]*[x(1) x(2) x(3)]'-1;...
       [x(4) x(5) x(6)]*[x(4) x(5) x(6)]'-1;];
c=[];

end