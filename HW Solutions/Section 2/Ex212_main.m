%Morgan Kelley
%Sampler
%Problem 2.12 SDS383D

close all; clc; clear all;
load dental.mat;
data=table2array(dental(1:108,2:3));
y=data(:,1);
X=data(:,2);
n=length(data);
lsfun=@(beta,xdata)xdata*beta;
beta0=[0;0;0];
%% Calculate number of males--GenderSplit
Gender=table2array(dental(:,5));
Gendernum=countcats(Gender);
GenderSplit=Gendernum(2); %Number of males will be second--alphabetical

%% Both genders together
Gv=[ones(GenderSplit,1); zeros(n-GenderSplit,1)];
D1=[data(:,1) ones(length(data),1) data(:,2) Gv]; %[y intercept age gender]
Y1=data(:,1);

[beta1,omega1,param1,X1]=Ex212_func(D1);
betamean1=mean(param1(:,2:4),1);
omegamean1=mean(param1(:,1),1);
ypred1=X1*betamean1'+normrnd(0,omegamean1);
norm1=norm(ypred1-y);

%Least Squares and Ridge
betals1=(X1'*X1)\(X1'*y);
betaRidge1=ridge(y,X1(:,2:3),0);

for i=1:length(Y1)
ypred1(i)=X1(i,:)*betamean1'+normrnd(0,omegamean1);
end
RMSE1=sqrt(mean((Y1-ypred1).^2));
    
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
histogram(param1(:,1))
title('\omega^{MF}')

figure(2)
subplot(3,1,1)
plot((1:length(data)),y-ypred1,'*')
title('Residual plots')
ylabel('R_1')

%% Just Male
D2=[data(1:GenderSplit,1) ones(size(data(1:GenderSplit,1))) data(1:GenderSplit,2)];
Y2=y(1:GenderSplit);
[beta2,omega2,param2,X2]=Ex212_func(D2);
betamean2=mean(param2(:,2:size(param2,2),1));
omegamean2=mean(param2(:,1),1);
ypred2=X2*betamean2'+normrnd(0,omegamean2);

for i=1:length(Y2)
ypred2(i)=X2(i,:)*betamean2'+normrnd(0,omegamean2);
end

norm2=norm(ypred2-Y2);
RMSE2=sqrt(mean((Y2-ypred2).^2));

%Least Squares and Ridge
betals2=(X2'*X2)\(X2'*Y2);
betaRidge2=ridge(Y2,X2,0);

figure(1)
subplot(4,3,2)
histogram(param2(:,2))
title('\beta_1^{M}')
subplot(4,3,5)
histogram(param2(:,3))
title('\beta_2^{M}')
subplot(4,3,11)
histogram(param2(:,1))
title('\omega^{M}')

figure(2)
subplot(3,1,2)
plot((1:GenderSplit),Y2-ypred2,'*')
ylabel('R_2')
%% Just Female 
D3=[data(GenderSplit+1:length(data),1) ones(size(data(GenderSplit+1:length(data),1))) data(GenderSplit+1:length(data),2)];
Y3=y(GenderSplit+1:length(data));
[beta3,omega3,param3,X3]=Ex212_func(D3);
betamean3=mean(param3(:,2:size(param3,2),1));
omegamean3=mean(param3(:,1),1);
ypred3=zeros(size(Y3));

for i=1:length(Y3)
ypred3(i)=X3(i,:)*betamean3'+normrnd(0,omegamean3);
end

norm3=norm(ypred3-Y3);
RMSE3=sqrt(mean((Y3-ypred3).^2));

%Least Squares and Ridge
betals3=(X3'*X3)\(X3'*Y3);
betaRidge3=ridge(Y3,X3,0);

figure(1)
subplot(4,3,3)
histogram(param3(:,2))
title('\beta_1^{F}')
subplot(4,3,6)
histogram(param3(:,3))
title('\beta_2^{F}')
subplot(4,3,12)
histogram(param3(:,1))
title('\omega^{F}')

figure(2)
subplot(3,1,3)
plot(GenderSplit+1:length(data),Y3-ypred3,'*')
xlabel('Observation')
ylabel('R_3')