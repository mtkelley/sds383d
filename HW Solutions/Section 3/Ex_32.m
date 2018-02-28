%Morgan Kelley
%SDS 383D
%Problem 3.2
clear all
load titanic.mat
n=1312;
%% Data processing
Age=table2array(titanic(2:n+1,3));
Survival=string(table2cell(titanic(2:n+1,5)));
Survival_num=2*ones(n,1);
for i=1:n
    if Survival(i)=='No'
        Survival_num(i)=0;
    else
        Survival_num(i)=1;
    end
end
X=Age;
%Remove values with NA for age
X=Age(isnan(Age)==0);

NA2=0;
    for i=1:n
        if isnan(Age(i))
            NA=i;
            NA2=[NA2; NA];
        end 
    end
  NA2(1)=[];  
    Y=Survival_num;
    Y(NA2)=[]; %Delete corresponding values of Y
 %% Minimize the objective
 lambda=1;
 t=3;
 fun=@(beta)(Y-X*beta)'*(Y-X*beta)+lambda*(norm(beta)-t);
 betaR=fminsearch(fun,0);