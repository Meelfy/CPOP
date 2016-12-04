function Precipitation_Preprocessing()
% This function deals with the raw data of precipitation
% Mainly to achieve a certain period of time within the data extraction
% Time span 198112 - 201504
    clear all;
    clc;
    file_path = 'E:/Datasets/China_Precipitation/SURF_CLI_CHN_PRE_MON_GRID_0.5-/';
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

    % Remove -9999
    mask = (PREC(1,:)==-9999);
    for i = 2:file_num
        mask = mask| (PREC(i,:)==-9999);
    end
    mask = ~mask;
    PREC =  PREC(:,mask);

    % Write the precipitation without -9999
    % 198112 - 201504 All
    dlmwrite('data/Prec_198112-201504_mask.dat', mask, 'delimiter', ' ');
    dlmwrite('data/Prec_198112-201504.dat', PREC, 'delimiter', ' ');
end