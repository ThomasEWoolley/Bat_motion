ccc
close
load('Iterated_domain_shrink_R_1782.mat')
plot(hours(seconds(t)),MSD,'k')
hold on
load('Lower_Iterated_domain_shrink_R_1782.mat')
plot(hours(seconds(t)),MSD,'g')
load('Upper_Iterated_domain_shrink_R_1782.mat')
plot(hours(seconds(t)),MSD,'b')
xlabel('Hours after sunset')
ylabel('MSD in m$^2$')
axis([0 8 0 2e6])

load('Roost_trajectories.mat')

confplot2(hours(seconds(Times')),rmean,SE,'r',0.3);
axis([0 8 0 2e6])
xticks(0:2:8)
export_fig('../Pictures/MSD_fit.png','-r300')