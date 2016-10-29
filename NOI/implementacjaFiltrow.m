%%%%%% plik implementacjaFiltrow.m %%%%%%
clc
clear all
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% DANE DO SYMULACJI %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
Tk = 20 %s - czas końcowy symulacji
fp = 24.6 %Hz - częstotliwość próbkowania filtru cyfrowego
Tp = 1/fp %s - okres próbkowania filtru cyfrowego
N = Tk/Tp + 3 % ilość próbek jako iloraz czasu symulacji i czasu próbkowania
 
% warunki początkowe
T = [-3*Tp:Tp:Tk];
 
Y_butt_skok(1) = 0; % przypisywanie warunkow poczatkowych odpowiedzi (w czasie ujemnym)
Y_butt_skok(2) = 0;
Y_butt_skok(3) = 0;
Y_butt_skok(4) = 0;
 
Y_butt_imp     = Y_butt_skok; % przypisywanie tych samych warunkow poczatkowych do wektorow wartosci odpowiedzi na inne wymuszenia
Y_butt_syg1    = Y_butt_skok;
Y_butt_syg2    = Y_butt_skok;
Y_czeby_skok   = Y_butt_skok;
Y_czeby_imp    = Y_butt_skok;
Y_czeby_syg1   = Y_butt_skok;
Y_czeby_syg2   = Y_butt_skok;
 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% OBLICZANIE ODPOWIEDZI FILTROW %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
% buterworth
 
% butterworth - odpowiedz skokowa
X = [1 0 0 0]; % wymuszenie jednostkowe przez cały czas trwania (poczatkowe próbki objęte wektorem X to [0 -1Tp -2Tp -3Tp])
for n = 4:N
	Y_butt_skok(n) =  1.75099E-05*X(1) + 5.25298E-05*X(2) + 5.25298E-05*X(3) + 1.75099E-05*X(4) - ( -2.894321211*Y_butt_skok(n-1) +2.79415278*Y_butt_skok(n-2) - 0.89969149*Y_butt_skok(n-3));
	X(2:4) = X(1:3); X(1) = 1; % przesuniecie probek
end
 
% butterworth - odpowiedz impulsowa
X = [1/Tp 0 0 0]; %warunki poczatkowe wymuszenia impulsowego (poczatkowe próbki objęte wektorem X to [0 -1Tp -2Tp -3Tp])
for n = 4:N
	Y_butt_imp(n) =  1.75099E-05*X(1) + 5.25298E-05*X(2) + 5.25298E-05*X(3) + 1.75099E-05*X(4) - ( -2.894321211*Y_butt_imp(n-1) +2.79415278*Y_butt_imp(n-2) - 0.89969149*Y_butt_imp(n-3) );
	X(2:4) = X(1:3); X(1) = 0; % przesuniecie probek
end
 
% butterworth - odpowiedz na sygnal testowy - sinus + szum
Asygnalu = 10; fsygnalu = 0.1; Aszumu = 3;
Xsb1 = [0 0 0 0];
for n = 4:N
	Xsb1(n) = Asygnalu * sin(n*Tp*2*pi()*fsygnalu) + Aszumu*randn;
end
for n = 4:N
	Y_butt_syg1(n) =  1.75099E-05*Xsb1(n) + 5.25298E-05*Xsb1(n-1) + 5.25298E-05*Xsb1(n-2) + 1.75099E-05*Xsb1(n-3) - (-2.894321211*Y_butt_syg1(n-1) + 2.79415278*Y_butt_syg1(n-2) - 0.89969149*Y_butt_syg1(n-3) );
	X(2:4) = X(1:3); X(1) = 0; % przesuniecie probek
end
 
% butterworth - odpowiedz na sygnal testowy - tylko szum
Asygnalu = 0; fsygnalu = 0.1; Aszumu = 3;
Xsb2 = [0 0 0 0];
for n = 4:N
	Xsb2(n) = Asygnalu * sin(n*Tp*2*pi()*fsygnalu) + Aszumu*randn;
end
for n = 4:N
	Y_butt_syg2(n) =  1.75099E-05*Xsb2(n) + 5.25298E-05*Xsb2(n-1) + 5.25298E-05*Xsb2(n-2) + 1.75099E-05*Xsb2(n-3) - (-2.894321211*Y_butt_syg2(n-1) + 2.79415278*Y_butt_syg2(n-2) - 0.89969149*Y_butt_syg2(n-3) );
	X(2:4) = X(1:3); X(1) = 0; % przesuniecie probek
end
 
% czebyszew
 
% czebyszew - odpowiedz skokowa
X = [1 0 0 0]; % wymuszenie jednostkowe przez cały czas trwania (poczatkowe próbki objęte wektorem X to [0 -1Tp -2Tp -3Tp])
for n = 4:N
	Y_czeby_skok(n) = 0.004334555*X(1) - 0.004318446*X(2) - 0.004318446*X(3) + 0.004334555*X(4) - ( -2.938193762*Y_czeby_skok(n-1) +2.878256774*Y_czeby_skok(n-2) - 0.940030795*Y_czeby_skok(n-3));
	X(2:4) = X(1:3); X(1) = 1; % przesuniecie probek
end
 
% czebyszew - odpowiedz impulsowa
X = [1/Tp 0 0 0]; %warunki poczatkowe wymuszenia impulsowego (poczatkowe próbki objęte wektorem X to [0 -1Tp -2Tp -3Tp])
for n = 4:N
	Y_czeby_imp(n) = 0.004334555*X(1) - 0.004318446*X(2) - 0.004318446*X(3) + 0.004334555*X(4) - ( -2.938193762*Y_czeby_imp(n-1) +2.878256774*Y_czeby_imp(n-2) - 0.940030795*Y_czeby_imp(n-3));
	X(2:4) = X(1:3); X(1) = 0; % przesuniecie probek
end
 
% czebyszew - odpowiedz na sygnal testowy - sinus + szum
Asygnalu = 10; fsygnalu = 0.1; Aszumu = 3;
Xsc1 = [0 0 0 0];
for n = 4:N
	Xsc1(n) = Asygnalu * sin(n*Tp*2*pi()*fsygnalu) + Aszumu*randn;
end
for n = 4:N
	Y_czeby_syg1(n) = 0.004334555*Xsc1(n) - 0.004318446*Xsc1(n-1) - 0.004318446*Xsc1(n-2) + 0.004334555*Xsc1(n-3) - (-2.938193762*Y_czeby_syg1(n-1) + 2.878256774*Y_czeby_syg1(n-2) - 0.940030795*Y_czeby_syg1(n-3));
	X(2:4) = X(1:3); X(1) = 0; % przesuniecie probek
end
 
% czebyszew - odpowiedz na sygnal testowy - tylko szum
Asygnalu = 0; fsygnalu = 0.1; Aszumu = 3;
Xsc2 = [0 0 0 0];
for n = 4:N
	Xsc2(n) = Asygnalu * sin(n*Tp*2*pi()*fsygnalu) + Aszumu*randn;
end
for n = 4:N
	Y_czeby_syg2(n) = 0.004334555*Xsc2(n) - 0.004318446*Xsc2(n-1) - 0.004318446*Xsc2(n-2) + 0.004334555*Xsc2(n-3) - (-2.938193762*Y_czeby_syg2(n-1) + 2.878256774*Y_czeby_syg2(n-2) - 0.940030795*Y_czeby_syg2(n-3));
	X(2:4) = X(1:3); X(1) = 0; % przesuniecie probek
end
 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% WYSWIETLANIE WYKRESÓW %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
% przygotowywanie wektorów próbek do wyświetlenia
 
% odcinanie próbek z czasu ujemnego
Y_butt_skok  = Y_butt_skok(4:N-1);
Y_butt_imp   = Y_butt_imp(4:N-1);
Y_butt_syg1  = Y_butt_syg1(4:N-1);
Xsb1          = Xsb1(4:N-1);
Y_butt_syg2   = Y_butt_syg2(4:N-1);
Xsb2          = Xsb2(4:N-1);
 
Y_czeby_skok  = Y_czeby_skok(4:N-1);
Y_czeby_imp   = Y_czeby_imp(4:N-1);
Y_czeby_syg1  = Y_czeby_syg1(4:N-1);
Xsc1          = Xsc1(4:N-1);
Y_czeby_syg2  = Y_czeby_syg2(4:N-1);
Xsc2          = Xsc2(4:N-1);
 
 
T = T(4:N-1); % odcinanie czasu ujemnego
 
% wykresy
 
subplot(2,4,1)
plot(T, Y_butt_skok); title('Odpowiedź skokowa filtru Butterwortha');   xlabel('czas [s]');
subplot(2,4,2)
plot(T, Y_butt_imp);  title('Odpowiedź impulsowa filtru Butterwortha'); xlabel('czas [s]');
subplot(2,4,3)
plot(T, Y_butt_syg1, T, Xsb1); title('Odpowiedź filtru Butterwortha na sygnał sinusoidalny z szumem'); xlabel('czas [s]');
subplot(2,4,4)
plot(T, Y_butt_syg2, T, Xsb2); title('Odpowiedź filtru Butterwortha na szum'); xlabel('czas [s]');
 
subplot(2,4,5)
plot(T, Y_czeby_skok); title('Odpowiedź skokowa filtru Czebyszewa');   xlabel('czas [s]');
subplot(2,4,6)
plot(T, Y_czeby_imp); title('Odpowiedź impulsowa filtru Czebyszewa'); xlabel('czas [s]');
subplot(2,4,7)
plot(T, Y_czeby_syg1, T, Xsc1); title('Odpowiedź filtru Czebyszewa na sygnał sinusoidalny z szumem'); xlabel('czas [s]');
subplot(2,4,8)
plot(T, Y_czeby_syg2, T, Xsc2); title('Odpowiedź filtru Czebyszewa na szum'); xlabel('czas [s]');
