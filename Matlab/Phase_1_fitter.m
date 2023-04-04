ccc
load('Roost_trajectories.mat')
ET=1.5;
Indices=Times/60^2<=ET;

confplot2(hours(seconds(Times(Indices)')),rmean(Indices),SE(Indices),'r',0.3);
hold on
plot(hours(seconds(Times(Indices)')),rmean(Indices),'r*');
xlabel('Hours after sunset')
ylabel('MSD in m$^2$')

Indices2=~isnan(rmean);
Indices=Indices&Indices2';

[p1,s] = polyfit(Times(Indices),rmean(Indices),1)
y1 = polyval(p1,Times(Indices));
plot(hours(seconds(Times(Indices))),y1)
Times1=Times;

axis([0 1.5 0 2e6])

export_fig('../Pictures/Phase_1.png','-r300')
save('Phase_1.mat','p1')
%%
clc
mdl = fitlm(Times(Indices),rmean(Indices))
dn=(p1(1)-13.863)/(4);
d0=(p1(1))/(4)
dp=(p1(1)+13.863)/(4);
sqrt(d0/pi)
sqrt(dn/pi)-sqrt(d0/pi)
sqrt(dp/pi)-sqrt(d0/pi)
-p1(2)/p1(1)
minutes(seconds(-p1(2)/p1(1)))