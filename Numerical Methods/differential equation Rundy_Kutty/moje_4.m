%------Rozwi¹zywanie równan ró¿niczkowych metoda rundego-kutty
% funkcja y'=x+y
clc 
clear all
y1=2;% warunki poczatkowe
x1=0;% warunki poczatkowe
xmax=3; % zakres max
h=1;
%przedzial [1,3]
xrk =x1:h:xmax;
n=length(xrk)-1
x=zeros(0,3);
y=zeros(0,3);

x(1)=0;
y(1) = 2;
% metoda RK
for i=1:n   
    x(i+1)=x(i)+h;
    w=fun(x(i),y(i));
    k1=h*w;
    k2=h*fun(x(i)+h/2,y(i)+(k1/2));
    k3=h*fun(x(i)+h/2,y(i)+(k2/2));
    k4=h*fun(x(i)+h,y(i)+k3);
    y(i+1)=y(i)+(k1/6)+(k2/3)+(k3/3)+(k4/6);
end

% funkcja Matlaba
[x,F] = ode45(@fun,xrk,y1);

%metoda analityczna
C=3;
u=zeros(0,3);

for i=1:n+1
x(1)=0;
u(i)=C*expm(x(i))-x(i)-1;
end
u
y
F
 plot(x,y,'g',x,F,'r-',x,u,'b')
 legend('Rundy - Kutty Method','function Ode45' ,'analitical')
 title('Rozwiazanie rownania rozniczkowego')
