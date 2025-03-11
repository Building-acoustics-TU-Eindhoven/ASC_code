%% To calculate the total energy of the signal
function [Energy] = calculate_energy(IR)
energy=(sum((abs(IR)).^2)).^0.5;  % Pa
spl = @(input)(20 * log10(abs(input)))+120;% equation to calculate sound pressure level
Energy=spl(energy); % dB
end