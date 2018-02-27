function [beta,omega,lambda,paramo,L,X] = Ex214_func(data,num_samples,burnin,a,b,tau)
%Morgan  Kelley
%SDS 383D
if nargin==1 %set parameters
    num_samples = 3000;
    burnin=100;
    a=1;
    b=1;
    tau=1;
end

n = length(data); %rows
d=size(data,2); %cols
X=data(:,2:size(data,2));
y=data(:,1);
omega = ones(n,n); %Initialize
lambda=ones(n,1); 
param=zeros(num_samples+burnin,1+size(X,2));


for i=2:(num_samples+burnin)
    Lambda=diag(lambda)*eye(n,n);
    K=eye(size(X'*Lambda*X));
    Prec=X'*Lambda*X+K;
    Sigma=Prec^-1;
    mu=Sigma*(X'*Lambda*y);
    omega=gamrnd(a+(n+d)/2,(b+(1/2)*(y'*Lambda*y-mu'*Prec*mu))^-1);
    beta=(mvnrnd(mu,((Sigma*(omega)^-1)+(Sigma*(omega)^-1).')/2))'; %Second term is averaged to get rid of rounding errors and ensure matrix is PD and symmetric
    lambda=gamrnd(tau+1/2,tau+(omega/2)*(y-X*beta).^2);
    %Record iteration results
    param(i,:)=[omega beta'];
    L(:,i)=lambda;
end
paramo=param(burnin:num_samples+burnin,:);
L=L(:,burnin:num_samples+burnin);
end