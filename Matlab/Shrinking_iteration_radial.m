ccc

R=2000;
x = linspace(0,R,R+1);
xx=x;
ts=seconds(hours(1.5));
alpha=1/(seconds(hours(8))-ts)^2;

T=(R*alpha*ts+sqrt(-x.^2*alpha+R^2*alpha))/(alpha*R);
T=T(xx>200);
T=sort(T);
Also=[linspace(0,2,10) 0:7]*60^2;
t=sort(unique(cat(2,T,Also)));

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
    sol = pdepe(1,@pde,@(x)ic(ics,xx,x),@bc,x,linspace(t(i), t(i+1),3));
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
% save(['Iterated_radial_domain_shrink_R_',num2str(R),'.mat'])
% %%
% close
% % for i=1:length(t)
% % plot(xx,Vec_sol(i,:))
% % title(num2str(i))
% % pause(0.1)
% % drawnow
% % end
% plot(xx,Vec_sol)
% % plot(X(end,:),Vec_sol(end,:))
% % ylim([1,15])
% % yticks(1:15)
% % plot(t,Intted)

%%
close
plot(hours(seconds(t)),MSD)
xlabel('Hours after sunset')
ylabel('m$^2$')
xticks(0:2:8)
axis([0 8 0 2e6])
hold on
plot(hours(seconds(t)),max(Vec_x,[],2).^2/2)
legend('MSD','$R(t)^2$/2','location','s')

export_fig('../Pictures/MSD.png','-r300')

%%

close
figure('position',[0 0.1 1/3 1/3])
l=1;
for i=1:2:7
    pp(l)=plot(xx,Vec_sol(t==i*60*60,:));
    hold on
    
    xline(max(Vec_x(t==i*60*60,:),[],2),'--','color',pp(l).Color,'linewidth',3)
    p{l}=['$t=$ ',num2str(i),' hrs'];
    l=l+1; 
end
legend(pp,p)
xlabel('$r$ in m')
ylabel('$\phi$ in m$^{-1}$')
export_fig('../Pictures/Density.png','-r300')


function [c,f,s]=pde(x,t,u,dudx)
% L=1-t/10;
% dL=-1/10;
d=60;
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