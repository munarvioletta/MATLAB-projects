% Przedmiot: Przetwarzanie sygnalow
% Temat: Kompresja obrazow za pomoca transformacji DCT i FFT
% Autorzy:
% Micha� Bokiniec
% Violetta Munar Ernandes

function [dctObraz, idctObraz, fftObraz, ifftObraz, kolory] = funkcjaDctFft(sciezka, jakosc) 
    [obraz, kolory] = imread(sciezka); % czytanie obrazu
    [rozmiarX, rozmiarY] = size(obraz); % odczytywanie wlasciwosci obrazu
    obraz = double(obraz); % zmiana z int na double

    % TRANSFORMATA DCT
    % obliczanie wymiarow zachowywanego prostokata
    k = sqrt(jakosc * rozmiarX*rozmiarX/100) % wspolczynnik kompresji = k*k/rozmiarX*rozmiarX
    g = zeros(rozmiarX, rozmiarX); % maska zer
    g(1:k,1:k) = ones(k,k); % wypelnianie czesci maski jedynkami

    % obliczanie dwuwymiarowej transformaty DCT
    dctObraz(:,:,1) = dct2(obraz(:,:,1)) .* g; % kana� czerwony, mnozenie przez maske
    dctObraz(:,:,2) = dct2(obraz(:,:,2)) .* g; % kana� zielony, mnozenie przez maske
    dctObraz(:,:,3) = dct2(obraz(:,:,3)) .* g; % kana� niebieski, mnozenie przez maske
    
    % obliczanie dwuwymiarowej odwrotnej transformaty DCT (rekonstrukcja)
    idctObraz(:,:,1) = idct2(dctObraz(:,:,1)); % kana� czerwony
    idctObraz(:,:,2) = idct2(dctObraz(:,:,2)); % kana� zielony
    idctObraz(:,:,3) = idct2(dctObraz(:,:,3)); % kana� niebieski
    

    % TRANSFORMATA FFT
    % obliczanie wymiarow zerowanego prostokata
    m = sqrt((rozmiarX*rozmiarX * (100-jakosc))/100) % wspolczynnik kompresji = (rozmiarX*rozmiarX-m*m)/(rozmiarX*rozmiarX)
    h = ones(rozmiarX, rozmiarX);  % maska jedynek
    h((rozmiarX-m)/2:(rozmiarX-m)/2+m-1, (rozmiarX-m)/2:(rozmiarX-m)/2+m-1) = zeros(m,m); % wypelnianie czesci maski zerami
    
    % obliczanie dwuwymiarowej transformaty FFT
    fftObraz(:,:,1) = fft2(obraz(:,:,1)) .* h; % kana� czerwony, mnozenie przez maske
    fftObraz(:,:,2) = fft2(obraz(:,:,2)) .* h; % kana� zielony, mnozenie przez maske
    fftObraz(:,:,3) = fft2(obraz(:,:,3)) .* h; % kana� niebieski, mnozenie przez maske

    % obliczanie dwuwymiarowej odwrotnej transformaty FFT (rekonstrukcja)
    ifftObraz(:,:,1) = ifft2(fftObraz(:,:,1)); % kana� czerwony
    ifftObraz(:,:,2) = ifft2(fftObraz(:,:,2)); % kana� zielony
    ifftObraz(:,:,3) = ifft2(fftObraz(:,:,3)); % kana� niebieski
end

