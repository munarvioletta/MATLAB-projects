clc
clear all
format short
%%%%DANE%%%%%%
Kp=0.55;
Ki=1;
Kd=0.02;
Tf=0.15;
Ts=0.015;
ko=1.6667;
T1=0.2;
T2=0.5;

z=tf('z',Ts);
s=tf('s');

%%%%%REGULATOR WYZNACZONY NUMERYCZNIE%%%%%%%%%%%
disp('transmitancja regulatora wyznaczona numerycznie')

Ms= pid(Kp,Ki,Kd,Tf);
M = pid(Kp,Ki,Kd,Tf,Ts)
reg_z=tf(M)

%%%%%REGULATOR WYZNACZONY ANALITYCZNIE %%%%%%%%%%%
disp('transmitancja regulatora wyznaczona analitycznie')

Gregz= (0.686212121212121*z^2 - 1.30606060606061*z + 0.621212121212121) ...
     / (z^2 - 1.90909090909091*z + 0.909090909090909);
Gregs=(0.1025*s^2+0.7*s+1)/(0.15*s^2+s);

%%%%%%%%OBIEKT REGULACJI%%%%%%%%%
disp('transmitancja obiektu regulacji wyznaczona analitycznie')

Gob_s=ko/((T1*s+1)*(T2*s+1)) %ciag³y
Gob=(0.001811*z+0.001748)/(z^2-1.898*z+0.9003)

%%%%%%%UK£AD REGULACJI WYZNACZONY ANALITYCZNIE%%%%%%
disp('transmitancja uk³adu regulacji liczona analitycznie')

GUL=(1.24254141309656e-3*z^3 -1.16511153529754e-3*z^2  -1.15873245574877e-3*z + 1.08615599320765e-3);
GUM=(z^4-3.80603738755488*z^3 +  5.43206572172536*z^2  -3.44558647546322*z + 0.819562994707995);
Gur_za=GUL/GUM

%%%%%%%UK£AD REGULACJI WYZNACZONY NUMERYCZNIE%%%%%%
disp('Transmitancja UR wyznaczona numerycznie')

Gur_z = feedback(M*Gob,1,-1)


%%%%%%%%%%% WYKRESY  %%%%%%%%%%%
figure(1)
subplot(1,2,1);
step(M,0:Ts:1);  title('regulator numeryczny dyskretny')
subplot(1,2,2);
step(Gregz,0:Ts:1);     title('regulator analityczny dyskretny');

figure(2)
subplot(1,2,1);
step(Gur_za);    title('OdpowiedŸ skokowa zamkniêtego uk³adu regulacji liczonego analitycznie')
subplot(1,2,2);
step(Gur_z);     title('OdpowiedŸ skokowa zamkniêtego uk³adu regulacji liczonego numerycznie')

figure(3)
subplot(1,2,1);
impulse(Gur_za); title('OdpowiedŸ impulsowa zamkniêtego uk³adu regulacji liczonego analitycznie')
subplot(1,2,2);
impulse(Gur_z);  title('OdpowiedŸ impulsowa zamkniêtego uk³adu regulacji liczonego numerycznie')

figure(4)
subplot(1,2,1);
bode(Gur_za);    title('Charakterystyki Bodego zamkniêtego uk³adu regulacji liczonego analitycznie')
subplot(1,2,2);
bode(Gur_z);     title('Charakterystyki Bodego zamkniêtego uk³adu regulacji liczonego numerycznie')

figure(5)
subplot(1,2,1);
nyquist(Gur_za); title('Charakterystyka Nyquista zamkniêtego uk³adu regulacji liczonego analitycznie')
subplot(1,2,2);
nyquist(Gur_z);  title('Charakterystyka Nyquista zamkniêtego uk³adu regulacji liczonego numerycznie')



%%%%%%MODEL STANOWY%%%%%%%%%
disp('model stanowy uk³adu regulacji dyskretnego-Gur_z-numeryczny')
MOD_z=ss(Gur_z)

disp('pierwiastki')
P=eig(Gur_z)