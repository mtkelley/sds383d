function [J] = Jfunc(y,f,K)
P=@(yi,fi) (1/(1+exp(-fi)))^yi * (1-1/(1+exp(-fi)))^(1-yi);
summ=0;
for i=1:length(y)
    summ=summ+log(P(y(i),f(i)));
end
summ=summ-0.5*f'*inv(K)*f-0.5*log(det(K));
J=-summ;
end

