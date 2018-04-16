function [mu,sigma2,omega,z,Pxi1,Pxi0] = Ex52Func(Ns,y,X,init)
n=length(y);

%Initialize parameter size
mu=zeros(Ns+1,2);
omega=zeros(Ns+1,1);
sigma2=omega;
z=zeros(Ns+1,n);

%Initial values
a=init(1); b=init(2); muo=init(3); omegao=init(4); sigmao=init(5); weight=init(6);
n0=length(y);
sumX=0;
%Sample muo
s2o=(1/sigmao^2+n0/sigmao^2)^(-1);
mo=(muo/sigmao^2+(sumX)^2/sigmao^2)*2/(1/sigmao^2+n0/sigmao^2);
mu(1,:)=normrnd(mo,s2o);
omega(1)=1;gamrnd(a,b)*prod(normrnd(0,1/omegao));
sigma2(1)=1;1/omega(1);

Xsum0=zeros(Ns);
Xsum1=zeros(Ns);
for iter=2:Ns
    n0=0;
    n1=0;
    Xsum0(iter)=0;
    Xsum1(iter)=0;
    for i=1:n
        %sample zi
        Pxi1(iter,i)=normrnd(mu(iter-1,2),sigma2(iter-1));
        Pxi0(iter,i)=normrnd(mu(iter-1,1),sigma2(iter-1));
        z(iter,i)=binornd(1,abs(Pxi1(iter,i)/((Pxi1(iter,i)+Pxi0(iter,i)))));
        %Count number of z occurences in each category
        if (z(iter,i)==0)
            n0=n0+1;
            Xsum0(iter)=X(i)+Xsum0(iter);
        else
            n1=n1+1;
            Xsum1(iter)=X(i)+Xsum1(iter);
        end
    end
    
    Ncount=[n0 n1];
    Xcount=[Xsum0 Xsum1];
        
    for k=1:2
        s2(k)=(1/sigma2(iter-1)+Ncount(k)/sigma2(iter-1))^(-1);
        m(k)=(muo/sigma2(iter-1)+(Xcount(k))^2/sigma2(iter-1))*2/(1/sigma2(iter-1)+Ncount(k)/sigma2(iter-1));
        mu(iter,k)=normrnd(m(k),s2(k));
        sigma2(iter)=gamrnd(a,b)*prod(normrnd(mu(iter,k),sigma2(iter-1)));
    end
end
end

