% Przedmiot: Przetwarzanie sygnalow
% Temat: Kompresja obrazow za pomoca transformacji DCT i FFT
% Autorzy:
% Micha³ Bokiniec
% Violetta Munar Ernandes

clc; clear all; % czyszczenie pozostalosci po poprzednich czynnosciach


sciezka = 'png/birds_c.png'; % definiowanie nazwy pliku
obrazek = figure; % zapisywanie wykresu pod zmienna, aby moc go zapisac do pliku
for jakosc = [50, 10, 2] % dla roznych wartosci jakosci
    [dctObraz, idctObraz, fftObraz, ifftObraz, kolory] = funkcjaDctFft(sciezka, jakosc); % wywolanie funkcji liczacej DCT i FFT
    for i = 1:3 % dla trzech skladowych koloru
        imshow(dctObraz(:,:,i)) % pokaz kanal koloru i obrazu
        saveas(obrazek, sprintf('wyniki/wynik_birds_dct_%i_%i.jpg', jakosc, i)) % zapisz obraz

        imshow(idctObraz(:,:,i), kolory); % pokaz kanal koloru i obrazu
        saveas(obrazek, sprintf('wyniki/wynik_birds_dct_inv_%i_%i.jpg', jakosc, i)) % zapisz obraz

        imshow(fftObraz(:,:,i)) % pokaz kanal koloru i obrazu
        saveas(obrazek, sprintf('wyniki/wynik_birds_fft_%i_%i.jpg', jakosc, i)) % zapisz obraz

        imshow(ifftObraz(:,:,i), kolory); % pokaz kanal koloru i obrazu
        saveas(obrazek, sprintf('wyniki/wynik_birds_fft_inv_%i_%i.jpg', jakosc, i)) % zapisz obraz
    end
end


sciezka = 'png/testchart-iso-12233.png'; % definiowanie nazwy pliku
for jakosc = [50, 10, 2] % dla roznych wartosci jakosci
    [dctObraz, idctObraz, fftObraz, ifftObraz, kolory] = funkcjaDctFft(sciezka, jakosc); % wywolanie funkcji liczacej DCT i FFT
    imshow(dctObraz(:,:,2)) % pokaz kanal koloru i obrazu
    saveas(obrazek, sprintf('wyniki/wynik_chart_dct_%i.jpg', jakosc)) % zapisz obraz

    imshow(idctObraz(:,:,2), kolory); % pokaz kanal koloru i obrazu
    saveas(obrazek, sprintf('wyniki/wynik_chart_dct_inv_%i.jpg', jakosc)) % zapisz obraz

    imshow(fftObraz(:,:,2)) % pokaz kanal koloru i obrazu
    saveas(obrazek, sprintf('wyniki/wynik_chart_fft_%i.jpg', jakosc)) % zapisz obraz

    imshow(ifftObraz(:,:,2), kolory); % pokaz kanal koloru i obrazu
    saveas(obrazek, sprintf('wyniki/wynik_chart_fft_inv_%i.jpg', jakosc)) % zapisz obraz
end
