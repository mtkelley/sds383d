%Morgan Kelley
%Question 3.10

%Stanfit was completed in R, and MATLAB was used to plot and process the
%data.
clear all; close all;
load params_310_2.mat;
load('tea_discipline_oss.mat');
load X_310_2.mat;
%% separating data
Niter=size(params310,1);
Nparams=size(params310,2);
beta=params310(:,1:7);
epsilon=params310(:,8:length(params310));
betaF=beta(Niter,:);
epsilonF=epsilon(Niter,:);

N=height(teadisciplineoss);
Actions=table2array(teadisciplineoss(:,7));
%Remove sensored values
NA2=0;
for i=1:N
    if Actions(i)==-99
        NA=i;
        NA2=[NA2;NA];
    end
end
NA2(1)=[];
Y=Actions;
Y(NA2)=[]; %Delete sensored values of Y
%% Calculating Y
y=zeros(1,20921);
for i=1:20921
y(i)=poissrnd(exp(X(i,:)*betaF')+exp(epsilonF(i)));
end
NMSE=1-(norm(Y-y'))/(norm(Y-mean(Y)));

%% Compared to exercise 3.9:
beta2=[1.49 0.06 0.21 0.92 0.89 0.24 -0.59];
y2=y;
for i=1:20921
y2(i)=poissrnd(exp(X(i,:)*beta2'));
end
NMSE2=1-(norm(Y-y2'))/(norm(Y-mean(Y)));