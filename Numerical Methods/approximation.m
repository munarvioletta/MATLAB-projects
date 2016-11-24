clc
clear all
x=[1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0,10.0];
y=[3.12, 3.58, 4.23, 4.5, 4.77, 5.10, 5.40, 5.69,  5.78, 6.00]; 
%------------------------------------------------------
%aproksymacja funkcja liniowa y =a1x+a0
%------------------------------------------------------
% wyznaczanie wspolcynnikow rownania liniowego a0 i a1 dla zadanych
% argumentow i wartosci funkcji
disp('APROKSYMACJA FUNKCJA LINIOWA')
disp(' ')
p = polyfit(x,y,1);%wyznaczanie wspolcynnikow wilomiana 1 stopnia

disp(['Wspolczynnik a0 wynosi = ' num2str(p(2))])
disp(['Wspolczynnik a1 wynosi = ' num2str(p(1))])

zakres=1:1:10;
prosta = polyval(p,zakres);%oblicza wartosci funkcji aproksymujacej
                          % na podstawie punktow pomiarowych

%------------------------------------------------------
%b³¹d aproksymacji sredniokwadratowej F=suma(prosta-y)^2
%------------------------------------------------------
 suma = 0; %suma odchylek
 
for i=1:10 
    
    F =(prosta(i)-y(i))^2;
    suma =  suma + F; 
    
end
disp(' ')
disp(['Ba³ad aproksymacji wynosi = ' num2str(suma)])
disp(' ')
disp(' ')
disp(' ')

%------------------------------------------------------
%  aproksymacja funkcja potengowa y= c*x^n
%------------------------------------------------------
disp('APROKSYMACJA FUNKCJA POTEGOWA')
b = 10; %ilosc pomiarow(argumantow funkcji)
%y=c * x^n;
X = log(x);
Y = log(y);
% liczenie wspolczynnikow funkcji metoda œredniokwadratow¹

EX=sum(X);
disp(' ')
disp(['Suma wartosci X = ' num2str(EX)])
Mx = mean(X);%srednia wartosci X
disp(['Srednia wartosci X = ' num2str(Mx)])
EY=sum(Y);
disp(' ')
disp(['Suma wartosci Y = ' num2str(EY)])
My = mean(Y);%srednia wartosci Y
disp(['Srednia wartosci Y = ' num2str(My)])
disp(' ')
suma_kwadrat_X = 0;
suma_xy=0;
sr_X_2 = Mx^2;% (srednia_X)^2

for i=1:10
    mnoz_xy = X(i)* Y(i);   
    suma_xy = suma_xy + mnoz_xy; % suma x(i)*y(i)
    kwadrat_X = X(i)^2; %wartosci X podniesione do kwadratu
    suma_kwadrat_X = suma_kwadrat_X + kwadrat_X;% suma x(i)^2
end

disp(['suma x(i)^2 = '  num2str(suma_kwadrat_X)]) %dziala tez SXX=sum(X.*X) 
disp(['suma x(i)*y(i) = '  num2str(suma_xy)])%dziala tez SXY=sum(X.*Y)

A1 = (suma_xy - b*Mx*My)/(suma_kwadrat_X - sr_X_2*b);
A0 = My-Mx*A1;
disp(' ')
disp(['Wspolczynnik A0 wynosi = ' num2str(A0)])
disp(['Wspolczynnik A1 wynosi = ' num2str(A1)])

% funkcja aproksymacyjna
F=A0+X*A1;
% wspolczynniki y = c*x^n
n = A1;
disp(['Wartosc potengi n = ' num2str(n)])
%log(c) = A0;
c = exp(A0);
disp(['Wartosc wspolczynnika c = ' num2str(c)])
y_pot = c*x.^n;

%------------------------------------------------------
%  wswietlanie wykresow funckji
%------------------------------------------------------

%wykresy(x, y, zakres, prosta, y_pot);

%------------------------------------------------------
%b³¹d aproksymacji sredniokwadratowej F=suma(prosta-y)^2
%------------------------------------------------------
 suma2 = 0; %suma odchylek
 
for i=1:10 
    
    F =(y_pot(i)-y(i))^2;
    suma2 =  suma2 + F; 
    
end
disp(' ')
disp(['Ba³ad aproksymacji wynosi = ' num2str(suma2)])

plot(x,y,'g+',zakres,prosta, 'r-'),legend('punkty','aproksymacja funkcj¹ liniow¹ y=a1x+a0');
legend('wêz³y','aproksymacja funkcj¹ liniow¹');

plot (x,y,'g+',x,prosta,'r-',x,y_pot,'-b'),title('Aproksymacja funkcja y=ax+b i y=c+x^n'),
legend('wêz³y','aproksymacja funkcj¹ liniow¹','aproksymacja funkcja potengowa');
hold off;

 
