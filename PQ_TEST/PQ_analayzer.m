% data_generator.m
% Description: script for calculating PQ parameters (PN-EN 50160).
%
% Author: Szymon Murawski
% Created: 2025-07-18
% Version: 1.0
% License: MIT
%
% This script calculate power quality parameters using samples of voltage and current from data_generator.

clear all;
clc;

%% Generator parameters
Ts = 12.5; % [kSps] kilo samples per seconds
timeMax = 1; % [s]
nominalVoltagesRMS = [57.7 57.7 57.7]; % [V]
nominalCurrentsRMS = [1 1 1]; %[A]
nominalFrequency = 50; % [Hz]
%% Read samples
rawData = readtable('data.csv');
voltageSamples = table2array(rawData(:,1:3));
currentSamples = table2array(rawData(:,4:6));
%% RMS(1/2) values
samplesPerHalfCycle = Ts*1000/(2*nominalFrequency); % Saples in 1/2 Cycle;
numberOfWindows = floor(size(voltageSamples(:,1),1) / samplesPerHalfCycle);
voltageRMSSamples = zeros(numberOfWindows,3);
currentRMSSamples = zeros(numberOfWindows,3);
for i = 1:3
   for j = 1:numberOfWindows
      idxStart = (j-1)*samplesPerHalfCycle+1;
      idxEnd = j*samplesPerHalfCycle;
      voltageRMSSamples(j,i) = sqrt(mean(voltageSamples(idxStart:idxEnd,i).^2));
      currentRMSSamples(j,i) = sqrt(mean(currentSamples(idxStart:idxEnd,i).^2));
   end 
end
%% 200ms RMS values
numberOfWindows200Cycle = numberOfWindows / 20;
samplesIn200ms = 20 * samplesPerHalfCycle; % 200ms = 20*HalfCycle
voltage200msSamples = zeros(numberOfWindows200Cycle,3);
current200msSamples = zeros(numberOfWindows200Cycle,3);
for i = 1:3
   for j = 1:numberOfWindows200Cycle
      idxStart = (j-1)*samplesIn200ms+1;
      idxEnd = j*samplesIn200ms;
      voltage200msSamples(j,i) = sqrt(mean(voltageSamples(idxStart:idxEnd,i).^2));
      current200msSamples(j,i) = sqrt(mean(currentSamples(idxStart:idxEnd,i).^2));
   end 
end
%% Phase angles 200ms
AnglesSamples = zeros(size(voltageSamples(:,1),2),6);
for i = 1:3
    for j = 1:numberOfWindows200Cycle
        idxStart = (j-1)*samplesIn200ms+1;
        idxEnd = j*samplesIn200ms;
        firstPhaseFFT = fft(voltageSamples(idxStart:idxEnd,1));
        tempU = fft(voltageSamples(idxStart:idxEnd,i));
        tempI = fft(currentSamples(idxStart:idxEnd,i));
        frequenceU = (0:size(tempU,1)-1) * (Ts*1000/size(tempU,1));
        frequenceI = (0:size(tempI,1)-1) * (Ts*1000/size(tempI,1));
        [~, idx50U] = min(abs(frequenceU-nominalFrequency));
        [~, idx50I] = min(abs(frequenceI-nominalFrequency));
        AnglesSamples(j,i) = rad2deg(angle(tempU(idx50U))-angle(firstPhaseFFT(idx50U)));
        AnglesSamples(j,i+3) = rad2deg(angle(tempI(idx50I))-angle(firstPhaseFFT(idx50U)));
        clear tempU tempI idx50U idx50I frequenceI frequenceU;
    end
end
%% Phase-to-phase voltage 200ms
% first - U12, second - U13, third - U23
Phase2PhaseVoltageSamples = zeros(size(voltage200msSamples(:,1),1),3);
Phase2PhaseVoltageSamples(:,1) = sqrt(voltage200msSamples(:,1).^2 + voltage200msSamples(:,2).^2 - 2*voltage200msSamples(:,1).*voltage200msSamples(:,2).*cosd(AnglesSamples(:,2)-AnglesSamples(:,1)));
Phase2PhaseVoltageSamples(:,2) = sqrt(voltage200msSamples(:,1).^2 + voltage200msSamples(:,3).^2 - 2*voltage200msSamples(:,1).*voltage200msSamples(:,3).*cosd(AnglesSamples(:,3)-AnglesSamples(:,1)));
Phase2PhaseVoltageSamples(:,3) = sqrt(voltage200msSamples(:,1).^2 + voltage200msSamples(:,3).^2 - 2*voltage200msSamples(:,2).*voltage200msSamples(:,3).*cosd(AnglesSamples(:,3)-AnglesSamples(:,2)));
%% Avtive Power and Total Active Power 200ms
ActivePowersSamples = zeros(size(voltage200msSamples(:,1),1),4);
for i = 1:3
   ActivePowersSamples(:,i) = voltage200msSamples(:,i).*current200msSamples(:,i).*cosd(AnglesSamples(:,i)-AnglesSamples(:,i+3));
end
ActivePowersSamples(:,4) = ActivePowersSamples(:,1)+ActivePowersSamples(:,2)+ActivePowersSamples(:,3);
%% Reactive Power and Total Reactive Power 200ms
ReactivePowersSamples = zeros(size(voltage200msSamples(:,1),1),4);
for i = 1:3
   ReactivePowersSamples(:,i) = voltage200msSamples(:,i).*current200msSamples(:,i).*sind(AnglesSamples(:,i)-AnglesSamples(:,i+3));
end
ReactivePowersSamples(:,4) = ReactivePowersSamples(:,1)+ReactivePowersSamples(:,2)+ReactivePowersSamples(:,3);
%% Apparent Power and Total Apparent Power 200ms
ApparentPowersSamples = zeros(size(voltage200msSamples(:,1),1),4);
for i = 1:3
   ApparentPowersSamples(:,i) = voltage200msSamples(:,i).*current200msSamples(:,i);
end
ApparentPowersSamples(:,4) = ApparentPowersSamples(:,1)+ApparentPowersSamples(:,2)+ApparentPowersSamples(:,3);




%% Clean workspace
clear i j idxEnd idxStart;