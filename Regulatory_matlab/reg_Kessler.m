clc; clear; 
%Cwiczenie nr 2
 clc;
 clear all;
 
% Dla podanych parametr�w silnika i warunk�w aproksymacji jego dynamiki, wyznaczy� transmitancj� dyskretn� regulator�w Kesslera w oparciu o:
% 
% 	a) kryterium optimum modu�u
% 	b) kryterium symetryczne
% 
% oraz wyznaczy� przebiegi odpowiedzi skokowych omega(kTp)uk�ad�w regulacji z wyznaczonymi regulatorami dla przypadk�w 
% a) i b), kt�rych parametrami s� zast�pcze sta�e czasowe ?_x (tzn. na jednym wykresie b�dzie �rodzina� krzywych wzgl�dem ?_x)

%Przedmiot: Cyfrowe Uk�ady Regulacji
%Prowadz�cy: Dr in�. Marek Jaworowicz  
%Grupa: A1A1S1
%Wykonanie: Micha� Bokiniec, Violetta Munar Ernandes, Mateusz Janus

s = tf('s');
Tm = 0.18;           % sta�a czasowa elektromechaniczna
Te = 0.03;           % sta�a czasowa elektryczna
Tp = 0.1*Tm;
cefi = 2.62;         % sta�a silnika * strumuie� magnetyczny
Lo_s  = 1/cefi;      % licznik transmitacncji silnika
Mo_s = (Tm*s + 1)*((Tm + Te)*s + 1); % mianowniuk transmitancji silnika
wykonaniePetli = 0;

tfinal = 3;

%//////transmitancja obiektu///////////////
disp(' '); disp(' '); 
disp('Transmitancja ci�g�a obiektu z poc�tkowymi Te i Tm');

Go_s = Lo_s/Mo_s                % transmitancja silnika
disp(' '); disp(' ');
disp('Transmitancja dyskretna obiektu z poc�tkowymi Te i Tm');
Go_z = c2d(Go_s, Tp, 'zoh')        

disp(' '); disp(' ');
disp('Transmitancja obiektu z posczeg�lnymi sumami czastkowymi sigma1, 2, 3:');

sigmaTablica = [0.04, 0.07, 0.09];
for sigma = sigmaTablica;   % sumy cz�stkowe
    wykonaniePetli = wykonaniePetli + 1;
    Mo_s = (Tm*s + 1)*((sigma)*s + 1);% mianowniuk transmitancji silnika
    disp(' '); disp(' ');
    disp(['Transmitancja ci�g�a obiektu dla sigma = ' num2str(sigma)]);
    Go_s = Lo_s/Mo_s
    disp(' '); disp(' ');
    disp(['Transmitancja dyskretna obiektu dla sigma = ' num2str(sigma)]);
    Go_z = c2d(Go_s, Tp, 'zoh') 
    
    %///////Transmitancje filtr�w Butterwortha//////
    
    disp(' '); disp(' ');
    disp(['Transmitancja ci�g�a filtru Butterwortha II rz�du dla sigma = ' num2str(sigma)]);
    %Gb2 = 1/(s^2 + 1.41*s + 1) - podstawowa transmitancja filtru
    Gb2_s = 1/(2*sigma^2*s^2 + 2*sigma*s + 1) 
    
    disp(' '); disp(' ');      
    disp('Filtr Batterwortha II po dyskretyzacji')
    Gb2_z = c2d(Gb2_s, Tp, 'ZOH')
 
    
    disp(' '); disp(' ');
    disp(['Transmitancja ci�g�a filtru Butterwortha III rz�du dla sigma = ' num2str(sigma)])
    %Gb3 = 1/(s^3 + 2*s^2 + 2*s + 1) -  podstawowa transmitancja filtru
    Gb3_s = (4*sigma*s + 1)/(8*sigma^3*s^3 + 8*sigma^2*s^2 + 4*sigma*s + 1) 
    disp(' '); disp(' ');
     
    disp('Filtr Batterwortha III po dyskretyzacji')
    Gb3_z = c2d(Gb3_s, Tp, 'ZOH')
 
    %//////Kryterium modu�u optymalnego//////////////

    disp(' '); disp(' ');
    disp(['Wynaczanie regulatora na podstawie kryterium modu�u optymalnego dla sigma = ' num2str(sigma)])
    
    Gr_opt_z = Gb2_z/(Go_z*(1 - Gb2_z))
    %//////Kryterium symetryczne//////////////

    disp(' '); disp(' ');
    disp(['Wynaczanie regulatora na podstawie kryterium symetrycznego dla sigma = ' num2str(sigma)])

    Gr_sym_z = Gb3_z/(Go_z*(1 - Gb3_z))
    
    %////// Wynzaczanie uk�adu zamkni�tego dla kryterium modu�u optymalnego//////////////
    
    disp(' '); disp(' ');
    disp(['Wynaczanie uk�adu zamkni�tego dyskretnego dla kryterium modu�u optymalnego dla sigma = ' num2str(sigma)])
    Gu_zam_opt = feedback(Go_z*Gr_opt_z, 1,  - 1)
    
    %//////wyznaczanie uk�adu zamkni�tego dla kryterium symetryczne//////////////
    disp(' '); disp(' ');
    disp(['Wynaczanie uk�adu zamkni�tego dyskretnego dla kryterium symetrycznego dla sigma = ' num2str(sigma)])
    Gu_zam_sym = feedback(Go_z*Gr_sym_z, 1,  - 1)
    
%//////////////////Charakterystyki dla uk�adu zamkni�tego///////////////////////
    disp(' '); disp(' ');
    disp(['Wynaczanie chaarakterystyki skokowej dla uk�adu zamkni�tego z regulatorem Kesslera dla kryterium modu�u optymalnego dla sigma = ' num2str(sigma)])
    GZO(wykonaniePetli) = Gu_zam_opt;
    GZS(wykonaniePetli) = Gu_zam_sym;
    
    %//////Wyznaczanie uk�adu otwartego dla kryterium symetryczne////////////// 
    disp(' '); disp(' ');
    disp(['Wynaczanie uk�adu zamkni�tego dyskretnego dla kryterium symetrycznego dla sigma = ' num2str(sigma)])
    Gu_ot_sym = Go_z*Gr_sym_z;
    
    %//////wyznaczanie uk�adu otwartego dla kryterium optimum modu�u////////////// 
    disp(' '); disp(' ');
    disp(['Wynaczanie uk�adu zamkni�tego dyskretnego dla kryterium modulowego optimum dla sigma = ' num2str(sigma)])
    Gu_ot_opt = Go_z*Gr_opt_z;
    
%//////////////////Charakterystyki dla uk�adu otwartego///////////////////////
    
    GOS(wykonaniePetli) = Gu_ot_sym;
    GOO(wykonaniePetli) = Gu_ot_opt;
end

legendaDoWykresow = [];
figure(1);
subplot(2, 2, 1);
step(GZO(1), GZO(2), GZO(3), tfinal);
legend(['sigma = ' num2str(sigmaTablica(1))], ['sigma = ' num2str(sigmaTablica(2))], ['sigma = ' num2str(sigmaTablica(3))]);
xlabel('Pr�bka');   ylabel('Wartosc odpowiedzi');
title('Odpowiedz skokowa uk�adu zamknietego z regulatorem kesslera - kryterium modulowego optimum')

%figure(2)
subplot(2, 2, 2);
step(GZS(1), GZS(2), GZS(3), tfinal);
legend(['sigma = ' num2str(sigmaTablica(1))], ['sigma = ' num2str(sigmaTablica(2))], ['sigma = ' num2str(sigmaTablica(3))]);
xlabel('Pr�bka');   ylabel('Wartosc odpowiedzi');
title('Odpowiedz skokowa uk�adu zamknietego z regulatorem kesslera - kryterium symetryczne')

%figure(3)
subplot(2, 2, 4);
step(GOS(1), GOS(2), GOS(3), tfinal);
legend(['sigma = ' num2str(sigmaTablica(1))], ['sigma = ' num2str(sigmaTablica(2))], ['sigma = ' num2str(sigmaTablica(3))]);
xlabel('Pr�bka');   ylabel('Wartosc odpowiedzi');
title('Odpowiedz skokowa uk�adu otwartego z regulatorem kesslera - kryterium symetryczne ')

%figure(4)
subplot(2, 2, 3);
step(GOO(1), GOO(2), GOO(3), tfinal);
legend(['sigma = ' num2str(sigmaTablica(1))], ['sigma = ' num2str(sigmaTablica(2))], ['sigma = ' num2str(sigmaTablica(3))]);
xlabel('Pr�bka');   ylabel('Wartosc odpowiedzi');
title('Odpowiedz skokowa uk�adu otwartego z regulatorem kesslera - kryterium modulowego optimum')

%{
  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
  Wnioski 
  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
 
  - dla obu kryteri�w (modu�owego optimum  i symetrycznego ) wraz ze
  wzrostem warto��i sigma(susma cz�stkowa) wyd�u�a�a� si� czas regulacji
 
  - dla kryterium symetrycznego  wyst�puje d�u�szy czas regulacji w
  stosunku do kryterium modulu

  - dla uk�adu z zastosowanym kryterium modu�u optymalnego czasy regulacji
  wynosi�y odpowiednio 0.18s, 0.31s, 0.37s dla sigma rownego 0.04s, 0.07s, 0.09s;
  dla uk�adu z zastosowanym kryterium symetrycnego czasy regulacji
  wynosi�y odpowiednio 0.594s, 1.04s, 1.33s dla sigma rownego 0.04s,
  0.07s, 0.09s.
 
  - przy zastosowaniu kryterium symetrycznego zaobserwoali�my wi�ksze
  wzmozcnienie i przeregulowanie ni� dla uk�adu z regulatorem
  zaprojektowanym za pomoc� kryterium modu�owego optimum
 
  - dla uk�adu otwartego wartosc sterowana (wyjsciowa) nie dazy do wartosci zadanej ze
  wzgledu na brak petli sprzezenia zwrotnego
  dla uk�adu z zastosowanym kryterium modu�u optymalnego wartosc wyjsciowa z ukladu
  rosnie liniowo, natomiast dla uk�adu z zastosowanym kryterium
  symetryczznym wzrost wartosci jest paraboliczny
  im mniejsza wartosc sigma, tym szybszy jest wzrost tej wartosci
%}

