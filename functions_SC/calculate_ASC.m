%% To calculate equivalent scattering coefficients
function  [ASC] = calculate_ASC(fs,maxOrder,nOrder,nScenarios,nReceivers,nOctaveBands,nChoppedIR,nFrequency,IRfiltered)
% To chop signals using a rectangular window
choppedIRs=cat(4,reshape(IRfiltered(:,:,:,1:(maxOrder+1)*nChoppedIR),nScenarios,nReceivers,nOctaveBands,nChoppedIR,(maxOrder+1)),zeros(nScenarios,nReceivers,nOctaveBands,fs/10-nChoppedIR,maxOrder+1));
% Fourier Transform
choppedSTFs=fft(choppedIRs,[],4);% symmetric transfer function
choppedTFs=choppedSTFs(:,:,:,2:nFrequency,:);% single side transfer function
% Transfer function for empty room
Fx=choppedTFs(1,:,:,:,:,:);
% Transfer function for furnished room
Fy=choppedTFs(2,:,:,:,:,:);
% Power spectral densities
Sxx = (abs(Fx)).^2;
Syy = (abs(Fy)).^2;
% Cross power spectral densities
Sxy = Fx .* conj(Fy);
% To calculate coherence
SXX = abs(mean(Sxx, 2));
SYY = abs(mean(Syy, 2));
SXY = abs(mean(Sxy, 2));
coherenceCoefsAllFrequency = SXY./((SXX .* SYY).^0.5);
% Frequency averaged
coherenceCoefs=reshape(mean(coherenceCoefsAllFrequency,4),nOctaveBands,(maxOrder+1));
%% To extract average scattering coefficients (ASCs)
for iOctaveBand=1:nOctaveBands
for iScatteringCoef=1:1000
    % Estimated ESCs from 0 to 1
    thisScatteringCoef=0.001*iScatteringCoef; 
    % Calculated coherence curve using the estimated ASCs
    thiscoherenceCurve=[((1 -thisScatteringCoef).^(nOrder(1:maxOrder+1))).^0.5];
    % Calculate the difference between real and estimated coherence curves
    deltaCoherenceCurve(iScatteringCoef,:)=sum(abs(thiscoherenceCurve-coherenceCoefs(iOctaveBand,:)).^2);
end
% Find the best fitted value of ASC
ASC(iOctaveBand)=0.001*(find(deltaCoherenceCurve==min(deltaCoherenceCurve))); % to analyze the effects of ESCs, ESCs can be adjusted by: ESC(iOctaveBand)=0.9;
end
end