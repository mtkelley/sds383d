%Morgan Kelley
%Ex 4.12
clear all; close all;
%%
load iris.mat
setosa=table2array(iris(1:50,1:5));
versicolor=table2array(iris(51:100,1:5));
virginica=table2array(iris(101:150,1:5));

data=[setosa zeros(length(setosa),1);versicolor ones(length(versicolor),1)];

x1=data(:,2); x2=data(:,3); x3=data(:,4); x4=data(:,5);
y=data(:,6);
X=[x1 x2 x3 x4];
alpha=1; l=5; sigma=1;
%%
Kfcn =@(xa,xb) alpha^2*(-.5/l^2*norm(xa-xb,2)^2);
Xs=X;
ks=zeros(length(x1),length(x1));
for i=1:length(x1)
    for j=1:length(x1)
        ks(i,j)=Kfcn(Xs(i,:),X(j,:));
    end
end

Ks=ks';
kss=zeros(length(x1),length(x1));
for i=1:length(x1)
    for j=1:length(x1)
        kss(i,j)=Kfcn(Xs(i,:),Xs(j,:));
    end
end

K=zeros(length(x1),length(x1));
for i=1:length(x1)
    for i=1:length(x1)
        K(i,j)=Kfcn(X(i,:),X(j,:));
    end
end

pred=ks*inv(K+eye(length(K))+sigma^2)*y;

sigfcn= @(f) 1/(1+exp(-f));
logfcn= @(f) y'*log(sigfcn(f))-(1-y)'*log(1-sigfcn(f))-.5*f'*inv(K)*f-.5*log(det(K));