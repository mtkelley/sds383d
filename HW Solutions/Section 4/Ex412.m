%Morgan Kelley
%Ex 4.12 and 4.13
clear all; close all;
%% Process the data
load iris.mat
setosa=table2array(iris(1:50,1:5));
versicolor=table2array(iris(51:100,1:5));
virginica=table2array(iris(101:150,1:5));

data=[setosa zeros(length(setosa),1);versicolor ones(length(versicolor),1)];

x1=data(:,2); x2=data(:,3); x3=data(:,4); x4=data(:,5);
y=data(:,6);
X=[x1 x2 x3 x4];
alpha=1; l=5; sigma=1;
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
J= @(f) Jfunc(y,f,K);
opns=optimoptions('fmincon','Algorithm','interior-point','UseParallel',true,'Display','iter-detailed');
MAP = fmincon(J,randn(length(y),1),[],[],[],[],[],[],[],opns);
%% Hessian Ex 4.13
H = zeros(length(y));
for i = 1:length(y)
	P = ((1/(1+exp(-MAP(i))))^y(i))*((1-1/(1+exp(-MAP(i))))^(1-y(i)));
	dPdf = y(i)*exp(MAP(i))/(1+exp(MAP(i))) - exp(MAP(i)*(y(i)+1))/(1+exp(MAP(i)))^2 - MAP(i)*sum(Ki(i,:));
	dP2df2 = y(i)^2*exp(MAP(i))/(exp(MAP(i))+1)-exp(MAP(i))^(y(i)+1)/(exp(MAP(i))+1)^2+2*exp(MAP(i))^(y(i)+2)/(exp(MAP(i))+1)^3;
	H(i,i) = -1/P^2*dPdf^2+1/P*dP2df2-sum(Ki(i,:));
end
% Uncertainty
err=sqrt(abs(diag(-inv(H))));
% Predictions
m=1./(1+exp(-MAP));
mlow=1./(1+exp(-MAP+1.96*err));
mup=1./(1+exp(-MAP-1.96*err));

%% Plot
clf
figure(1); hold on;
plot(m); plot(y);plot(mlow),plot(mup);
legend('Probability','Actual','Lower Bound','Upper Bound','Location','west')

figure(2);
scatter3(X(:,1),X(:,2),MAP);
xlabel('Sepal Length'); ylabel('Sepal Width'); zlabel('Prediction');