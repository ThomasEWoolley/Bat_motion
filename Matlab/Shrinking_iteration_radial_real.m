ccc
load Phase_1


d=p1(1)/4;
td=-p1(2)/p1(1);
Also=[linspace(hours(seconds(td)),2,10) 1:7]*60^2;

load Phase_2
R=ceil(sqrt(2*p1(3)));
x = linspace(0,R,R+1);xx=x;


T=-(p1(2) + sqrt(2*p1(1)*x.^2 - 4*p1(1)*p1(3) + p1(2)^2))/(2*p1(1));
T=T(xx>200);
T=sort(T);

t=sort(unique(cat(2,T,Also)));
t=t(t>td);

ics=zeros(length(x),1);
ics(1)=3/(pi*xx(2)^2);
Vec_sol=nan(length(t),length(x));
Vec_x=nan(length(t),length(x));
Intted=nan(length(t),1);
MSD=nan(length(t),1);

Intted(1)=1;
MSD(1)=0;
Vec_sol(1,:)=ics;
Vec_x(1,:)=x;



for i=1:length(t)-2;
    sol = pdepe(1,@(x,t,u,dudx)pde(d,x,t,u,dudx),@(x)ic(ics,xx,x),@bc,x,linspace(t(i), t(i+1),3));
    Intted(i+1)=trapz(x,x.*sol(end,:))*(2*pi);
    MSD(i+1)=trapz(x,x.^3.*sol(end,:))*(2*pi);
    Vec_sol(i+1,1:length(x))=sol(end,:);
    Vec_x(i+1,1:length(x))=x;


    ics=sol(end,:);
    if t(i+1)>=T(1)
        ics(end-1)=ics(end-1)+2*ics(end)*(x(end)^2-x(end-1)^2)/(x(end-1)^2-x(end-2)^2);

        x(end)=[];
        ics(end)=[];
        T(1)=[];
    end

    if mod(i,100)==0
        i
    end
end
save(['Iterated_domain_shrink_R_',num2str(R),'.mat'])


%%
close
load('Iterated_domain_shrink_R_1782.mat')
plot(hours(seconds(t)),MSD)
xlabel('Hours after sunset')
ylabel('MSD in m$^2$')
axis([0 8 0 2e6])
hold on
load('Roost_trajectories.mat')

confplot2(hours(seconds(Times')),rmean,SE,'r',0.3);
axis([0 8 0 2e6])
xticks(0:2:8)

export_fig('../Pictures/MSD_fit.png','-r300')


%% R2
ccc
load('Iterated_domain_shrink_R_1782.mat')
load('Roost_trajectories.mat')

MSDinterp=interp1(t,MSD,Times');
Indices=~isnan(MSDinterp.*rmean);

1-sum((MSDinterp(Indices)-rmean(Indices)).^2)/sum((rmean(Indices)-mean(rmean(Indices))).^2)






function [c,f,s]=pde(d,x,t,u,dudx)


c=1;
f=d*dudx;
s=0;
end

function u0 =ic(ics,x,xx)
u0=ics(x==xx);
end

function [pl,ql,pr,qr]=bc(xl,ul,xr,ur,t)
pl=0;
ql=1;
pr=0;
qr=1;
end