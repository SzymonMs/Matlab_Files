% data_generator.m
% Description: script for creating artificial data - voltage and current values in 3-phase system.
%
% Author: Szymon Murawski
% Created: 2025-07-16
% Version: 1.0
% License: MIT
%
% This script create samples of voltage and current and save to a CSV file.
%%
clear all;
clc;
%% Basic Energy parameters
nominalVoltages = [81.6708 81.6708 81.6708]; % [V]
nominalCurrents = [sqrt(2) sqrt(2) sqrt(2)]; %[A]
nominalFrequency = 50;
voltageAngles = [0 -120 120]; % [°]
currentAngles = [-45 -165 75]; % [°]
%% Time parameters
Ts = 12.5; % [kSps] kilo samples per seconds
timeMax = 10; % [s]

%% Mains Signaling Voltage
ifMSIG = 0;
frequencyOfMSIG = 10; % [kHz]
valueOfMSIG = [1 1 1]; % [%Un]
voltageAngleOfMSIG = [0 -120 120]; % [°]

%% Harmonics
ifVoltageHarmonics = 0; % 1 if Voltage Harmonics (HU) are use, 0 if not
ifCurrentHarmonics = 0; % 1 if Current Harmonics (HI) are use, 0 if not

voltageHarmonicsOrder = {[3 5];[3 5];[7 3]}; % [order of HU] {[HU_L1],[HU_L2],[HU_L3]}
currentHarmonicsOrder = {[3 5],[3 5],[3 5 7]}; % [order of HI] {[HI_L1],[HI_L2],[HI_L3]}

voltageHarmonicsValue = {[50 50];[5 5];[10 10]}; % [%Un] {[HU_L1],[HU_L2],[HU_L3]}
currentHarmonicsValue = {[3 5];[3 5];[7 9 3]}; % [%In] {[HI_L1],[HI_L2],[HI_L3]}

voltageHarmonicsAngle = {[0 0];[-1 -2];[1 1]}; % [°] {[HU_L1],[HU_L2],[HU_L3]}
currentHarmonicsAngle = {[3 5];[3 5];[7 9 3]}; % [°] {[HI_L1],[HI_L2],[HI_L3]}

HUParametersCorrect = CheckHarmonicsParameters("HU",voltageHarmonicsOrder,voltageHarmonicsValue,voltageHarmonicsAngle,ifVoltageHarmonics);
HIParametersCorrect = CheckHarmonicsParameters("HI",currentHarmonicsOrder,currentHarmonicsValue,currentHarmonicsAngle,ifCurrentHarmonics);

%% Interharmonics
% n-th IH = (n-0.5)*nominalFrequency
% for example 4th IHU = 3.5 * 50Hz = 175Hz
ifVoltageInterharmonics = 0; % 1 if Voltage Interharmonics (IHU) are use, 0 if not
ifCurrentInterharmonics = 0; % 1 if Current Interharmonics (IHI) are use, 0 if not

voltageInterharmonicsOrder = {[3 5];[3 5];[7 39]}; % [order of IHU] {[IHU_L1],[IHU_L2],[IHU_L3]}
currentInterharmonicsOrder = {[3 5],[3 5],[3 5 7]}; % [order of IHI] {[IHI_L1],[IHI_L2],[IHI_L3]}

voltageInterharmonicsValue = {[50 50];[5 5];[10 10]}; % [%Un] {[IHU_L1],[IHU_L2],[IHU_L3]}
currentInterharmonicsValue = {[3 5];[3 5];[7 9 3]}; % [%In] {[IHI_L1],[IHI_L2],[IHI_L3]}

voltageInterharmonicsAngle = {[0 0];[-1 -2];[1 1]}; % [°] {[IHU_L1],[IHU_L2],[IHU_L3]}
currentInterharmonicsAngle = {[3 5];[3 5];[7 9 3]}; % [°] {[IHI_L1],[IHI_L2],[IHI_L3]}

IHUParametersCorrect = CheckHarmonicsParameters("IHU",voltageInterharmonicsOrder,voltageInterharmonicsValue,voltageInterharmonicsAngle,ifVoltageInterharmonics);
IHIParametersCorrect = CheckHarmonicsParameters("IHI",currentInterharmonicsOrder,currentInterharmonicsValue,currentInterharmonicsAngle,ifCurrentInterharmonics);

%% Data calculation
time = 0:1/(Ts*1000):timeMax;
U = zeros(3,size(time,2));
I = zeros(3,size(time,2));
for i = 1:3
    % Phase Voltage and Current
    U(i,:) = nominalVoltages(i)*sin(2*pi*nominalFrequency.*time+deg2rad(voltageAngles(i)));
    I(i,:) = nominalCurrents(i)*sin(2*pi*nominalFrequency.*time+deg2rad(currentAngles(i)));
    
    % HU
    if HUParametersCorrect == 1
        for j = 1:size(voltageHarmonicsOrder{i},2)
            U(i,:) = U(i,:) + voltageHarmonicsValue{i}(j)/100*nominalVoltages(i)*sin(2*pi*voltageHarmonicsOrder{i}(j)*nominalFrequency.*time+deg2rad(voltageAngles(i))+deg2rad(voltageHarmonicsAngle{i}(j)));
        end
    end
    
    %HI
    if HIParametersCorrect == 1
        for j = 1:size(currentHarmonicsOrder{i},2)
            I(i,:) = I(i,:) + currentHarmonicsValue{i}(j)/100*nominalCurrents(i)*sin(2*pi*currentHarmonicsOrder{i}(j)*nominalFrequency.*time+deg2rad(currentAngles(i))+deg2rad(currentHarmonicsAngle{i}(j)));
        end
    end
    
    % IHU
    if IHUParametersCorrect == 1
        for j = 1:size(voltageInterharmonicsOrder{i},2)
            U(i,:) = U(i,:) + voltageInterharmonicsValue{i}(j)/100*nominalVoltages(i)*sin(2*pi*(voltageInterharmonicsOrder{i}(j)-0.5)*nominalFrequency.*time+deg2rad(voltageAngles(i))+deg2rad(voltageInterharmonicsAngle{i}(j)));
        end
    end
    
    %IHI
    if IHIParametersCorrect == 1
        for j = 1:size(currentInterharmonicsOrder{i},2)
            I(i,:) = I(i,:) + currentInterharmonicsValue{i}(j)/100*nominalCurrents(i)*sin(2*pi*(currentInterharmonicsOrder{i}(j)-0.5)*nominalFrequency.*time+currentAngles(i)+deg2rad(currentInterharmonicsAngle{i}(j)));
        end
    end
    if ifMSIG == 1
       U(i,:) = U(i,:) + nominalVoltages(i)*valueOfMSIG(i)/100*sin(2*pi*frequencyOfMSIG.*time+deg2rad(voltageAngleOfMSIG(i)));
    end
end

%% CSV FILE
writetable(table(cat(2,U',I')),"data.csv");

%% TESTS
% Y = fft(I(3,:));
% T = 1/25000;
% L = Ts*1000*timeMax;
% t = (0:L)*T;
% plot(Ts*1000/L*(0:L),abs(Y))
plot(time,U(1,:),time,U(2,:),time,U(3,:))


%% Extra functions

% Function : CheckHarmonicsParameters
% Inputs:
%   text                : a string represent voltage/current (inter)harmonic groupe
%   cellOfOrders        : a cell aray represent orders voltage/current (inter)harmonic
%   cellOfValue         : a cell array represent values of voltage/current (inter)harmonic
%   cellOfAngles        : a cell array represent angles of voltage/current (inter)harmonic
%   stateOfUsing        : 0 if voltage/current (inter)harmonics are not in
%                         use, 1 if voltage/current (inter)harmonic are in
%                         signal
% Output:
%   correctHarmonics    : 0 if sth is wrong or 1 if all is good
function correctHarmonics = CheckHarmonicsParameters(text,cellOfOrders,cellOfValue,cellOfAngles,stateOfUsing)
if stateOfUsing == 1
    correctHarmonics = 1;
    for i=1:3
        if (size(cellOfOrders{i},2) == size(cellOfValue{i},2)) && (size(cellOfOrders{i},2) == size(cellOfAngles{i},2))
        correctHarmonics = 1;
        else
        correctHarmonics = 0;
        fprintf('Error in %s definition. Check L%d\n',text,i);
        break;
        end
    end
else
    correctHarmonics = 0;
end
end