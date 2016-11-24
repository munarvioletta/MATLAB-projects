clc 
clear all
y0=2;
x0=0;
xmax=5;
h=0.2;

xrk =x0:h:xmax;
n=length(xrk)-1;
x=zeros(1,5);
y=zeros(1,5);

x(1)=x0+h;
y(1)=y0+h*(exp(x0)-x0-1);
% metoda Eulera
for i=1:n
    x(i+1)=x(i)+h;
    w=fun(x(i),y(i));
    y(i+1)=y(i)+h*w;
end
% funkcja Matlaba
[x,Y] = ode23(@fun,xrk,y0);

%metoda analityczna
u0=2;

for i=1:n+1
u(i)=exp(x(i))-x(i)-1;
end

 plot(x,y,'g',x,Y,'r-',x,u,'b');
 legend('Euler methods', 'function Ode23' , 'analitical') 
 title('Rozwiazanie rownania rozniczkowego')
