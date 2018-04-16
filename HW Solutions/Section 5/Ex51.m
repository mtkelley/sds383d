%Morgan Kelley
%Ex. 5.1
clear all; close all; clc;
load restaurants.mat;

X=[restaurants.DinnerService restaurants.SeatingCapacity];
Y=restaurants.Profit;
X=Scale(X,0,1);
Y=Scale(Y,0,1);
%%
[beta,omega,param,X1]=Ex212_func([Y X]);
betamean=mean(param(:,2:3),1);
omegamean=mean(param(:,1),1);

ypred=zeros(size(Y));
for i=1:length(Y)
ypred(i)=X(i,:)*betamean'+normrnd(0,omegamean); %Y prediction
end
RMSE=sqrt(mean((Y-ypred).^2)); %Calculate root mean squared error

%%
figure(1)
subplot(1,3,1)
histogram(param(:,2))
title('\beta_1')
subplot(1,3,2)
histogram(param(:,3))
title('\beta_2')
subplot(1,3,3)
histogram(param(:,1))
title('\omega')

figure(2)
subplot(1,2,1)
histogram(Y-ypred)
title('Residuals')
subplot(1,2,2)
histogram(Y)
title('Profit data')
ylabel('R')