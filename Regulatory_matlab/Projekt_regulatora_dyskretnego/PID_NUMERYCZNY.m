%   PROJEKTOWANIE UK�AD�W REGULACJI

%   Program do wyznaczania dyskretnego regulatora PID na podstawie zadanych
%   parametr�w

%   Wykonanie:
%   in�. Violetta Munar Ernandes
%   in�. Piotr Prusaczyk
%   in�. Maciej Dobrzynski

%   Grupa: A4A1S4
 
clc
clear all

%%%%DANE%%%%%%
Tp=0.004;
T0=0.05;
k0=4.5;
A1=0.951297;
A2 = 0.904966;
e=2.71828182846;
s=tf('s');
z=tf('z', Tp);
Go_c=(k0/(T0*s+1)) %transmitancja ci�g�a obiektu regulacji
pot = (-0.08);

%%%% Wyznaczenie wzmocnie� K11 i K12 dla czasu regulacji tr=60*Tp%%%%%

k11L =(1-A1)/(1-e^pot);
k11M = k0*((e^pot*Tp)/(1-e^pot));

k11=k11L/(k0*Tp+k11M)
disp(['Wspolczynnik regulatora R1 k1 wynosi = ' num2str(k11)])

k12=(((e^pot)*Tp)/(1-e^pot))*k11
disp(['Wspolczynnik regulatora R1 k2 wynosi = ' num2str(k12)])

%%%% 1. Wyznaczenie wzmocnien K21 i K22 dla czasu regulacji tr=30*Tp%%%%%

k21L =(1-A2)/(1-e^pot);
k21M = k0*((e^pot*Tp)/(1-e^pot));

k21=k21L/(k0*Tp+k21M)
disp(['Wspolczynnik k1 regulatora R2 wynosi = ' num2str(k21)])

k22=((e^pot*Tp)/(1-e^pot))*k21
disp(['Wspolczynnik k2 regulatora R2 wynosi = ' num2str(k22)])

% wsp�czynniki przekszta�conej postaci regulatora R1
a1 = k11*Tp+k12; 
b1 = - k12;
% wsp�czynniki przekszta�conej postaci regulatora R2
a2 = k21*Tp+k22;
b2 = - k22;
 
%%%%---Licznik i mianownik obiektu po dyskretyzacj ZOH wyznaczone analitycznie----%%%%%

GobL=(k0*(1-e^pot)); % licznik obiektu sterowania
GobM = z-(e^pot); % mianownik obiektu sterowania

disp('transmitancja zast�pcza otwartego ukladu sterowania GOT1 wyznaczona analitycznie')

Got1 = (k0*(1-e^pot)*(k11*Tp+k12))/(z-1)

disp('transmitancja dyskretna obiektu regulacji Go(z) wzynaczona numerycznie')
Go_d=c2d(Go_c,Tp,'zoh') 

disp('transmitancja obiektu sterowania Go(z)')
TrOb = GobL/GobM

GrL1=(a1*z+b1);  % licznik regulatora R1
GrM1=(z-1);      % mianownik regulatora R1

GrL2=(a2*z+b2);  % licznik regulatora R2
GrM2=(z-1);      % mianownik regulatora R2

%%%%%%%% 2. Wyznaczenie regulatora dla tr=60*Tp %%%%%%%
disp('transmitancja regulatora GR1')
GR1 = GrL1/GrM1

%%%%%%%% Wyznaczenie regulatora dla tr=30*Tp %%%%%%%
disp('transmitancja regulatora GR2')
GR2 = GrL2/GrM2

%%%%%%%% Transmitancja otwartego UR %%%%%%%

disp('Transmitancja dyskretnego uk�adu otwartego dla tr=60*Tp')
Got_z1 = GR1*TrOb

disp('Transmitancja dyskretnego uk�adu otwartego dla tr=30*Tp')
Got_z2 = GR2*TrOb

%%%%%%%% Transmitancja uk�adu zamknietego %%%%%%%

disp('Transmitancja uk�adu zamknietego dla tr=60*Tp ')
Gur_z1 = feedback(Got_z1,1,-1)

disp('Transmitancja uk�adu zamknietego dla tr=30*Tp')
Gur_z2 = feedback(Got_z2,1,-1)

%%%%%%MODEL STANOWY%%%%%%%%%
disp('model stanowy uk�adu regulacji dyskretnego-Gur_z1')
MOD_z1 = ss(Gur_z1) %model stanowy uk�adu regulacji
disp('model stanowy uk�adu regulacji dyskretnego-Gur_z2-numeryczny')
MOD_z2 = ss(Gur_z2)

%%%%%%BIEGUNY UKLADOW REGULACJI%%%%%%%%%
disp ('Bieguny uk�adu zamkni�tego dla tr=30*Tp');
P2=eig(Gur_z2)
 
disp ('Bieguny uk�adu zamkni�tego dla tr=60*Tp');
P1=eig(Gur_z1)


%%%%%%%%%%% WYKRESY %%%%%%%%%%%

%%%%%% ODPOWIEDZ SKOKOWA UR %%%%%%%%%

figure(1), step(Gur_z1,'r',Gur_z2,'g'),
%axis([0 120 0 1.1])
%axis([0 12/10 0 1.1])
title('Odpowiedz skokowa uk�adu regulacji');
oznacz = legend('Odpowiedz skokowa uk�adu regulacji dla tr=60*Tp','Odpowiedz skokowa uk�adu regulacji dla tr=30*Tp');
set(oznacz,'Location','SouthEast')
xlabel('Czas');
ylabel('Amplituda sygna�u');
grid;

%%%%%% ODPOWIEDZ IMPULSOWA UR %%%%%%%%%

figure(2), impulse(Gur_z1,'r',Gur_z2,'g'),
title('Odpowiedz impulsowa uk�adu regulacji');
oznacz2=legend('Odpowiedz impulsowa uk�adu regulacji dla tr=60*Tp','Odpowiedz impulsowa uk�adu regulacji dla tr=30*Tp');
set(oznacz2,'Location','NorthEast')
xlabel('Czas');
ylabel('Amplituda sygna�u');
grid;

%%%%%% Ch-ka Nyquista UR %%%%%%%%%

figure(3),nyquist(Gur_z1,'r',Gur_z2,'g'),
title('Charakterystyka Nyquista');
oznacz3 = legend('Charakterystyka Nyquista dla tr=60*Tp','Charakterystyka Nyquista dla tr=30*Tp');
set(oznacz3,'Location','NorthEast')
xlabel('Cz�� rzeczywista');
ylabel('Cz�� urojona');
grid off;

%%%%%% Ch-ka Bodego UR %%%%%%%%%
figure(4)
bode(Gur_z1,'r',Gur_z2,'g');
axis([0 120 -180 0])
title('Charakterystyka Bodego');
oznacz3 = legend('Charakterystyka Bodego dla tr=60*Tp','Charakterystyka Nyquista dla tr=30*Tp');
set(oznacz3,'Location','SouthWest')
grid off;
