%Morgan Kelley
%SDS 383D
%Problem 3.1
global Ko Bo ao bo Kn; %Define hyperparameters as global
load pima.mat

X=[times_pregnant plasma_glucose dia_blood_pressure triceps_skinfold serum_insulin bmi pedigree age];
Y=class_variable;
d=size(X,2); %columns
n=size(X,1); %rows
ao=.1; bo=5; Ko=10*eye(d,d); %constant parameters
Kn=X'*X;+Ko; 
an=ao+size(X,1)/2;
bn=bo;
N=1000; %samples
%Initialize parameters
Bn=zeros(1,8);
tau(1:n)=gamrnd(an,bn);
Bo=Bcond(tau(1),Bn(1,:));
beta(1,:)=Bo;
Z1(1,:)=Zcond(beta(1,:),tau(1),X,Y);
RHO=zeros(1,N); NAR=zeros(1,N); NGIBBS=zeros(1,N);
%% Truncated Multivariate Normal
for i=2:N
    tau(i)=gamrnd(an,bn);
    beta(i,:)=Bcond(tau(i),Bn(i-1,:));
    [Z1(i,:), RHO(i),NAR(i),NGIBBS(i)]=Zcond(beta(i,:),tau(i),X,Y);
    Bn(i,:)=(X'*Z1(i,:)'+Ko*Bo')\Kn;
end
%% Calculate beta mean
betamean=zeros(1,8);
for i=1:d
    betamean(i)=sum(beta(:,i),1)/n;
end
%% Prediction
ypred=size(Y);
for i=1:size(X,1)
if Z1(N,i)<=0
    ypred(i)=0;
else
    ypred(i)=1;
end
end
%% Success of the model
Dif=sum(Y'-ypred);
fracright=abs(Dif)/n;