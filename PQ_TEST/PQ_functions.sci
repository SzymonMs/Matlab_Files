//%% Extra functions
/*
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
*/
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

function r = deg2rad(d)
    r = d * %pi / 180;
endfunction
