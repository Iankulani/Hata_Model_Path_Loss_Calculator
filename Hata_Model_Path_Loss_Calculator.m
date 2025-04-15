% Hata Path Loss Model - Interactive Script with Plot
clc;
clear;

disp('--- Hata Model Path Loss Calculator ---');

% --- User Inputs ---
fc = input('Enter the carrier frequency (Hz):');
htx = input('Enter the transmitter height (m):');
hrx = input('Enter the receiver height (m):');
Etype = input('Enter the environment type (urban/suburban/open): ', 's');

% --- Frequency Conversion ---
fc_MHz = fc / 1e6;

% --- Distance Vector (from 100m to 10 km) ---
d = linspace(100, 10000, 1000); % in meters

% --- Calculate Receiver Antenna Correction Factor ---
if fc_MHz >= 150 && fc_MHz <= 200
    C_Rx = 8.29 * (log10(1.54 * hrx))^2 - 1.1;
elseif fc_MHz > 200
    C_Rx = 3.2 * (log10(11.75 * hrx))^2 - 4.97;
else
    C_Rx = 0.8 + (1.1 * log10(fc_MHz) - 0.7) * hrx - 1.56 * log10(fc_MHz);
end

% --- Calculate Path Loss for Each Distance ---
PL = 69.55 + 26.16 * log10(fc_MHz) - 13.82 * log10(htx) - C_Rx ...
     + (44.9 - 6.55 * log10(htx)) * log10(d / 1000);

% --- Environment Correction ---
Etype = upper(Etype);
if startsWith(Etype, 'S')  % Suburban
    PL = PL - 2 * (log10(fc_MHz / 28)).^2 - 5.4;
elseif startsWith(Etype, 'O')  % Open/Rural
    PL = PL + (18.33 - 4.78 * log10(fc_MHz)) * log10(fc_MHz) - 40.97;
end

% --- Plotting ---
figure;
plot(d / 1000, PL, 'b', 'LineWidth', 2);  % Convert distance to km
xlabel('Distance (km)');
ylabel('Path Loss (dB)');
title(['Hata Model Path Loss for ', lower(Etype), ' environment']);
grid on;
xlim([min(d)/1000, max(d)/1000]);

% --- Display final message ---
fprintf('\nPlot generated for path loss over distance (100 m to 10 km).\n');
