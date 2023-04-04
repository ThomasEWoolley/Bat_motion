ccc

R=2;
x = linspace(0,R,200);
t = linspace(0,8,16+1);
D=100/1e3^2*60^2;

sol = pdepe(1,@(x,t,u,dudx)Diffusion(x,t,u,dudx,D),@(X)ics(X,x),@bcs,x,t);



l=1;
for i=[1 2 3:2:10]
plot(x,sol(i,:))
hold on
p(l)={[' $t = $ ',num2str(t(i)),' hrs']};
l=l+1;
end
ylim([0 0.5])
legend(p,'location','best')
xlabel('$r$ in km')
ylabel('$\phi$ in km$^{-1}$')
export_fig('../Pictures/Polar_diffusion.png','-r300')



%%
close all
Integrated_phi=2*pi*trapz(x(1:end),x(1:end).*sol(:,1:end),2);
p1=plot(t,2*pi*trapz(x,sol*diag(x.^3),2)./Integrated_phi,'o');

t = linspace(0,8,1000);
sol = pdepe(1,@(x,t,u,dudx)Diffusion(x,t,u,dudx,D),@(X)ics(X,x),@bcs,x,t);
Integrated_phi=2*pi*trapz(x(1:end),x(1:end).*sol(:,1:end),2);
Integrand=sol(:,end)*x(end)^2./Integrated_phi;
Integrand(1)=0;


hold on
p4=plot(t,cumtrapz(t,4*D*(1-pi*Integrand)),'k');
p2=plot(t,4*D*t,'--r');
p3=plot(t,R^2/(2)*ones(1,length(t)),'--b');


ylim([0 2.1])
xlabel('$t$ in hours')
ylabel('MSD in km$^2$')
legend([p1 p4 p2 p3],'$2\pi\int^R_0r^3\phi(r,t) dr$','$4D\left(t-\pi\int^t_0R^2\phi(R,\tau) d\tau\right)$','$4Dt$','$R^2/2$','location','se','fontsize',15)

export_fig('../Pictures/Polar_diffusion_MSD.png','-r300')

function [c,f,s] = Diffusion(x,t,u,dudx,D)
c = 1;
f = D*dudx;
s = 0;
end

function u0 = ics(X,x)
u0=0;
if X==0
    u0=3/(x(2)^2*pi);
end
end


function [pl,ql,pr,qr] = bcs(xl,ul,xr,ur,t)
pl = 0; %ignored by solver since m=1
ql = 1; %ignored by solver since m=1
pr = 0;
qr = 1;
end