%Morgan Kelley
%Ex. 5.2
clear all; close all; clc;
load restaurants.mat;

X=[restaurants.DinnerService];
Y=restaurants.Profit;
Y=Scale(Y,0,1);

init=[1 1 1 1 1 1];
Ns=10;


[mut,sigmat,omega1,zt,Pxi1,Pxi0]=Ex52Func(Ns,Y,X,init);