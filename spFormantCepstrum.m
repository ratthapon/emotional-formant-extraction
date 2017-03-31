function [formant] = spFormantCepstrum(c, fs)
   % search for maximum  between 2ms (=500Hz) and 20ms (=50Hz)
   %low time liftering
    x3 = c(1:length(c)/2); %as the cepstrum is symmetric, half the cepstral coef are used
    L = zeros(1, length(x3)); %defining liftering window
    L(1:15) = 1; %liftering window
    x5 = real(x3*L); %low time lifted cepstrum
    x6 = x5(1:15); %taking the non-zero cepstral coef from the low-time lifted cepstral sequence

    %8000 point FFT is taken to find the log magnitude spectrum to low-time lifted cepstral coef
    f6 = fft(x6, 8000);
    f6 = f6(1:4000); %as the FFT is symmetrical, half the number of FFT points are taken
    f6 = real(f6); % making sure that all the values obtained in the previous step are real

    %peak picking
    formant = [];
    k = 1;
    for i = 2: length(f6)-1
        if (f6(i-1)<f6(i)) && (f6(i+1)<f6(i))
            formant_mag(k) = f6(i);
            formant(k) = i;
            k = k+1;
        else
            continue;
        end
    end
end