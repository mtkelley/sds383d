%% Run original file
run Ex214main;
load Ysubjvar.mat;
%%
ysubj1=ysubj;

[ypredn1,Mo1]=Ex215_func(ysubj1,Y1,ypred1,1,27);
RMSEn1=sqrt(mean((Y1-ypredn1).^2));   

ysubj2=ysubj(:,1:16);
[ypredn2,Mo2]=Ex215_func(ysubj2,Y2,ypred2,1,16);
RMSEn2=sqrt(mean((Y2-ypredn2).^2));

ysubj3=ysubj(:,17:27);
[ypredn3,Mo3]=Ex215_func(ysubj3,Y3,ypred3,1,11);
RMSEn3=sqrt(mean((Y3-ypredn3).^2));

figure(3)
subplot(3,1,1)
plot((1:length(data)),y-ypredn1,'*')
title('Residual plots')
ylabel('R_1')
subplot(3,1,2)
plot((1:GenderSplit),Y2-ypredn2,'*')
ylabel('R_2')
subplot(3,1,3)
plot(GenderSplit+1:length(data),Y3-ypredn3,'*')
xlabel('Observation')
ylabel('R_3')