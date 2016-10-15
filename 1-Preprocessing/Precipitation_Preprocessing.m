% This function deals with the raw data of precipitation
% Mainly to achieve a certain period of time within the data extraction
% Time span 198112 - 201504
function Precipitation_Preprocessing()
    clear all;
    clc;
    file_path = 'E:\Datasets\China_Precipitation\SURF_CLI_CHN_PRE_MON_GRID_0.5-\';
    file_name = dir([file_path, '*.txt']);
    file_num = size(file_name, 1);
    for i = 1:file_num
        raw_prec{i} = dlmread([file_path,file_name(i).name], '', 6, 0);
    end

    pixel_num = prod(size(raw_prec{1}));
    PREC = zeros(file_num, pixel_num);
    for i = 1:file_num
        PREC(i,:) = reshape(raw_prec{i}, 1, pixel_num);
    end

    % Write the precipitation with -9999
    % 198112 - 201504 All
    dlmwrite('data\Prec_198112-201504.dat', PREC, 'delimiter', ' ');
end