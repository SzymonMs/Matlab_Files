% data_generator.m
% Description: script for calculating PQ parameters (PN-EN 50160 - It would
% be nice :)).
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
agnles200msSamples = zeros(size(voltageSamples(:,1),2),6);
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
        agnles200msSamples(j,i) = rad2deg(angle(tempU(idx50U))-angle(firstPhaseFFT(idx50U)));
        agnles200msSamples(j,i+3) = rad2deg(angle(tempI(idx50I))-angle(firstPhaseFFT(idx50U)));
%         clear tempU tempI idx50U idx50I frequenceI frequenceU;
    end
end
%% Phase-to-phase voltage 200ms
% first - U12, second - U13, third - U23
phase2PhaseVoltage200msSamples = zeros(size(voltage200msSamples(:,1),1),3);
phase2PhaseVoltage200msSamples(:,1) = sqrt(voltage200msSamples(:,1).^2 + voltage200msSamples(:,2).^2 - 2*voltage200msSamples(:,1).*voltage200msSamples(:,2).*cosd(agnles200msSamples(:,2)-agnles200msSamples(:,1)));
phase2PhaseVoltage200msSamples(:,2) = sqrt(voltage200msSamples(:,1).^2 + voltage200msSamples(:,3).^2 - 2*voltage200msSamples(:,1).*voltage200msSamples(:,3).*cosd(agnles200msSamples(:,3)-agnles200msSamples(:,1)));
phase2PhaseVoltage200msSamples(:,3) = sqrt(voltage200msSamples(:,1).^2 + voltage200msSamples(:,3).^2 - 2*voltage200msSamples(:,2).*voltage200msSamples(:,3).*cosd(agnles200msSamples(:,3)-agnles200msSamples(:,2)));
%% Avtive Power and Total Active Power 200ms
activePower200msSamples = zeros(size(voltage200msSamples(:,1),1),4);
for i = 1:3
   activePower200msSamples(:,i) = voltage200msSamples(:,i).*current200msSamples(:,i).*cosd(agnles200msSamples(:,i)-agnles200msSamples(:,i+3));
end
activePower200msSamples(:,4) = activePower200msSamples(:,1)+activePower200msSamples(:,2)+activePower200msSamples(:,3);
%% Reactive Power and Total Reactive Power 200ms
reactivePower200msSamples = zeros(size(voltage200msSamples(:,1),1),4);
for i = 1:3
   reactivePower200msSamples(:,i) = voltage200msSamples(:,i).*current200msSamples(:,i).*sind(agnles200msSamples(:,i)-agnles200msSamples(:,i+3));
end
reactivePower200msSamples(:,4) = reactivePower200msSamples(:,1)+reactivePower200msSamples(:,2)+reactivePower200msSamples(:,3);
%% Apparent Power and Total Apparent Power 200ms
apparentPower200msSamples = zeros(size(voltage200msSamples(:,1),1),4);
for i = 1:3
   apparentPower200msSamples(:,i) = voltage200msSamples(:,i).*current200msSamples(:,i);
end
apparentPower200msSamples(:,4) = apparentPower200msSamples(:,1)+apparentPower200msSamples(:,2)+apparentPower200msSamples(:,3);
%% Frequency 200ms
Frequency200msSamples = zeros(size(voltageSamples(:,1),2),1);
    for j = 1:numberOfWindows200Cycle
        idxStart = (j-1)*samplesIn200ms+1;
        idxEnd = j*samplesIn200ms;
        tempU = fft(voltageSamples(idxStart:idxEnd,1));
        frequenceU = (0:size(tempU,1)-1) * (Ts*1000/size(tempU,1));
        [~, idx50U] = max(abs(tempU));
        Frequency200msSamples(j) = frequenceU(idx50U);
    end
    Frequency200msSamples = Frequency200msSamples'; 
%%  Voltage Harmonics 200ms
HU200msSamples = zeros(size(voltageSamples(:,1),2),150); % I assume that max order of voltage harmonics is 50th. We have 3-phase system. 50*3=150
    for i = 1:3
        for j = 1:50
            for k = 1:numberOfWindows200Cycle
                idxStart = (k-1)*samplesIn200ms+1;
                idxEnd = k*samplesIn200ms;
                tempU = fft(voltageSamples(idxStart:idxEnd,i));
                tempU=tempU/size(tempU,1);
                frequenceU = (0:size(tempU,1)-1) * (Ts*1000/size(tempU,1));
                [~,idxHU_jF]=min(abs(frequenceU-nominalFrequency*j));
                HU200msSamples(k,i*j) = abs(tempU(idxHU_jF))/nominalVoltagesRMS(1,i)*100;                
            end
        end
    end

%% Data Save to CSV Files
dirName = "PQ_data";
if ~exist(dirName, 'dir')
    mkdir(dirName);
end
writetable(table(cat(2,voltageRMSSamples,currentRMSSamples)),strcat(dirName,"/RMS.csv"));
writetable(table(cat(1,voltage200msSamples)),strcat(dirName,"/U_s.csv"));
writetable(table(cat(1,current200msSamples)),strcat(dirName,"/I_s.csv"));
writetable(table(cat(1,phase2PhaseVoltage200msSamples)),strcat(dirName,"/UU_s.csv"));
writetable(table(cat(1,activePower200msSamples)),strcat(dirName,"/P_s.csv"));
writetable(table(cat(1,reactivePower200msSamples)),strcat(dirName,"/Q_s.csv"));
writetable(table(cat(1,apparentPower200msSamples)),strcat(dirName,"/S_s.csv"));
writetable(table(cat(1,agnles200msSamples)),strcat(dirName,"/ANG_s.csv"));
writetable(table(cat(1,Frequency200msSamples)),strcat(dirName,"/F_s.csv"));
clear dirName
%% Clean workspace
clear i j idxEnd idxStart;