%%  To calculate reverberation time
function [EDT,T20,T30,decayCurvefitted] = calculate_reverbtime_ISM(measuredData,nEnd, thisIR, nSamplesSignal,tv)
% Equation to calculate sound pressure level
spl = @(input)(20 * log10(abs(input)))+120;
thisIR=reshape(thisIR,1,[]);
 
thisIR(1, nEnd:end)=0;
cumulative_sum_squares = sqrt(cumsum(thisIR(1, end:-1:1).^2));  % Compute cumulative sum of squares in reverse order
decayCurvePa = cumulative_sum_squares(end:-1:1);  % Reverse the cumulative sum and apply square root
decayCurveSPL = spl(decayCurvePa(1:nSamplesSignal));  % Keep only the required samples
IRmax=max(spl(thisIR));
decayCurve=decayCurveSPL-(decayCurveSPL(1)-IRmax);   

p = polyfit(tv(1:round(nEnd/10*7)-1),decayCurve(1:round(nEnd/10*7)-1),1);
decayCurvefitted=p(1)*(tv.^1)+p(2);


EDT=-60/p(1);
T20=-60/p(1);
T30=-60/p(1);
end
