%Morgan Kelley
%Ex 4.14
clear all; close all;
%% Process the data
load iris.mat
setosa=table2array(iris(1:50,1:5));
versicolor=table2array(iris(51:100,1:5));
virginica=table2array(iris(101:150,1:5));

x1=table2array(iris(:,2)); x2=table2array(iris(:,3)); x3=table2array(iris(:,4)); x4=table2array(iris(:,5));
X=[x1 x2 x3 x4];
alpha=1; l=5; sigma=1;

Y=[ones(51,1);2*ones(50,1);3*ones(50,1)];
ySetosa=[ones(50,1);zeros(100,1)];
yVersicolor=[zeros(50,1);ones(50,1);zeros(50,1)];
yVirginica=[zeros(50,1);zeros(50,1);ones(50,1)];
%% Calculate the covariance
Kfcn =@(xa,xb) alpha^2*exp(-.5/l^2*norm(xa-xb,2)^2);
Xs=X;
K=zeros(length(x1),length(x1));
for i=1:length(x1)
    for j=1:length(x1)
        K(i,j)=Kfcn(X(i,:),X(j,:));
    end
end
K=K+sigma^2*(eye(length(X)));
Ki=inv(K);
%% Optimization
opns=optimoptions('fmincon','Algorithm','interior-point','UseParallel',true,'Display','iter-detailed');

%Setosa
JSet= @(f) Jfunc(ySetosa,f,K);
MAPSetosa = fmincon(JSet,randn(length(ySetosa),1),[],[],[],[],[],[],[],opns);

%Versicolor
JVer= @(f) Jfunc(yVersicolor,f,K);
MAPVersicolor = fmincon(JVer,randn(length(yVersicolor),1),[],[],[],[],[],[],[],opns);

%Virginica
JVir= @(f) Jfunc(yVirginica,f,K);
MAPVirginica = fmincon(JVir,randn(length(yVirginica),1),[],[],[],[],[],[],[],opns);
%% Classification
MAP=[MAPSetosa MAPVersicolor MAPVirginica];
%Finding the max, using the indexes of the max value
[null,MAX]=max(MAP');
%labeling the types
for i=1:length(MAX)
    if(MAX(i)==1)
        label(i)="Setosa";
    elseif (MAX(i)==2)
        label(i)="Versicolor";
    elseif (MAX(i)==3)
        label(i)="Virginica";
    end
end
%% 
close all;
figure(1); hold on;
plot(Y,'Linestyle','none','Marker','*'); plot(MAX,'Linestyle','none','Marker','.');
legend('Actual','Predicted');

figure(2); hold on;
plot(1./(1+exp(-MAPSetosa))); plot(1./(1+exp(-MAPVersicolor))); plot(1./(1+exp(-MAPVirginica)));
legend('Setosa','Versicolor','Virginica');