%% To filter signal
function [IRfiltered] = calculate_filteredSignal(IRwithoutFilter,TFFilter,nSamplesSignal)
% Fourier Transform
signalSTFs=fft(IRwithoutFilter)/nSamplesSignal;
% Symmetric spectrums of filter
filterSTFs = [TFFilter; conj(TFFilter(end:-1:2))];
% To filter the signal
filteredSignalSTFs=signalSTFs.*filterSTFs;
% Inverse Fourier Transform
IRfiltered=ifft(filteredSignalSTFs)*nSamplesSignal;
end


