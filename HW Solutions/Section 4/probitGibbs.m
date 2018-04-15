function [f,z] = probitGibbs(K,y,N,sigma)
n=length(y);
z=zeros(N,n);
f=z;
if (y==1)
low=0;
else
    low=-inf;
end
if (y==0)
    up=0;
else
    up=inf;
end

A=K*inv(K+sigma^2*eye(n));
Cov=K-A*K;
for i=2:N
    f(i,:)=mvnrnd(1,A*z(i-1,:),Cov);
    z(i,:)=TruncatedGaussian(f(i,:),[lower upper],1);
end