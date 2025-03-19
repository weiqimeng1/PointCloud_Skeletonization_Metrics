x1=0:0.01:24;
y1=exp(sin(0.3409-sin(0.68039*x1)-0.16801*x1));
x2=0.5:1:24;
y2=exp(sin(0.3409-sin(0.68039*x2)-0.16801*x2));

xx=0.5:1:24;
fun=@(x) (exp(sin(0.3409-sin(0.68039*x)-0.16801*x)));
yy=zeros(1,24);
for i =1:24
    yy(i) = integral(fun,-1+i,i);
end
figure,
subplot(121),
plot(x1,y1);
subplot(122),
plot(xx,yy,'-o')