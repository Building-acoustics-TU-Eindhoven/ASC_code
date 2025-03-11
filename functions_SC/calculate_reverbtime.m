%%  To calculate reverberation time
function [EDT,T20,T30,decayCurvefitted] = calculate_reverbtime(Method,order,nStart,thisIR, nSamplesSignal,tv)

% Equation to calculate sound pressure level
spl = @(input)(20 * log10(abs(input)))+120;
thisIR=reshape(thisIR,1,[]);

if  Method==0   % ISM
absorptionCoef=0.1118;
decayCurve= spl(((1 - absorptionCoef).^(order)).^0.5);
decayCurvefitted=decayCurve;

else if  Method==1  % unlinear 
nEnd= round((nSamplesSignal-1)/5*4);  
thisIR(1, nEnd:end)=0;
cumulative_sum_squares = sqrt(cumsum(thisIR(1, end:-1:1).^2));  % Compute cumulative sum of squares in reverse order
decayCurvePa = cumulative_sum_squares(end:-1:1);  % Reverse the cumulative sum and apply square root
decayCurveSPL = spl(decayCurvePa(1:nSamplesSignal));  % Keep only the required samples
IRmax=max(spl(thisIR));
decayCurve=decayCurveSPL-(decayCurveSPL(1)-IRmax); 
p = polyfit(tv(1:nEnd-1),decayCurve(1:nEnd-1),3);
decayCurvefitted=p(1)*(tv.^3)+p(2)*(tv.^2)+p(3)*(tv.^1)+p(4);

else if   Method==2  % linear
nEnd= round((nSamplesSignal-1)/30*29); 
thisIR(1, nEnd:end)=0;
cumulative_sum_squares = sqrt(cumsum(thisIR(1, end:-1:1).^2));  % Compute cumulative sum of squares in reverse order
decayCurvePa = cumulative_sum_squares(end:-1:1);  % Reverse the cumulative sum and apply square root
decayCurveSPL = spl(decayCurvePa(1:nSamplesSignal));  % Keep only the required samples
IRmax=max(spl(thisIR));
decayCurve=decayCurveSPL-(decayCurveSPL(1)-IRmax);   
p = polyfit(tv(1:nEnd-1),decayCurve(1:nEnd-1),1);
decayCurvefitted=p(1)*(tv.^1)+p(2);


else if  Method==3  % unlinear
nEnd= round((nSamplesSignal-1)/10*3);  
thisIR(1, nEnd:end)=0;
cumulative_sum_squares = sqrt(cumsum(thisIR(1, end:-1:1).^2));  % Compute cumulative sum of squares in reverse order
decayCurvePa = cumulative_sum_squares(end:-1:1);  % Reverse the cumulative sum and apply square root
decayCurveSPL = spl(decayCurvePa(1:nSamplesSignal));  % Keep only the required samples
IRmax=max(spl(thisIR));
decayCurve=decayCurveSPL-(decayCurveSPL(1)-IRmax); 
p = polyfit(tv(1:nEnd-1),decayCurve(1:nEnd-1),1);
decayCurvefitted=p(1)*(tv.^1)+p(2);
end
end
end
end
%% Early decay time
% To find the point with a decay of 10 dB from the start
decayLevel10=10;  
decayCurveLevel10=abs(decayCurve-(decayCurve(nStart)-decayLevel10));
% To find the index
nDecay10=find(decayCurveLevel10==min(decayCurveLevel10));
%  EDT
EDT=(tv(nDecay10)-tv(nStart))*(60/decayLevel10);
%%  Decay 5dB
% To find the point with a decay of 5 dB from the start
decayLevel5=5;  
decayCurveLevel5=abs(decayCurve-(decayCurve(nStart)-decayLevel5));
% To find the index
nDecay5=find(decayCurveLevel5==min(decayCurveLevel5));
%% T20
% To find the point with a decay of 20 dB from the 5 dB decay point 
decayLevel20=20;  
decayCurveLevel20=abs(decayCurve-(decayCurve(nDecay5)-decayLevel20));
% To find the index
nDecay20=find(decayCurveLevel20==min(decayCurveLevel20));
% T20
T20=(tv(nDecay20)-tv(nDecay5))*(60/decayLevel20);
%% T30
% To find the point with a decay of 30 dB from the 5 dB decay point 
decayLevel30=30;  
decayCurveLevel30=abs(decayCurve-(decayCurve(nDecay5)-decayLevel30));
% To find the index
nDecay30=find(decayCurveLevel30==min(decayCurveLevel30));
% T30
T30=(tv(nDecay30)-tv(nDecay5))*(60/decayLevel30);
end
