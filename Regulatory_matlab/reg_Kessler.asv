clc; clear; 
%Cwiczenie nr 2
 clc;
 clear all;
 
% Dla podanych parametrów silnika i warunków aproksymacji jego dynamiki, wyznaczyæ transmitancjê dyskretn¹ regulatorów Kesslera w oparciu o:
% 
% 	a) kryterium optimum modu³u
% 	b) kryterium symetryczne
% 
% oraz wyznaczyæ przebiegi odpowiedzi skokowych omega(kTp)uk³adów regulacji z wyznaczonymi regulatorami dla przypadków 
% a) i b), których parametrami s¹ zastêpcze sta³e czasowe ?_x (tzn. na jednym wykresie bêdzie „rodzina” krzywych wzglêdem ?_x)

%Przedmiot: Cyfrowe Uk³ady Regulacji
%Prowadz¹cy: Dr in¿. Marek Jaworowicz  
%Grupa: A1A1S1
%Wykonanie: Micha³ Bokiniec, Violetta Munar Ernandes, Mateusz Janus

s = tf('s');
Tm = 0.18;           % sta³a czasowa elektromechaniczna
Te = 0.03;           % sta³a czasowa elektryczna
Tp = 0.1*Tm;
cefi = 2.62;         % sta³a silnika * strumuieñ magnetyczny
Lo_s  = 1/cefi;      % licznik transmitacncji silnika
Mo_s = (Tm*s + 1)*((Tm + Te)*s + 1); % mianowniuk transmitancji silnika
wykonaniePetli = 0;

tfinal = 3;

%//////transmitancja obiektu///////////////
disp(' '); disp(' '); 
disp('Transmitancja ci¹g³a obiektu z poc¹tkowymi Te i Tm');

Go_s = Lo_s/Mo_s                % transmitancja silnika
disp(' '); disp(' ');
disp('Transmitancja dyskretna obiektu z poc¹tkowymi Te i Tm');
Go_z = c2d(Go_s, Tp, 'zoh')        

disp(' '); disp(' ');
disp('Transmitancja obiektu z posczególnymi sumami czastkowymi sigma1, 2, 3:');

sigmaTablica = [0.04, 0.07, 0.09];
for sigma = sigmaTablica;   % sumy cz¹stkowe
    wykonaniePetli = wykonaniePetli + 1;
    Mo_s = (Tm*s + 1)*((sigma)*s + 1);% mianowniuk transmitancji silnika
    disp(' '); disp(' ');
    disp(['Transmitancja ci¹g³a obiektu dla sigma = ' num2str(sigma)]);
    Go_s = Lo_s/Mo_s
    disp(' '); disp(' ');
    disp(['Transmitancja dyskretna obiektu dla sigma = ' num2str(sigma)]);
    Go_z = c2d(Go_s, Tp, 'zoh') 
    
    %///////Transmitancje filtrów Butterwortha//////
    
    disp(' '); disp(' ');
    disp(['Transmitancja ci¹g³a filtru Butterwortha II rzêdu dla sigma = ' num2str(sigma)]);
    %Gb2 = 1/(s^2 + 1.41*s + 1) - podstawowa transmitancja filtru
    Gb2_s = 1/(2*sigma^2*s^2 + 2*sigma*s + 1) 
    
    disp(' '); disp(' ');      
    disp('Filtr Batterwortha II po dyskretyzacji')
    Gb2_z = c2d(Gb2_s, Tp, 'ZOH')
 
    
    disp(' '); disp(' ');
    disp(['Transmitancja ci¹g³a filtru Butterwortha III rzêdu dla sigma = ' num2str(sigma)])
    %Gb3 = 1/(s^3 + 2*s^2 + 2*s + 1) -  podstawowa transmitancja filtru
    Gb3_s = (4*sigma*s + 1)/(8*sigma^3*s^3 + 8*sigma^2*s^2 + 4*sigma*s + 1) 
    disp(' '); disp(' ');
     
    disp('Filtr Batterwortha III po dyskretyzacji')
    Gb3_z = c2d(Gb3_s, Tp, 'ZOH')
 
    %//////Kryterium modu³u optymalnego//////////////

    disp(' '); disp(' ');
    disp(['Wynaczanie regulatora na podstawie kryterium modu³u optymalnego dla sigma = ' num2str(sigma)])
    
    Gr_opt_z = Gb2_z/(Go_z*(1 - Gb2_z))
    %//////Kryterium symetryczne//////////////

    disp(' '); disp(' ');
    disp(['Wynaczanie regulatora na podstawie kryterium symetrycznego dla sigma = ' num2str(sigma)])

    Gr_sym_z = Gb3_z/(Go_z*(1 - Gb3_z))
    
    %////// Wynzaczanie uk³adu zamkniêtego dla kryterium modu³u optymalnego//////////////
    
    disp(' '); disp(' ');
    disp(['Wynaczanie uk³adu zamkniêtego dyskretnego dla kryterium modu³u optymalnego dla sigma = ' num2str(sigma)])
    Gu_zam_opt = feedback(Go_z*Gr_opt_z, 1,  - 1)
    
    %//////wyznaczanie uk³adu zamkniêtego dla kryterium symetryczne//////////////
    disp(' '); disp(' ');
    disp(['Wynaczanie uk³adu zamkniêtego dyskretnego dla kryterium symetrycznego dla sigma = ' num2str(sigma)])
    Gu_zam_sym = feedback(Go_z*Gr_sym_z, 1,  - 1)
    
%//////////////////Charakterystyki dla uk³adu zamkniêtego///////////////////////
    disp(' '); disp(' ');
    disp(['Wynaczanie chaarakterystyki skokowej dla uk³adu zamkniêtego z regulatorem Kesslera dla kryterium modu³u optymalnego dla sigma = ' num2str(sigma)])
    GZO(wykonaniePetli) = Gu_zam_opt;
    GZS(wykonaniePetli) = Gu_zam_sym;
    
    %//////Wyznaczanie uk³adu otwartego dla kryterium symetryczne////////////// 
    disp(' '); disp(' ');
    disp(['Wynaczanie uk³adu zamkniêtego dyskretnego dla kryterium symetrycznego dla sigma = ' num2str(sigma)])
    Gu_ot_sym = Go_z*Gr_sym_z;
    
    %//////wyznaczanie uk³adu otwartego dla kryterium optimum modu³u////////////// 
    disp(' '); disp(' ');
    disp(['Wynaczanie uk³adu zamkniêtego dyskretnego dla kryterium modulowego optimum dla sigma = ' num2str(sigma)])
    Gu_ot_opt = Go_z*Gr_opt_z;
    
%//////////////////Charakterystyki dla uk³adu otwartego///////////////////////
    
    GOS(wykonaniePetli) = Gu_ot_sym;
    GOO(wykonaniePetli) = Gu_ot_opt;
end

legendaDoWykresow = [];
figure(1);
subplot(2, 2, 1);
step(GZO(1), GZO(2), GZO(3), tfinal);
legend(['sigma = ' num2str(sigmaTablica(1))], ['sigma = ' num2str(sigmaTablica(2))], ['sigma = ' num2str(sigmaTablica(3))]);
xlabel('Próbka');   ylabel('Wartosc odpowiedzi');
title('Odpowiedz skokowa uk³adu zamknietego z regulatorem kesslera - kryterium modulowego optimum')

%figure(2)
subplot(2, 2, 2);
step(GZS(1), GZS(2), GZS(3), tfinal);
legend(['sigma = ' num2str(sigmaTablica(1))], ['sigma = ' num2str(sigmaTablica(2))], ['sigma = ' num2str(sigmaTablica(3))]);
xlabel('Próbka');   ylabel('Wartosc odpowiedzi');
title('Odpowiedz skokowa uk³adu zamknietego z regulatorem kesslera - kryterium symetryczne')

%figure(3)
subplot(2, 2, 4);
step(GOS(1), GOS(2), GOS(3), tfinal);
legend(['sigma = ' num2str(sigmaTablica(1))], ['sigma = ' num2str(sigmaTablica(2))], ['sigma = ' num2str(sigmaTablica(3))]);
xlabel('Próbka');   ylabel('Wartosc odpowiedzi');
title('Odpowiedz skokowa uk³adu otwartego z regulatorem kesslera - kryterium symetryczne ')

%figure(4)
subplot(2, 2, 3);
step(GOO(1), GOO(2), GOO(3), tfinal);
legend(['sigma = ' num2str(sigmaTablica(1))], ['sigma = ' num2str(sigmaTablica(2))], ['sigma = ' num2str(sigmaTablica(3))]);
xlabel('Próbka');   ylabel('Wartosc odpowiedzi');
title('Odpowiedz skokowa uk³adu otwartego z regulatorem kesslera - kryterium modulowego optimum')

%{
  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
  Wnioski 
  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
 
  - dla obu kryteriów (modu³owego optimum  i symetrycznego ) wraz ze
  wzrostem wartoœæi sigma(susma cz¹stkowa) wyd³u¿a³a³ siê czas regulacji
 
  - dla kryterium symetrycznego  wystêpuje d³u¿szy czas regulacji w
  stosunku do kryterium modulu

  - dla uk³adu z zastosowanym kryterium modu³u optymalnego czasy regulacji
  wynosi³y odpowiednio 0.18s, 0.31s, 0.37s dla sigma rownego 0.04s, 0.07s, 0.09s;
  dla uk³adu z zastosowanym kryterium symetrycnego czasy regulacji
  wynosi³y odpowiednio 0.594s, 1.04s, 1.33s dla sigma rownego 0.04s,
  0.07s, 0.09s.
 
  - przy zastosowaniu kryterium symetrycznego zaobserwoaliœmy wiêksze
  wzmozcnienie i przeregulowanie ni¿ dla uk³adu z regulatorem
  zaprojektowanym za pomoc¹ kryterium modu³owego optimum
 
  - dla uk³adu otwartego wartosc sterowana (wyjsciowa) nie dazy do wartosci zadanej ze
  wzgledu na brak petli sprzezenia zwrotnego
  dla uk³adu z zastosowanym kryterium modu³u optymalnego wartosc wyjsciowa z ukladu
  rosnie liniowo, natomiast dla uk³adu z zastosowanym kryterium
  symetryczznym wzrost wartosci jest paraboliczny
  im mniejsza wartosc sigma, tym szybszy jest wzrost tej wartosci
%}

