                    %Cwiczenie nr 1
%Realizacja projektu regulatora liniowo-kwadratowego bez/z obserwatorem
%Przedmiot: Cyfrowe Uk�ady Regulacji
%Prowadz�cy: DR in�. Marek Jaworowicz  
%Grupa: A1A1S1
%Wykonanie: Micha� Bokiniec, Violetta Munar Ernandes, Mateusz Janus

clc; clear; fignum = 1;

%%%%Program wyznaczaj�cy regulator LQ_A%%

s = tf('s');                                % zmienna s deklarowana jako operator Laplace'a
disp(' Model Ci�g�y');
G = 1/(s^2)                                 % transmitancja obiektu
[A, B, C, D] = ssdata(G);                   % wyznaczenie macierzy stanu obiektu z transmitancji obiektu
disp(' Model Stanu uk�adu ci�g�ego');
Gss = ss(G)                                 % tworzenie modelu uk�adu w przestrzeni stanu z transmitancji obiektu
n = size(A, 1);                             % odczyt wymiaru (liczby wierszy) macierzy stanu A i zapisanie tej wartosci do zmiennej n
Q = eye(n);                                 % deklaracja macierzy wagowej Q (jednostkowej) o rozmiarze n

% p�tla FOR realizuj�ca zmian� warto�ci macierzy wagowej R o zadan� warto��

for R = [0.5, 1.0, 10.0]                    % macierz wagowa R iterowana przez wartosci [0.5, 1.0, 10.0]
            
    K = lqr(A, B, Q, R)                     % macierz K regulatora sprz�e� zwrotnych od stanu wyznaczona na podstawie macierzy A, B oraz macierzy wagowych Q i R
    Acl = A -(B*K)                          % Mcierz sterowania 
    disp('Model stanu');     
    Gclz_q = ss(Acl, B, C, 0)               % tworzenie modelu stanu ukladu zamknietego z regulatorem od stanu
    F_q = 1/dcgain(Gclz_q);                 % 1/dcgain - prekompensator, kompensuje (rownowazy) wzmocnienie ukladu [dcgain() - wyznaczenie wzmocnienia ukladu w stanie ustalonym]
    disp('Model stanowy z regulatorem od stanu');
    Gclu_q = ss(Acl, B, -K, 0)             % tworzenie modelu stanu z regulatorem w sprz�eniu zwrotnym od stanu
    disp('bieguny');
    P = eig(Acl)                            % wyznaczanie wartosci wlasnych macierzy opisuj�cych dynamik� ukladu zamknietego 
    L = place(A', C', 3*P);                 % wyznaczenie obserwatora na podstawie macirzy i biegunow
    disp('Mode uk�adu z dyskretnym regulatorem dynamicznym od stanu');
    Css = reg(Gss, K, L')                   % wyznaczanie modelu regulatora dynamicznego w przestrzeni stanu 
    Gclz_o = feedback(Gss, Css, 1)         % wyznaczanie modelu stanu ukladu zamknietego z regulatorem dynamicznym w sprz�eniu od stanu
    F_o = 1/dcgain(Gclz_o);                % wyznaczanie prekompensatora dla ukladu z regulatorem dynamicznym
     disp('Mode uk�adu z dyskretnym regulatorem dynamicznym od stanu- sygnal sterujacy');
    Gclu_o = feedback(Gss*Css, 1, 1)       % wyznaczanie modelu stanu z regulatorem dynamicznym w g��nym torze uk�adu w celu uzyskania na wyj�ciu sygna�u sterowania

    tfinal = 10;                            % czas koncowy badania przebiegu
    
    %wykresy skokowy i sygna�u sterowania z regultora
    
    figure(fignum), step(F_q*Gclz_q, F_o*Gclz_o, tfinal), title(['Odpowiedz skokowa ukladu zamknietego bez/z obserwatorem z R=' num2str(R)]), grid;
    legend('Uklad statyczny','Uklad dynamiczny');
    figure(fignum+1), step(F_q*Gclu_q, F_o*Gclu_o, tfinal), title(['Sygnal sterujacy ukladu zamknietego bez/z obserwatorem z R=' num2str(R)]), grid;
    legend('Uklad statyczny','Uklad dynamiczny');
    fignum = fignum + 2;
end

% Wnioski:

% Z charakterystyk odpowiedzi skokowej uk�adu zamknietego o ro�nej warto�ci macierzy wagowej
% R=[0.5,1,10] mo�emy stwierdzi�, �e im wi�ksza jest warto�� R tym
% wi�ksze jest przeregulowanie i d�u�szy czas regulacji.

% Mozna zauwazyc ze uklad dynamiczny dla okreslonej wartosci R posiada
% minimalnie dluzszy czas regulacji niz uklad statyczny. Jest to
% spowodowane opoznieniem wprowadzanym przez obserwator. Op�nienie to jest tym mniejsze im
% dalej sa przesuni�te bieguny obserwatora w kierunku ujemnej cz�sci osi
% rzecyzwistych.

% Odpowiedz skokowa uk�adu z obserwatorem przyjmuje kszta�t tym bardziej zbli�ony do odpowiedzi skokowej 
% uk�adu bez obserwatora wraz ze zmniejszeniem (przesuni�ciem biegun�w po osi rzeczywistej w lewo)
% warto�ci w�asnych macierzy P.

% Na wykresie u(t) widac takze, ze amlpituda sygnalu sterowania zmniejsza sie wraz ze wzrostem 
% wartosci wagowej R, oznacza to �e im wy�sze koszty sterowania tym wi�kszy stosuje si� rz�d
% wsp�czynnika R do minimalizacji amplitudy i wymaga� jako�ciowych. 
% Wida� te�, ze dla okreslonej wartosci R mniejsz� amplitud� ma sygnal sterujacy w
% ukladzie z obserwatorem stanu niz sygnal sterujacy ukladu bez obserwatora.

% Warto�� macierzy wagowej R wp�ywa na czas regulacji/ustalania si�
% sygna�u steruj�cego u(t), im wieksza wartos� R tym d�u�szy czas regulacji.

% Wy��czaj�c prekompensator zauwa�amy, �e zar�wno uk�ad statyczny jak i
% dynamiczny ustalaj� si� na warto�ciach innych ni� jeden. Przy w��czonym,
% prekompensatorze warto�� wyj�ciowa sygna�u d�zy do warto�ci adanej.


%%%%Program wyznaczaj�cy regulator LQ_D %%
%%%% DYSRETYZCJA %%%%
disp(' Model Dyskretny');
Tp = 0.5;                                   % czas probkowania
Gz = c2d(G,Tp, 'zoh')                       % dyskretyzacja transmitancji modelu ciaglego obiektu metoda ZOH
disp(' Model Stanu obiektu dyskretnego');
[A,B,C,D] = ssdata(Gz);                     % wyznaczenie macierzy stanu obiektu z transmitancji obiektu 
Gss_z = ss(A,B,C,D,Tp)                      % tworzenie modelu uk�au w przestrzeni stanu z macierzy stanu obiektu

n = size(A, 1);                             % odczytywanie ilosci wierszy macierzy stanu A            
Q = eye(n);                                 % deklaracja macierzy jednostkowej o rozmiarze n

for R = [0.5, 1.0, 10.0]                    % macierz wagowa R iterowana przez wartosci [0.5, 1.0, 10.0]
    disp(' Dyskretny regulator statyczny');
    K = lqrd(A, B, Q, R, Tp)                % dyskretny regulator statyczny wyznaczony na podstawie macierzy A, B, wagowych Q, R uwzgladniajac okres probkowania Tp
    Ac1 = A - B*K;                          % Macierz sterowania
    Gclz_q = ss(Ac1, B, C, 0, Tp);          % tworzenie modelu stanu dyskretnego ukladu zamknietego 
    F_q = 1%/dcgain(Gclz_q);                 % wzynacyanie prekomprensatora
    Gclu_q = ss(Ac1, B, -K, 0, Tp);         % tworzenie modelu stanu z regulatorem statycznym od stanu
    P = eig(Ac1);                           % zwraca wartosci wlasne ukladu z regulatorem - zadane polozenie pierwiastkow ukladu stabilnego z regulatorem
    disp(' Obserwator');
    L = place(A', C', P);                   % wyznaczenie obserwatora na podstawie A, C i biegunow P
    disp('Model uk�adu z dyskretnym regulatore dynamidznym');
    Css_z = reg(Gss_z, K, L')               % wyznaczanie modelu w przestrzeni stanu regulatora dynamicznego

    Gclz_o=feedback(Gss_z, Css_z, 1);       % wyznaczanie modelu stanu ukladu zamknietego z regulatorem dynamicznym w sprz�eniu od stanu                     
    F_o=1%/dcgain(Gclz_o);                   % wyznaczanie prekompensatora dla ukladu z regulatorem dynamicznym           
    Gclu_o=feedback(Gss_z*Css_z, 1, 1);     % wyznaczanie modelu stanu z regulatorem dynamicznym w g��nym torze uk�adu
    
    %wykresy skokowy i sygna�u sterowania z regultora
    
    figure(fignum), step(F_q*Gclz_q, F_o*Gclz_o, tfinal), title(['Odpowied� skokowa dyskretnego uk�adu zamkni�tego bez/z obserwatorem z R=' num2str(R)]), grid
    legend('Uklad statyczny','Uklad dynamiczny');
    figure(fignum+1), step(F_q*Gclu_q, F_o*Gclu_o, tfinal), title(['Sygnal steruj�cy uk�adu dyskretnego z R=' num2str(R)]), grid
    legend('Uklad statyczny','Uklad dynamiczny');
    fignum = fignum +2;
end

% WNIOSKI:
%{
    Z charakterystyk czasowych wynika, �e warto�� parametru R nie wp�ywa
    znacz�co na czas regulacji zar�wno uk�adu statycznego jak i dynamicznego.

    Czas regulacji uk�adu dynamicznego by� wi�kszy ni� statycznego dla ka�dej
    warto�ci parametru R. Spowodowane jest to dodatkowym op�nieniem
    wprowadzanym przez obserwator. Zbli�aj�c bieguny obserwatora do pocz�tku uk�adu wsp�rz�dnych mo�na
    zauwa�y� skr�cenie czasu regulacji uk�adu dynamicznego, kt�re wynika ze
    zmniejszenia bezw�adno�ci obserwatora. 

    Amplituda sygna�u sterowania jest tym mniejsza im wi�ksza jest warto��
    parametru R.

    Wy��czaj�c prekompensator zauwa�amy, �e zar�wno uk�ad statyczny jak i
    dynamiczny ustalaj� si� na warto�ciach innych ni� jeden. Prekompensator
    eliminuje zatem zjawisko uchybu ustalonego.
%}

