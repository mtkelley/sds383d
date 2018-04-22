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

[mut,sigmat,omega1,zt,Pxi1,Pxi0,s2t,mt,Ncountt,Xcountt]=Ex55Func_3(Ns,Y,X,init);
%%
Prop_Pred=Ncountt(end,:)/1000;
Prop_Actual=[498 502]/1000;

Error=abs(Prop_Pred-Prop_Actual)./Prop_Actual;
%%
clf
figure(1)
subplot(1,2,1)
plot(Ncountt(:,1),'.'); hold on; plot(498*ones(101),'k-');
ylabel('N_0'); xlabel('Iteration');
xlim([1 101]);
legend('Predicted','Actual');
subplot(1,2,2)
plot(Ncountt(:,2),'.'); hold on; plot(502*ones(101),'k-');
xlim([1 101]);
ylabel('N_1'); xlabel('Iteration');
legend('Predicted','Actual');
