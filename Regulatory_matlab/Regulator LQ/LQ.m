                    %Cwiczenie nr 1
%Realizacja projektu regulatora liniowo-kwadratowego bez/z obserwatorem
%Przedmiot: Cyfrowe Uk³ady Regulacji
%Prowadz¹cy: DR in¿. Marek Jaworowicz  
%Grupa: A1A1S1
%Wykonanie: Micha³ Bokiniec, Violetta Munar Ernandes, Mateusz Janus

clc; clear; fignum = 1;

%%%%Program wyznaczaj¹cy regulator LQ_A%%

s = tf('s');                                % zmienna s deklarowana jako operator Laplace'a
disp(' Model Ci¹g³y');
G = 1/(s^2)                                 % transmitancja obiektu
[A, B, C, D] = ssdata(G);                   % wyznaczenie macierzy stanu obiektu z transmitancji obiektu
disp(' Model Stanu uk³adu ci¹g³ego');
Gss = ss(G)                                 % tworzenie modelu uk³adu w przestrzeni stanu z transmitancji obiektu
n = size(A, 1);                             % odczyt wymiaru (liczby wierszy) macierzy stanu A i zapisanie tej wartosci do zmiennej n
Q = eye(n);                                 % deklaracja macierzy wagowej Q (jednostkowej) o rozmiarze n

% pêtla FOR realizuj¹ca zmianê wartoœci macierzy wagowej R o zadan¹ wartoœæ

for R = [0.5, 1.0, 10.0]                    % macierz wagowa R iterowana przez wartosci [0.5, 1.0, 10.0]
            
    K = lqr(A, B, Q, R)                     % macierz K regulatora sprzê¿eñ zwrotnych od stanu wyznaczona na podstawie macierzy A, B oraz macierzy wagowych Q i R
    Acl = A -(B*K)                          % Mcierz sterowania 
    disp('Model stanu');     
    Gclz_q = ss(Acl, B, C, 0)               % tworzenie modelu stanu ukladu zamknietego z regulatorem od stanu
    F_q = 1/dcgain(Gclz_q);                 % 1/dcgain - prekompensator, kompensuje (rownowazy) wzmocnienie ukladu [dcgain() - wyznaczenie wzmocnienia ukladu w stanie ustalonym]
    disp('Model stanowy z regulatorem od stanu');
    Gclu_q = ss(Acl, B, -K, 0)             % tworzenie modelu stanu z regulatorem w sprzê¿eniu zwrotnym od stanu
    disp('bieguny');
    P = eig(Acl)                            % wyznaczanie wartosci wlasnych macierzy opisuj¹cych dynamikê ukladu zamknietego 
    L = place(A', C', 3*P);                 % wyznaczenie obserwatora na podstawie macirzy i biegunow
    disp('Mode uk³adu z dyskretnym regulatorem dynamicznym od stanu');
    Css = reg(Gss, K, L')                   % wyznaczanie modelu regulatora dynamicznego w przestrzeni stanu 
    Gclz_o = feedback(Gss, Css, 1)         % wyznaczanie modelu stanu ukladu zamknietego z regulatorem dynamicznym w sprzê¿eniu od stanu
    F_o = 1/dcgain(Gclz_o);                % wyznaczanie prekompensatora dla ukladu z regulatorem dynamicznym
     disp('Mode uk³adu z dyskretnym regulatorem dynamicznym od stanu- sygnal sterujacy');
    Gclu_o = feedback(Gss*Css, 1, 1)       % wyznaczanie modelu stanu z regulatorem dynamicznym w g³ónym torze uk³adu w celu uzyskania na wyjœciu sygna³u sterowania

    tfinal = 10;                            % czas koncowy badania przebiegu
    
    %wykresy skokowy i sygna³u sterowania z regultora
    
    figure(fignum), step(F_q*Gclz_q, F_o*Gclz_o, tfinal), title(['Odpowiedz skokowa ukladu zamknietego bez/z obserwatorem z R=' num2str(R)]), grid;
    legend('Uklad statyczny','Uklad dynamiczny');
    figure(fignum+1), step(F_q*Gclu_q, F_o*Gclu_o, tfinal), title(['Sygnal sterujacy ukladu zamknietego bez/z obserwatorem z R=' num2str(R)]), grid;
    legend('Uklad statyczny','Uklad dynamiczny');
    fignum = fignum + 2;
end

% Wnioski:

% Z charakterystyk odpowiedzi skokowej uk³adu zamknietego o ro¿nej wartoœci macierzy wagowej
% R=[0.5,1,10] mo¿emy stwierdziæ, ¿e im wiêksza jest wartoœæ R tym
% wiêksze jest przeregulowanie i d³u¿szy czas regulacji.

% Mozna zauwazyc ze uklad dynamiczny dla okreslonej wartosci R posiada
% minimalnie dluzszy czas regulacji niz uklad statyczny. Jest to
% spowodowane opoznieniem wprowadzanym przez obserwator. Opónienie to jest tym mniejsze im
% dalej sa przesuniête bieguny obserwatora w kierunku ujemnej czêsci osi
% rzecyzwistych.

% Odpowiedz skokowa uk³adu z obserwatorem przyjmuje kszta³t tym bardziej zbli¿ony do odpowiedzi skokowej 
% uk³adu bez obserwatora wraz ze zmniejszeniem (przesuniêciem biegunów po osi rzeczywistej w lewo)
% wartoœci w³asnych macierzy P.

% Na wykresie u(t) widac takze, ze amlpituda sygnalu sterowania zmniejsza sie wraz ze wzrostem 
% wartosci wagowej R, oznacza to ¿e im wy¿sze koszty sterowania tym wiêkszy stosuje siê rz¹d
% wspó³czynnika R do minimalizacji amplitudy i wymagañ jakoœciowych. 
% Widaæ te¿, ze dla okreslonej wartosci R mniejsz¹ amplitudê ma sygnal sterujacy w
% ukladzie z obserwatorem stanu niz sygnal sterujacy ukladu bez obserwatora.

% Wartoœæ macierzy wagowej R wp³ywa na czas regulacji/ustalania siê
% sygna³u steruj¹cego u(t), im wieksza wartosæ R tym d³u¿szy czas regulacji.

% Wy³¹czaj¹c prekompensator zauwa¿amy, ¿e zarówno uk³ad statyczny jak i
% dynamiczny ustalaj¹ siê na wartoœciach innych ni¿ jeden. Przy w³¹czonym,
% prekompensatorze wartoœæ wyjœciowa sygna³u d¹zy do wartoœci adanej.


%%%%Program wyznaczaj¹cy regulator LQ_D %%
%%%% DYSRETYZCJA %%%%
disp(' Model Dyskretny');
Tp = 0.5;                                   % czas probkowania
Gz = c2d(G,Tp, 'zoh')                       % dyskretyzacja transmitancji modelu ciaglego obiektu metoda ZOH
disp(' Model Stanu obiektu dyskretnego');
[A,B,C,D] = ssdata(Gz);                     % wyznaczenie macierzy stanu obiektu z transmitancji obiektu 
Gss_z = ss(A,B,C,D,Tp)                      % tworzenie modelu uk³au w przestrzeni stanu z macierzy stanu obiektu

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
    disp('Model uk³adu z dyskretnym regulatore dynamidznym');
    Css_z = reg(Gss_z, K, L')               % wyznaczanie modelu w przestrzeni stanu regulatora dynamicznego

    Gclz_o=feedback(Gss_z, Css_z, 1);       % wyznaczanie modelu stanu ukladu zamknietego z regulatorem dynamicznym w sprzê¿eniu od stanu                     
    F_o=1%/dcgain(Gclz_o);                   % wyznaczanie prekompensatora dla ukladu z regulatorem dynamicznym           
    Gclu_o=feedback(Gss_z*Css_z, 1, 1);     % wyznaczanie modelu stanu z regulatorem dynamicznym w g³ónym torze uk³adu
    
    %wykresy skokowy i sygna³u sterowania z regultora
    
    figure(fignum), step(F_q*Gclz_q, F_o*Gclz_o, tfinal), title(['OdpowiedŸ skokowa dyskretnego uk³adu zamkniêtego bez/z obserwatorem z R=' num2str(R)]), grid
    legend('Uklad statyczny','Uklad dynamiczny');
    figure(fignum+1), step(F_q*Gclu_q, F_o*Gclu_o, tfinal), title(['Sygnal steruj¹cy uk³adu dyskretnego z R=' num2str(R)]), grid
    legend('Uklad statyczny','Uklad dynamiczny');
    fignum = fignum +2;
end

% WNIOSKI:
%{
    Z charakterystyk czasowych wynika, ¿e wartoœæ parametru R nie wp³ywa
    znacz¹co na czas regulacji zarówno uk³adu statycznego jak i dynamicznego.

    Czas regulacji uk³adu dynamicznego by³ wiêkszy ni¿ statycznego dla ka¿dej
    wartoœci parametru R. Spowodowane jest to dodatkowym opóŸnieniem
    wprowadzanym przez obserwator. Zbli¿aj¹c bieguny obserwatora do pocz¹tku uk³adu wspó³rzêdnych mo¿na
    zauwa¿yæ skrócenie czasu regulacji uk³adu dynamicznego, które wynika ze
    zmniejszenia bezw³adnoœci obserwatora. 

    Amplituda sygna³u sterowania jest tym mniejsza im wiêksza jest wartoœæ
    parametru R.

    Wy³¹czaj¹c prekompensator zauwa¿amy, ¿e zarówno uk³ad statyczny jak i
    dynamiczny ustalaj¹ siê na wartoœciach innych ni¿ jeden. Prekompensator
    eliminuje zatem zjawisko uchybu ustalonego.
%}

