%%%%%%% plik czebyszew.m %%%%%%%
clc
clear all

fp= 24.6
Tp = 1/fp

z = tf('z', Tp);

G_czeby = (0.004334555*z^0 - 0.004318446*z^-1 - 0.004318446*z^-2 + 0.004334555*z^-3) / (1*z^0 - 2.938193762*z^-1 + 2.878256774*z^-2 -0.940030795*z^-3);
G_czeby.Variable = 'z^-1'

figure(1)

subplot(2,2,1)
step(G_czeby)
title('Odpowiedz na wymuszenie skokowe')

subplot(2,2,2)
impulse(G_czeby)
title('Odpowiedz na wymuszenie impulsowe')

subplot(2,2,3)
bode(G_czeby)
title('Charakterystyka Amplitudowo - fazowa')

subplot(2,2,4)
nyquist(G_czeby)
title('Wykres Nyquista')