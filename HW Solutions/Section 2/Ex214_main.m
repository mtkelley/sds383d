%Morgan Kelley
%Gibbs Sampler
%Problem 2.14 SDS383D

close all; clc; clear all;
load dental.mat;
data=table2array(dental(1:108,2:3));
y=data(:,1);
X=data(:,2);
n=length(data);
%% Calculate number of males--GenderSplit
Gender=table2array(dental(:,5));
Gendernum=countcats(Gender);
GenderSplit=Gendernum(2); %Number of males will be second--alphabetical

%% Both genders together
Gv=[ones(GenderSplit,1); zeros(n-GenderSplit,1)];
D1=[data(:,1) ones(length(data),1) data(:,2) Gv];
Y1=data(:,1);

[beta1,omega1,lambda1,param1,L1,X1]=Ex214_func(D1); %Sampler
betamean1=mean(param1(:,2:4),1);
omegamean1=mean(param1(:,1),1);

ypred1=X1*betamean1'+normrnd(0,omegamean1*lambda1); %Predicting Y
RMSE1=sqrt(mean((Y1-ypred1).^2)); %Root mean squared error

figure(1)
subplot(4,3,1)
histogram(param1(:,2))
title('\beta_1^{MF}')
subplot(4,3,4)
histogram(param1(:,3))
title('\beta_2^{MF}')
subplot(4,3,7)
histogram(param1(:,4))
title('\beta_3^{MF}')
subplot(4,3,10)
histogram(omega1*lambda1)
title('\omega\lambda^{MF}')

figure(2)
subplot(3,1,1)
plot((1:length(data)),Y1-ypred1,'*')
title('Residual plots')
ylabel('R_1')
%% Just Male
D2=[data(1:GenderSplit,1) ones(size(data(1:GenderSplit,1))) data(1:GenderSplit,2)];
Y2=y(1:GenderSplit);

[beta2,omega2,lambda2,param2,L2,X2]=Ex214_func(D2);
betamean2=mean(param2(:,2:3),1);
omegamean2=mean(param2(:,1),1);
lambdamean2=mean(L2,2);

ypred2=X2*betamean2'+normrnd(0,omegamean2*lambdamean2);
RMSE2=sqrt(mean((Y2-ypred2).^2));

figure(1)
subplot(4,3,2)
histogram(param2(:,2))
title('\beta_1^{M}')
subplot(4,3,5)
histogram(param2(:,3))
title('\beta_2^{M}')
subplot(4,3,11)
histogram(omega2*lambda2)
title('\omega\lambda^{M}')

figure(2)
subplot(3,1,2)
plot((1:GenderSplit),Y2-ypred2,'*')
ylabel('R_2')
%% Just Female 
D3=[data(GenderSplit+1:length(data),1) ones(size(data(GenderSplit+1:length(data),1))) data(GenderSplit+1:length(data),2)];
Y3=y(GenderSplit+1:length(data));

[beta3,omega3,lambda3,param3,L3,X3]=Ex214_func(D3);
betamean3=mean(param3(:,2:3),1);
omegamean3=mean(param3(:,1),1);
lambdamean3=mean(L3,2);

ypred3=X3*betamean3'+normrnd(0,omegamean3*lambdamean3);
RMSE3=sqrt(mean((Y3-ypred3).^2));

figure(1)
subplot(4,3,3)
histogram(param3(:,2))
title('\beta_1^{F}')
subplot(4,3,6)
histogram(param3(:,3))
title('\beta_2^{F}')
subplot(4,3,12)
histogram(omega3*lambda3)
title('\omega\lambda^{F}')


figure(2)
subplot(3,1,3)
plot(GenderSplit+1:length(data),Y3-ypred3,'*')
xlabel('Observation')
ylabel('R_3')