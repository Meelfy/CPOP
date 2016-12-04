function dalily_Precipitation_Preprocessing()
% This function deals with the raw data of precipitation
% Mainly to achieve a certain period of time within the data extraction
% Time span 19800101 - 20140228  / 12478 days
    clear all;clc;
    
    file_path = 'E:/Datasets/China_Precipitation/daily_SURF_CLI_CHN_PRE_MON_GRID_0.5-/';
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
    % 198112 - 20140228 All
    dlmwrite('data/daily_Prec_19800101-20140228_mask.dat', mask, 'delimiter', ' ');
    dlmwrite('data/daily_Prec_19800101-20140228.dat', PREC, 'delimiter', ' ');
end

% 验证下载的数据是否缺少日期
% % 截取时间段
% for i =1 :file_num
%     week(i,:) =  str2num(file_name(i).name(end-11:end-4));
% end
% % total_day 使用excel生成完整的时间
% % 取两者差集
% y = setdiff(total_day, day, 'rows');