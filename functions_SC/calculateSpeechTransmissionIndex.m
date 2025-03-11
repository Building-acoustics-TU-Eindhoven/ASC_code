%% Syntax
% # [STI] = calculateSpeechTransmissionIndex(ir, fs)
%% Description
% This is a code to calculate the speech transmission index from a room
% impulse as described in (Houtgast & Steeneken, 1985)
% response
% Input arguments:
% # variable name  comment
% Output arguments:
% # variable name   comment
%%  Examples
% Example
%% Related functions %Related functions
%%
function [STI_octavebands,STI] = calculateSpeechTransmissionIndex(ir, fs)
% nyquistFrequency = round(fs/2);



nthOctave = 1;
fMin = 250;
fMax = 2000;
order = 10;


if nthOctave == 1
    nthOctaveChar = '1 octave';
else
    nthOctaveChar = sprintf('1/%0.0f octave', nthOctave);
end

[filterBank] = octaveFilterBank(nthOctaveChar, fs, 'FilterOrder', order, 'FrequencyRange', [fMin-1, fMax+1],'OctaveRatioBase',2);
centerOct = getCenterFrequencies(filterBank);
nBands = length(centerOct);

% Filter full-band signal in 7 octave bands (125 Hz till 8000 Hz)
irFiltered = filterBank(ir);



nSamples=length(ir);
theseModulationIndeces=nan(nSamples,nBands);
% Compute modulation indices

for iBand = 1:1:nBands


    thisIr = irFiltered(:, iBand);

    % Square impulse response
    irSquared = thisIr.^2;
    % Integrate squared impulse response
    totalEnergy = sum(irSquared);

    % Compute the envelope spectrum
    tfSquared = fft(irSquared);

    % Normalize envelope spectrum
    tfSquaredNormalized = tfSquared / totalEnergy;

    % Compute modulation index (can also use the abs function instead of sqrt of realpart^2 + imagpart^2)
    modulationIndex = sqrt(real(tfSquaredNormalized).^2+imag(tfSquaredNormalized).^2);

    theseModulationIndeces(:, iBand) = modulationIndex;


end


modulationFrequencies = [0.631, 0.794, 1.000, 1.259, 1.585, 1.995, 2.512, 3.162, 3.981, 5.012, 6.310, 7.943, 10.000, 12.589];
nFrequencies = length(modulationFrequencies);

nSamples = size(theseModulationIndeces, 1);
df = fs / nSamples;
tv = (0:1:nSamples - 1) * df;

% Obtain indices for the modulation frequencies

indecesModulationFrequencies=nan(1,nFrequencies);

for iFrequency = 1:1:nFrequencies
    thisModulationFrequency = modulationFrequencies(iFrequency);
    % Find the closest value to the modulation frequency
    [~, index] = min(abs(tv-thisModulationFrequency));
    indecesModulationFrequencies(iFrequency) = index;
end

% Extract mValues using indeces
mValues = theseModulationIndeces(indecesModulationFrequencies,:);

% Calculate apparent signal to noise ratio
sn = 10 * log10(mValues./(1 - mValues));

% Cap the apparent signal to noise ratios at +- 15 dB
capLimit=15;
% Take the absolute value of the sn-values minus the capLimit to find the
% values which are exceeding the cap limit (>0)
lim = abs(sn) - capLimit;
check = sign(lim);
% find the noise ratios that exceed +- 15 dB
index = check > 0;

% find positive and negative sn values
posNeg = sign(sn);

% extract corresponding signs of the exceeded sn-values
posNeg2 = posNeg(index);

% multiply capLimit by 1 or -1 to use correct cap off value (positive or negative) 
sn(index) = capLimit * posNeg2;

nMValues = size(sn, 1);

snMean = sum(sn, 1) / nMValues;
% STI weights
octaveWeights = [0.14, 0.11, 0.12, 0.19]./(0.14+ 0.11+0.12+0.19);
%octaveWeights = [0.13, 0.14, 0.11, 0.12, 0.19];
% Apply STI weights
snMeanWeighted = snMean .* octaveWeights;
snOverallMean = sum(snMeanWeighted);
% Calculate STI
STI = (snOverallMean + 15) / 30;
STI_octavebands =(snMean+ 15) / 30;

 end