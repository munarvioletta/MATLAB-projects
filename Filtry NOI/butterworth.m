%%%%%%% plik butterworth.m %%%%%%%
clc
clear all
 
fp= 24.6
Tp = 1/fp
 
z = tf('z', Tp);
 
G_butter = (1.75099E-05*z^0 +   5.25298E-05*z^-1    +   5.25298E-05*z^-2    +   1.75099E-05*z^-3) / (1*z^0  +   -2.894321211*z^-1   +  2.79415278*z^-2 +   -0.89969149*z^-3);
G_butter.Variable = 'z^-1'
 
 
figure(1)
subplot(2,2,1)
step(G_butter)
title('Odpowiedz na wyuszenie skokowe')
 
subplot(2,2,2)
impulse(G_butter)
title('Odpowiedz na wyuszenie impulsowe')
 
subplot(2,2,3)
bode(G_butter)
title('Charakterystyka Amplitudowo - fazowa')
 
subplot(2,2,4)
 
nyquist(G_butter)
title('Wykres Nyquista')
