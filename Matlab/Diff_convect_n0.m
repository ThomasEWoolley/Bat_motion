ccc

R=2;
x = linspace(0,R,2e3);
t1 = linspace(0,1.5,150+1);
t2 = linspace(1.5,8,650+1);
D=100/1e3^2*60^2;
sol1 = pdepe(1,@(x,t,u,dudx)Diffusion1(x,t,u,dudx,D,0),@(X)ics1(X,x),@bcs,x,t1);
b=0;
chi_vec=[0.5 1 4];

parfor i=1:length(chi_vec)
    chi=chi_vec(i);
    sol(:,:,i) = pdepe(1,@(x,t,u,dudx)Diffusion2(x,t,u,dudx,D,chi,b),@(X)ics2(X,x,sol1(end,:)),@bcs,x,t2);
end
sol(sol<0)=0;

%%
% close all
% for j=1:length(t2)
%     plot(x,sol(j,:,3))
%     axis([0 R 0 1])
%     title(num2str(round(t2(j))))
%     drawnow
% 
% end

%%
close all
Integrated_phi1=2*pi*trapz(x,x.*sol1,2);
Integrated_phi2=2*pi*trapz(x,x.*sol,2);
plot(t1(2:end),Integrated_phi1(2:end))
hold on
plot(t2,squeeze(Integrated_phi2))
%%
close all

plot(t1,2*pi*trapz(x,sol1*diag(x.^3),2),'k')
hold on
for i=1:length(chi_vec)
    pp(i)=plot(t2,2*pi*trapz(x,sol(:,:,i)*diag(x.^3),2));
    p(i)={[' $\chi = $ ',num2str(chi_vec(i))]};
end
xlabel('$t$ in hours')
ylabel('MSD in km$^2$')
legend(pp,p,'location','best')
export_fig('../Pictures/n_0_convection.png','-r300')


%%
close all
hold on
l=1;
for j=[1 101]
    plot(x,sol1(j,:))
    p(l)={[' $t = $ ',num2str((j-1)/100),' hrs']};
l=l+1;
end
for j=[51 151 251 351]
    plot(x,sol(j,:,2))
    p(l)={[' $t = $ ',num2str(2+(j-51)/100),' hrs']};
l=l+1;
end
axis([0 R 0 1])
xlabel('$r$ in km')
ylabel('$\phi$ in km$^{-1}$')

legend(p,'location','best')
export_fig('../Pictures/n_0_chi_1_convection.png','-r300')
function [c,f,s] = Diffusion1(x,t,u,dudx,D,chi)
u=abs(u);
c = 1;
f = D*dudx;
s = 0;
end
function [c,f,s] = Diffusion2(x,t,u,dudx,D,chi,b)
u(u<0)=0;
c = 1;
f = D*dudx+chi*u*x^b;
s = 0;
end

function u0 = ics1(X,x)
u0=0;
if X==0
    u0=3/(x(2)^2*pi);
end
end

function u0 = ics2(X,x,sol1)
u0=sol1(x==X);
end

function [pl,ql,pr,qr] = bcs(xl,ul,xr,ur,t)
pl = 0; %ignored by solver since m=1
ql = 1; %ignored by solver since m=1
pr = 0;
qr = 1;
end