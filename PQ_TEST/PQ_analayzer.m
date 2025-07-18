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
Ts = 0.25; % [kSps] kilo samples per seconds
timeMax = 1; % [s]
nominalVoltagesRMS = [57.7 57.7 57.7]; % [V]
nominalCurrentsRMS = [1 1 1]; %[A]
%% Read samples
rawData = readtable('data.csv');
voltageSamples = table2array(rawData(:,1:3));
currentSamples = table2array(rawData(:,4:6));

%% RMS(1/2) values
RMSUL1 = sqrt(mean(voltageSamples(:,1).^2));
RMSUL2 = sqrt(mean(voltageSamples(:,2).^2));
RMSUL3 = sqrt(mean(voltageSamples(:,3).^2));
RMSIL1 = sqrt(mean(currentSamples(:,1).^2));
RMSIL2 = sqrt(mean(currentSamples(:,2).^2));
RMSIL3 = sqrt(mean(currentSamples(:,3).^2));