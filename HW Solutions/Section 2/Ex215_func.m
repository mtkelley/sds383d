function [ Mo, ypredn ] = Ex215_func( ysubj,Y,ypred,s1,s2 )
%Morgan  Kelley
%SDS 383D
M=zeros(4,1);
for s=1:s2
M(s)=mean(ysubj(:,s),1); %Calculate mean of each subject
end

Mo=zeros(size(Y));
Mm=zeros(1,4);
    for s=s1:s2 %This loop assigns the subject mean to the line of data in the original table
        for i=1:4
        Mm(i)=M(s);
        end
        if s>1
        Mo=[Mo;Mm'];
        else
            Mo=Mm';
        end
    end
for i=1:length(ysubj)
    ypredn(i)=ypred(i)+(Mo(i)-mean(Y)); %Updated Y prediction
end

end

