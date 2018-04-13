%Morgan Kelley
%4.5
clear all; close all; format compact;

global N;
load faithful.mat;
eruptions=table2array(faithful(:,1));
waiting=table2array(faithful(:,2));
N=length(waiting);

Y=Scale(eruptions,0,1); X=waiting;
%% Prediction
Xtest=linspace(0,100,272)';

alpha=.1;
sigma=.1;
l=1;
kfcn = @(x1,x2) alpha^2*exp(-0.5/(l^2) * sqrt(sum(x1-x2).^2))+sigma^2*eye(size(x1,1));

Xt=linspace(0,100,272);
ks=kfcn(X',X');
Ks=kfcn(X',Xt);
ksig=kfcn(Xt,Xt);

m=Ks.*(inv(ksig)).*Y';
Cov=ks-Ks.*inv(ksig)*Ks';
err=1.96*sqrt(diag(Cov));
%%
clf;
figure(1)
plot(X,Y,'b*','linewidth',1.5); hold on; plot(X,m,'*')
ylabel('Eruptions'); xlabel('Waiting')
legend('Actual','Prediction','Location','Northwest')

