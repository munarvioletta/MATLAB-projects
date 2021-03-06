clc; clear; fignum = 1;
                        %Cwiczenie nr 3
      %%% Program realizujacy synteze regulatora deadbeat - wyznaczyc
%%% transmitancje dla Tp = [1, 2, 3] dla regulatora bez opo�nie� i bez
%%% ograniczenia sygnalu sterowania oraz bez opoznien i z ograniczeniem
%%% sygnalu sterowania.

%Przedmiot: Cyfrowe Uk�ady Regulacji
%Prowadz�cy: Dr in�. Marek Jaworowicz  
%Grupa: A1A1S1
%Wykonanie: Micha� Bokiniec, Violetta Munar Ernandes, Mateusz Janus



%%------------Regulator "DB" bez ograniczenia amplitudy-----------%%

To = 10;        % sta�a czasowa obiektu
ko = 1;         % wzmocnienie proporcjonalne 

s = tf('s');    % operator ci�g�y Laplace'a 
Go = ko/(To*s + 1)      % transmitancja ci�g�a obiektu

for Tp = [1, 2, 3]       % warto�ci okresu pr�bkowania
    Go_z = c2d(Go, Tp, 'zoh');     % dyskretyzacja obiektu metoda ZOH i o czasie probkowania Tp
    
    [Bz, Az] = tfdata(Go_z, 'v');  % tworzenie macierzy stanu obiektu na podstawie dyskretnej transmitancji obiektu
 
    a1 = Az(2);      % wspolczynnik przy z^(-1) (mianownik)
    b1 = Bz(2);      % wspolczynnik przy z^(-1) (licznik)
   
   
    q0 = 1/b1;     % wspolczynniki regulatora wyznaczone na podstawie elementow a1 i b1 macierzy Az i Bz
    q1 = a1*q0; 
    p1 = b1*q0; 

    z = tf('z', Tp);       % zmienna z deklarowana jako operator Z
    P = p1*z^(-1);         % wyznaczenie mianownika transmitancji regulatora 
    Q = q0 + q1*z^(-1);    % wyznaczenie licznika transmitancji regulatora 
    
    Gr = Q/(1 - P)          % wyznaczenie transmitancji regulatora DB_D
    Gu = Gr*Go_z;            % wyznaczenie modelu ukladu otwartego
    G_zam = feedback(Gu, 1, -1)    % wyznaczanie modelu ukladu zamknietego z jednostkowym ujemnym sprz�eniem zwrotnym,
    Gs = feedback(Gr, Go_z, -1);    % wyznaczanie transmitancji ukladu zamknietego, gdzie wyjsciem jest sygnal sterowania
   
    % wykresy
    figure(fignum),     step(Go, Go_z),  title(['Odpowiedz obiektu ci�g�ego i dyskretnego na wymuszenie skokiem jednostkowym dla Tp=' num2str(Tp)])
    xlabel('Czas');     ylabel('Wartosc odpowiedzi');
    
    figure(fignum + 1), step(G_zam),     title(['Odpowied� skokowa uk�adu zamknietego z regulatorem DB - bez ograniczenia sterowania Tp=' num2str(Tp)])
    xlabel('Czas');     ylabel('Wartosc odpowiedzi');
    
    figure(fignum + 2), step(Gs),        title(['Sygna� steruj�cy - bez ograniczenia sterowania Tp=' num2str(Tp)])
    xlabel('Czas');     ylabel('Wartosc odpowiedzi');
    fignum = fignum +3;
 
end

%%------------Regulator "DB" z ograniczeniem amplitudy-----------%%

c1 = -a1;           % wspolczynnik ograniczenia amplitudy sygnalu sterujacego

q0 = 1/(b1);        % wyznaczenie wspolczynnikow mianownika i licznika regulatora deadbeat
q1 = q0*a1;
p1 = q0*b1;

Q = q0+q1*z^(-1);   % wyznaczenie licznika transmitancji regulatora DB
P = p1*z^(-1);      % wyznaczenie mianownika transmitancji regulatora DB

C = 1+c1*z^(-1);     % wielomian ograniczaj�cy amplitud� sygnalu sterujacego
Gr = Q*C/(1 - P*C);  % wyznaczenie transmitancji regulatora DB_D z ograniczeniem amplitudey
Gu = Gr*Go_z;        % wyznaczenie modelu ukladu otwartego
G_zam = feedback(Gu, 1, -1);    % wyznaczanie modelu ukladu zamknietego z jednostkowym ujemnym sprz�eniem zwrotnym,
Gs = feedback(Gr, Go_z, -1);    % wyznaczanie transmitancji ukladu zamknietego, gdzie wyjsciem jest sygnal sterowania

% wykresy

figure(fignum + 1), step(G_zam),     title(['Odpowied� skokowa uk�adu zamknietego z regulatorem DB - z ograniczeniem sterowania Tp=' num2str(Tp)])
xlabel('Pr�bka');   ylabel('Wartosc odpowiedzi');

figure(fignum + 2), step(Gs),        title('Sygna� steruj�cy - z ograniczeniem sterowania')
xlabel('Pr�bka');   ylabel('Wartosc odpowiedzi');

% WNIOSKI:
%{
    Dla r�nych warto�ci okresu pr�bkowania r�ne by�y odpowiedzi obiektu dyskrenego na skok jednostkowy.
 Dla Tp=1 odpowiedz dyskrenta najlepiej odzorowywa�a odpowiedz obiektu ciag�ego. Natomiast dla okresu pr�bkowania
 Tp=3 pobieraj�cego pr�bk� co 3 sekundy odzworowanie by�o najgorsze(najmniej zbli�one do charakterystyki ci�g�ej)

    Regulacja DB polega na sprowadzeniu warto�ci w�asnych uk�adu 
 do pocz�tku uk�adu wsp�rz�dnych tzn. polega na takim doborze wzmocnie� liniowego sprz�enia
 zwrotnego od stanu aby bieguny uk�adu zamknietego by�y r�wne 0,

  Jedynym parametrem mo�liwym do zmiany jest czas pr�bkowania Tp, 

  Ze wgl�du na warto�� okresu pr�bkowania odpowied� uk�adu na skok jednostkowy jest op�niona o warto�� okresu Tp,
 
        Im kr�tszy jest czas pr�bkowania tym wi�ksze warto�ci sterowania b�d� dzia�a�y na obiekt. 
  Mo�e si� okaza�, �e warto�ci te wykraczaj� poza mo�liwo�ci urz�dze� wykonawczych lub zasilaj�cych. 
  Powoduje to zanik w�a�ciwo�ci regulatora DB polegaj�cych na mo�liwo�ci 
  sprowadzenia obiektu w stan ko�cowy w czasie nTp (gdzie n jest r�wny r�dowi obiektu), 
  jednak efektu tego nie zauwazymy w naszym przypadku poniewaz pracowalismy na matematycznym, 
  a nie rzeczywistym obiekcie.Aby temu zapobiec nale�y zmniejszy� okres pr�bkowania do warto�ci, 
  w kt�rej warto�ci sterowania b�d� mie�ci�y si� w dopuszczalnym zakresie.  

    W zale�no�ci od warto�ci okresu pr�bkowania nastepuje minimalizacja
    uchybu w czasie trwania danego okresu pr�bkowania.

    Na wykresach wida�, �e warto�ci sterowania bez ograniczenia amplitudy 
    trwaj� przez jeden okres pr�bkowania:
    - dla uk�adu Tp = 1s tr = 1s, sygna� steruj�cy = 10.5
    - dla uk�ady Tp = 2s tr = 2s, sygna� steruj�cy = 5.52
    - dla uk�adu Tp = 3s tr = 3s, sygna� steruj�cy = 3.86

    Dla sterowania z ograniczeniem amplitudy zarejestrowalismy czas
    regulacji wynoszacy 6s, czyli minimalizacja uchybu nast�pi�a r�wnie� w czasie r�wnym 6s. 
    Czas regulacji dla obiektu bez regulatora wynosi 31s.

    W przypadku regulatora z ograniczeniem amplitudy watro�� wy�ciowa z uk�adu wzrasta 
    skokowo od wartosci 0 do 1,7 w d�w�ch okresach pr�bkowania.
    
    Dla uk�adu z ograniczeniem amplitudy sterowania nalezalo zastosowac prekompensator, 
    w innym przypadku w ukladzie wystepowal uchyb ustalony.
%}
