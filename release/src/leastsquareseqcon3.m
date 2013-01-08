function [x, xsol] = leastsquareseqcon3(A,b,C,d,alpha)

% Solve generalized SVD to get gammas and alphas. Please refer Gander et al, for description of the algorithm.

[U,V,X,Da,Dc] = gsvd(A,C);
c = U'*b;
e = V'*d;
p = size(C,1);
r = sum(diag(Dc)>0);
lambda = sym('lambda','real');
i=1;
% tic;
f=Da(i,i)^2 *(Dc(i,i)*c(i)-Da(i,i)*e(i))^2/(Da(i,i)^2+lambda*Dc(i,i)^2)^2;
for i = 2:r
    a=Da(i,i)^2 *(Dc(i,i)*c(i)-Da(i,i)*e(i))^2/(Da(i,i)^2+lambda*Dc(i,i)^2)^2;
    f = f+ a;
end
% toc;

if(length(e)>r)
    for i =r+1:p
        f = f+e(i)^2;
    end
end
f = f-alpha^2;
[num,den] = numden(f);
c = coeffs(num);
numNorm =    vpa(num/c(end));
% lambdaSol = roots(coeff);

if(diff(f)~=0)

    lambdaSol = solve(numNorm);
    lambdaSol = double(lambdaSol);

    realLambdaSol = lambdaSol(~(abs(imag(lambdaSol))>0));
    ind = find(realLambdaSol == max(realLambdaSol)); 
    ind =ind(1);

    xsol = (A'*A+realLambdaSol(ind)*(C'*C))\(A'*b+realLambdaSol(ind)*C'*d);
    xsol = xsol';
    x = xsol;
    if(sum(isnan(xsol)))
        xsol(isnan(xsol))=0;
    end
%     disp(xsol');
else
    
end






%% Solve completely symbolically.
% syms x lambda;
% x = inv(A'*A + lambda*C'*C)*(A'*b + lambda*C'*d);
% f = (C*x-d)'*(C*x -d);
% lambdaSol = solve(f-alpha^2);
% for i = 1:length(lambdaSol)
%     xsol(:,i) = feval(matlabFunction(x),double(lambdaSol(i)));
% end
% x = xsol;
% realLambdaSol = lambdaSol(~(abs(imag(lambdaSol))>0));
% ind = find(realLambdaSol == max(realLambdaSol));
% xsol = x(ind,:);




