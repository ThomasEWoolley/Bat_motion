function confplot2(x,y,se,c,a)
indices=(~isnan(y));
x=x(indices);
y=y(indices);
se=se(indices);
fill([x;flipud(x)],[y-se;flipud(y+se)],c,'linestyle','none','FaceAlpha',a);
hold on

plot(x,y,c)

end
