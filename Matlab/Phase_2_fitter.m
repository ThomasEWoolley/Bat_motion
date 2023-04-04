ccc
load('Roost_trajectories.mat')
ET=1.5;
Indices=Times/60^2>ET;

confplot2(hours(seconds(Times(Indices)')),rmean(Indices),SE(Indices),'r',0.3);
hold on
plot(hours(seconds(Times(Indices)')),rmean(Indices),'r*');
xlabel('Hours after sunset')
ylabel('MSD in m$^2$')

Indices2=~isnan(rmean);
Indices=Indices&Indices2';

[p1,s] = polyfit(Times(Indices),rmean(Indices),2)
y1 = polyval(p1,Times(Indices));
plot(hours(seconds(Times(Indices))),y1)
Times1=Times;

axis([1.5 8 0 2e6])

export_fig('../Pictures/Phase_2.png','-r300')
save('Phase_2.mat','p1')
%%
clc
mdl = fitlm(Times(Indices),rmean(Indices),'purequadratic')
p1(1)
p1(1)*(60^2)^2
0.00026713*(60^2)^2
p1(2)
p1(2)*(60^2)
9.275*(60^2)
p1(3)

sqrt(2*p1(3))