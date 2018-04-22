%Morgan Kelley
%Ex. 5.2
clear all; close all; clc;
load restaurants.mat;

X=[restaurants.Profit];
X=Scale(X,0,1);
Y=restaurants.DinnerService;

[tmp,ind] = sort(Y);
X = X(ind);
Y = Y(ind);
init=[1 1 1 1 0.4 1];
Ns=100;

[mut,sigmat,omega1,zt,Pxi1,Pxi0,s2t,mt,Ncountt,Xcountt]=Ex52Func_3(Ns,Y,X,init);

error=sum(abs(Y'-zt(Ns-1,:)))/1000;
%%
clf
figure(1)
plot(Y,'*'); hold on; plot(zt(end,:),'.');
ylabel('Dinner Service');
xlabel('Restaurant');
legend('Actual','Predicted')