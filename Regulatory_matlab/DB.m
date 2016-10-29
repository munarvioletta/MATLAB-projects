clc; clear; fignum = 1;
                        %Cwiczenie nr 3
      %%% Program realizujacy synteze regulatora deadbeat - wyznaczyc
%%% transmitancje dla Tp = [1, 2, 3] dla regulatora bez opoóŸnieñ i bez
%%% ograniczenia sygnalu sterowania oraz bez opoznien i z ograniczeniem
%%% sygnalu sterowania.

%Przedmiot: Cyfrowe Uk³ady Regulacji
%Prowadz¹cy: Dr in¿. Marek Jaworowicz  
%Grupa: A1A1S1
%Wykonanie: Micha³ Bokiniec, Violetta Munar Ernandes, Mateusz Janus



%%------------Regulator "DB" bez ograniczenia amplitudy-----------%%

To = 10;        % sta³a czasowa obiektu
ko = 1;         % wzmocnienie proporcjonalne 

s = tf('s');    % operator ci¹g³y Laplace'a 
Go = ko/(To*s + 1)      % transmitancja ci¹g³a obiektu

for Tp = [1, 2, 3]       % wartoœci okresu próbkowania
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
    G_zam = feedback(Gu, 1, -1)    % wyznaczanie modelu ukladu zamknietego z jednostkowym ujemnym sprzê¿eniem zwrotnym,
    Gs = feedback(Gr, Go_z, -1);    % wyznaczanie transmitancji ukladu zamknietego, gdzie wyjsciem jest sygnal sterowania
   
    % wykresy
    figure(fignum),     step(Go, Go_z),  title(['Odpowiedz obiektu ci¹g³ego i dyskretnego na wymuszenie skokiem jednostkowym dla Tp=' num2str(Tp)])
    xlabel('Czas');     ylabel('Wartosc odpowiedzi');
    
    figure(fignum + 1), step(G_zam),     title(['OdpowiedŸ skokowa uk³adu zamknietego z regulatorem DB - bez ograniczenia sterowania Tp=' num2str(Tp)])
    xlabel('Czas');     ylabel('Wartosc odpowiedzi');
    
    figure(fignum + 2), step(Gs),        title(['Sygna³ steruj¹cy - bez ograniczenia sterowania Tp=' num2str(Tp)])
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

C = 1+c1*z^(-1);     % wielomian ograniczaj¹cy amplitudê sygnalu sterujacego
Gr = Q*C/(1 - P*C);  % wyznaczenie transmitancji regulatora DB_D z ograniczeniem amplitudey
Gu = Gr*Go_z;        % wyznaczenie modelu ukladu otwartego
G_zam = feedback(Gu, 1, -1);    % wyznaczanie modelu ukladu zamknietego z jednostkowym ujemnym sprzê¿eniem zwrotnym,
Gs = feedback(Gr, Go_z, -1);    % wyznaczanie transmitancji ukladu zamknietego, gdzie wyjsciem jest sygnal sterowania

% wykresy

figure(fignum + 1), step(G_zam),     title(['OdpowiedŸ skokowa uk³adu zamknietego z regulatorem DB - z ograniczeniem sterowania Tp=' num2str(Tp)])
xlabel('Próbka');   ylabel('Wartosc odpowiedzi');

figure(fignum + 2), step(Gs),        title('Sygna³ steruj¹cy - z ograniczeniem sterowania')
xlabel('Próbka');   ylabel('Wartosc odpowiedzi');

% WNIOSKI:
%{
    Dla ró¿nych wartoœci okresu próbkowania ró¿ne by³y odpowiedzi obiektu dyskrenego na skok jednostkowy.
 Dla Tp=1 odpowiedz dyskrenta najlepiej odzorowywa³a odpowiedz obiektu ciag³ego. Natomiast dla okresu próbkowania
 Tp=3 pobieraj¹cego próbkê co 3 sekundy odzworowanie by³o najgorsze(najmniej zbli¿one do charakterystyki ci¹g³ej)

    Regulacja DB polega na sprowadzeniu wartoœci w³asnych uk³adu 
 do pocz¹tku uk³adu wspó³rzêdnych tzn. polega na takim doborze wzmocnieñ liniowego sprzê¿enia
 zwrotnego od stanu aby bieguny uk³adu zamknietego by³y równe 0,

  Jedynym parametrem mo¿liwym do zmiany jest czas próbkowania Tp, 

  Ze wglêdu na wartoœæ okresu próbkowania odpowiedŸ uk³adu na skok jednostkowy jest opóŸniona o wartoœæ okresu Tp,
 
        Im krótszy jest czas próbkowania tym wiêksze wartoœci sterowania bêd¹ dzia³a³y na obiekt. 
  Mo¿e siê okazaæ, ¿e wartoœci te wykraczaj¹ poza mo¿liwoœci urz¹dzeñ wykonawczych lub zasilaj¹cych. 
  Powoduje to zanik w³aœciwoœci regulatora DB polegaj¹cych na mo¿liwoœci 
  sprowadzenia obiektu w stan koñcowy w czasie nTp (gdzie n jest równy rêdowi obiektu), 
  jednak efektu tego nie zauwazymy w naszym przypadku poniewaz pracowalismy na matematycznym, 
  a nie rzeczywistym obiekcie.Aby temu zapobiec nale¿y zmniejszyæ okres próbkowania do wartoœci, 
  w której wartoœci sterowania bêd¹ mieœci³y siê w dopuszczalnym zakresie.  

    W zale¿noœci od wartoœci okresu próbkowania nastepuje minimalizacja
    uchybu w czasie trwania danego okresu próbkowania.

    Na wykresach widaæ, ¿e wartoœci sterowania bez ograniczenia amplitudy 
    trwaj¹ przez jeden okres próbkowania:
    - dla uk³adu Tp = 1s tr = 1s, sygna³ steruj¹cy = 10.5
    - dla uk³ady Tp = 2s tr = 2s, sygna³ steruj¹cy = 5.52
    - dla uk³adu Tp = 3s tr = 3s, sygna³ steruj¹cy = 3.86

    Dla sterowania z ograniczeniem amplitudy zarejestrowalismy czas
    regulacji wynoszacy 6s, czyli minimalizacja uchybu nast¹pi³a równie¿ w czasie równym 6s. 
    Czas regulacji dla obiektu bez regulatora wynosi 31s.

    W przypadku regulatora z ograniczeniem amplitudy watroœæ wyœciowa z uk³adu wzrasta 
    skokowo od wartosci 0 do 1,7 w dówóch okresach próbkowania.
    
    Dla uk³adu z ograniczeniem amplitudy sterowania nalezalo zastosowac prekompensator, 
    w innym przypadku w ukladzie wystepowal uchyb ustalony.
%}
