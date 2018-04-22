function [mu,sigma2,omega,z,p1,p0,s2,m,Ncount,Xcount] = Ex52Func_3(Ns,y,X,init)
n=length(y);
d=1;

%Initial values
a=init(1); b=init(2); muo=init(3); omegao=init(4); sigmao=init(5); weight=init(6);
n0=length(y);
sumX=0;

%Initialize parameter size
mu=zeros(Ns+1,2);
omega=zeros(Ns+1,1);
sigma2=sigmao*ones(size(omega));
z=zeros(Ns+1,n);


%Sample muo
s2o=(1/sigmao^2+n0/sigmao^2)^(-1);
mo=(muo/sigmao^2+(sumX)/sigmao^2)*2/(1/sigmao^2+n0/sigmao^2);
mu(1,:)=normrnd(mo,s2o);
omega(1)=omegao;
sigma2(1)=sigmao;
    
Xsum0=zeros(Ns,1);
Xsum1=Xsum0;
n0=Xsum0;
n1=Xsum0;
mu(1,1) = -0.8;
mu(1,2) = 0.8;
for iter=2:Ns+1
    n0(iter)=0;
    n1(iter)=0;
    Xsum0(iter)=0;
    Xsum1(iter)=0;
    r=rand(n,1);
    for i=1:n
        %sample zi  
        p1 = normpdf(X(i),mu(iter-1,2),sigma2(iter-1));
        p0 = normpdf(X(i),mu(iter-1,1),sigma2(iter-1));
        p1 = p1/(p1+p0);
        if (r(i)<p1)
            z(iter,i)=1;
        else
            z(iter,i)=0;
        end
        %z(iter,i) = y(i);
       
       %Count number of z occurences in each category
        if (z(iter,i)==0)
            n0(iter)=n0(iter)+1;
            Xsum0(iter)=X(i)+Xsum0(iter);
        else
            n1(iter)=n1(iter)+1;
            Xsum1(iter)=X(i)+Xsum1(iter);
        end
    end
    
    Ncount(iter,:)=[n0(iter) n1(iter)];
    Xcount(iter,:)=[Xsum0(iter) Xsum1(iter)];
        
    for k=1:2
        s2(iter)=( (1/sigmao^2) + (Ncount(iter,k)/sigma2(iter-1)) )^(-1);
        m(iter,k)=( (muo/sigmao^2) + ((Xcount(iter,k))/sigma2(iter-1)) )* 1/( (1/sigmao^2) + (Ncount(iter,k)/sigma2(iter-1)) );
        mu(iter,k)=normrnd( m(iter,k), s2(iter) );
    end
end
end

