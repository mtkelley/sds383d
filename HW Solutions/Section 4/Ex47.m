%Morgan Kelley
%Exercise 4.7
clear all; close all; format compact;

global N split;
load faithful.mat;
eruptions=table2array(faithful(:,1));
waiting=table2array(faithful(:,2));
N=10;
split=N/2;
tX=waiting(1:N);
tY=eruptions(1:N);

%% Fit Gaussian Process
%Kernel Function
kfcn = @(x,xp,theta) theta(1)*exp(-1/(2*theta(2))*pdist2(x,xp).^2)+theta(3)*eye(N,N);

%Initial conditions
theta0=[.001,.001,.001];

gprMdl = fitrgp(tX,tY,'KernelFunction',kfcn,'KernelParameters',theta0);
thetasq=gprMdl.KernelInformation.KernelParameters;
theta=sqrt(thetasq);
Obj=gprMdl.LogLikelihood;

%% Prediction
Xtest=linspace(min(tX),max(tX),N)';
ypred1=predict(gprMdl,Xtest);


%%
figure(1)
plot(tX,tY,'b*','linewidth',1.5); hold on; plot(Xtest,ypred1)
ylabel('Eruptions'); xlabel('Waiting')
legend('Actual','Prediction','Location','Northwest')

