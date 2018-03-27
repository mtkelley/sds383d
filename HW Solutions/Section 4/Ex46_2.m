%Morgan Kelley
%Exercise 4.6
clear all; close all; format compact;

global N split;
load faithful.mat;
eruptions=table2array(faithful(:,1));
waiting=table2array(faithful(:,2));
N=length(waiting);
split=N/2;
tX=waiting(1:split);
tY=eruptions(1:split);
teX=waiting(split+1:N);
teY=eruptions(split+1:N);

%% Fit Gaussian Process
%Kernel Function
kfcn = @(x,xp,theta) theta(1)*exp(-1/(2*theta(2))*pdist2(x,xp).^2)+theta(3)*eye(split,split);

%Initial conditions
theta0=[1,1,1];

gprMdl = fitrgp(tX,tY,'KernelFunction',kfcn,'KernelParameters',theta0);
thetasq=gprMdl.KernelInformation.KernelParameters;
theta=sqrt(thetasq);
Obj=gprMdl.LogLikelihood;

%% Prediction
K=kfcn(tX,tX,thetasq);
ks=kfcn(tX,teX,thetasq);
kss=kfcn(teX,teX,thetasq);
m=(ks'*K^(-1)*tY);
Cov=kss-ks'*K^(-1)*ks;
con=[(m-1.96*sqrt(K))' (m+1.96*sqrt(K))']; % 95% confidence interval
ypred1=predict(gprMdl,teX);
ypred2=predict(gprMdl,tX);

%%
figure(1)
plot(teX,ypred1,'b*','linewidth',1.5); hold on; plot(teX,teY,'r*')
ylabel('Eruptions'); xlabel('Waiting')
legend('Prediction','Actual','Location','Northwest')

figure(2)
plot(tX,ypred2,'b*','linewidth',1.5); hold on; plot(tX,tY,'r*')
ylabel('Eruptions'); xlabel('Waiting')
legend('Prediction','Actual','Location','Northwest')