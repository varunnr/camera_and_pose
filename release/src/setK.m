function K=setK(x,y,f)
K=eye(3);
K(1,1) = f*x;
K(2,2) =f*x;
K(1,3) = x/2;
K(2,3) =y/2;