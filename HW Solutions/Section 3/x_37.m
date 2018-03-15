%Morgan Kelley
%SDS 383D
%Problem 3.7
clear all;
load('tea_discipline_oss.mat');
N=height(teadisciplineoss);
%% Data processing
Grade=table2array(teadisciplineoss(:,3));
Actions=table2array(teadisciplineoss(:,7));

%Remove sensored values
NA2=0;
for i=1:N
    if Actions(i)==-99
        NA=i;
        NA2=[NA2;NA];
    end
end
NA2(1)=[];
Y=Actions;
Y(NA2)=[]; %Delete sensored values of Y
X=Grade;
X(NA2)=[];
%% Hessian
X2=[ones(size(X)) X];
lambda=10000;
fun=@(beta) -(Y'*X2*beta-sum(exp(X2*beta))-(lambda/2)*beta'*beta);
[betaR]=fminsearch(fun,[0; 0]);
%%
mean=betaR;
Hes=@(beta) -(X2'*diag(exp(X2*beta))*X2+lambda);
Cov=inv(-Hes(betaR));
int=1.95*sqrt(diag(Cov));
CI=[mean-int mean+int];

