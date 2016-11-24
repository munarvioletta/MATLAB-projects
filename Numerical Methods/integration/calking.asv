clc
clear all
%
a=1; % wezel - lewa granica przedzialu
b=8; % wezel - prawa granica przedzialu
n=300; % ilosc podprzedzialow

%------------------------------------------------------
%////////////////METODA TRAPEZOWA///////////////////
%------------------------------------------------------
disp('CALKOWANIE NUMERYCZNE METODA TRAPEZOW ')
disp(' ')
h=(b-a)/n;  % krok calkowania
disp(['Krok calkowania = ' num2str(h)])
disp(' ')
xi=1; %zmienna pomocnicza
suma=0;% suma calki obliczonej z wezlow
M = zeros(1, n-1);
figure(1)
plot(M)
for i=1:(n-1)
 xi=xi+h; % kolejne wartosci podprzedzialow
 suma=suma+f(xi);% suma obliczone calki z przedzialow srodkowych
 M(i) = f(xi);

end

disp(['M = ' num2str(M)])% calka w punktach posrednich
disp(' ')
disp(['suma M = ' num2str(suma)])
disp(' ')
disp('Wektor obliczonych calek w punktach ')
disp(' ')
N = [f(a), M , f(b)]; 
disp(['N = ' num2str(N)])

Cw = h*(f(a)/2+suma+f(b)/2);
disp(' ')
disp(['Calka obliczona metoda trapezow = ' num2str(Cw)])

 figure(2)
 plot(n+1,N,'g+')
 figure(3)
 plot(n+1, Cw,'rO')
 figure(4)
 plot(M)

%------------------------------------------------------
%////////////////METODA SIMPSONA///////////////////
%------------------------------------------------------
disp(' ')
disp(' ')
disp(' ')
disp('CALKOWANIE NUMERYCZNE METODA SIMPSONA ')
x=1;
suma_xp = 0;% suma calek wewnetrznych 
sg=0; % suma czastkowa przedzialow parzystch
sm=0; % suma czastkowa przedzialow nieparzystch
g=0; 
m=0;
for p = 1:n-1
    x = x + h; 
     if mod(p,2) == 0
       'parzyse';
       g = 2*f(x);
       sg=sg+g;
    else 
       'nieparzyse';
       m = 4*f(x); 
       sm=sm+m;
     end
end

suma_xp = sg+sm;% suma calek miedz grancami przedzalow (a,b)
Cf = (h/3)*(f(a)+ suma_xp +f(b));
disp(' ')
disp(['suma calek miedzy - grancznych= ' num2str(suma_xp)])% calka w punktach posrednich
disp(' ')
disp(['Calka obliczona metoda Simpsona = ' num2str(Cf)])


