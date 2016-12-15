function WIND_d2w_preprocess()
    clear all;
    clc;
    addpath(genpath(pwd));
    file_type = 'nc';
    file_path = 'E:/Datasets/WIND/WIND_daily';
    
    % 得到所有的nc文件
    file_name = findFileAll(file_path, file_type);
    
    % 只保留所有日数据
    for i = 1:length(file_name)
        if length(file_name) - i + 1 <= 0
            break
        end
        if length(file_name(end - i + 1).name) ~= 45
            % length(file_name(1).name) == 45
            % 说明这是一个日期的数据,而不是月份的数据
            % 清除这一数据
            file_name(end - i + 1) = [];
        end
    end

    % ************读取所有OISST的week******************%
    file_path_OISST = 'E:/Datasets/SST/OISST/daily/GRIB/';
    file_name_OISST = dir([file_path_OISST, '*.grb']);
    file_num_OISST  = size(file_name_OISST, 1);
    % 验证下载的数据是否缺少日期
    % % 截取时间段
    for i =1 :file_num_OISST
        week_OISST(i,:) =  str2num(file_name_OISST(i).name(end-11:end-4));
    end
    clear file_path_OISST file_name_OISST file_num_OISST;

    % 对每一周的前六天包括自己进行平均
    file_num = size(file_name, 1);
    for i =1 :file_num
        week_WIND(i,:) =  str2num(file_name(i).name(20:27));
    end
    % datenum('2016-05-30') - datenum('1987-08-01') + 1

    % ************ 检查缺失的日期 ************ %
    % 缺失的日期已经全部手动检查，原因为服务器上不存在
    % day_all = str2num(char([datetime(1987,08,01,'Format','yyyyMMdd'):...
    %                         datetime(2016,05,30,'Format','yyyyMMdd')]'));
    % y = setdiff(day_all, week_WIND, 'rows');

    % 将日期转化为datetime，因为datetime可以进行日期的变化
    % 比如7天中有6天存在
    % 对日期上的七天进行搜索，而不是double
    week_OISST = num2str(week_OISST);
    week_OISST = datetime(int32(str2num(week_OISST(:,1:4))),...
                          int32(str2num(week_OISST(:,5:6))),...
                          int32(str2num(week_OISST(:,7:8))),...
                          'Format','yyyyMMdd');

    week_WIND = num2str(week_WIND);
    week_WIND = datetime(int32(str2num(week_WIND(:,1:4))),...
                          int32(str2num(week_WIND(:,5:6))),...
                          int32(str2num(week_WIND(:,7:8))),...
                          'Format','yyyyMMdd');

    % 遍历所有的OISST日期
    % 前几天都算上
    tic
    % 获取风场的经纬度
    latitude = ncread([file_name(1).dir, file_name(1).name], 'latitude');
    longitude = ncread([file_name(1).dir, file_name(1).name], 'longitude');
    uwnd_all = [];
    vwnd_all = [];

    for i = 1:size(week_OISST, 1)
        % 对一周的日期进行遍历

        % 计算包含的日期的下标
        idx = (week_WIND == week_OISST(i));
        for j = 1:7
            idx = idx | (week_WIND == week_OISST(i) - j + 1);
        end
        idx = find(idx == 1);

        % 一共有几天， 一般为7
        batch_num = length(file_name(idx));
        
        uwnd_average = zeros(80, 260);
        vwnd_average = zeros(80, 260);

        for j = 1:batch_num
            uwnd = ncread([file_name(idx(j)).dir, file_name(idx(j)).name], 'uwnd');
            vwnd = ncread([file_name(idx(j)).dir, file_name(idx(j)).name], 'vwnd');       

            % 读入的风场有四个时间 00:00 06:00 12:00 18:00
            % 取平均
            uwnd = mean(uwnd, 3);
            vwnd = mean(vwnd, 3);

            % x ~ 90 - 50(50°N) : 90 + 29(30°S)
            % y ~ 31(30°E)      : 180 + (180 - 70) (70°W) 290°E
            uwnd = uwnd(longitude>30 & longitude <= 290, latitude > -30 & latitude <= 50);
            vwnd = vwnd(longitude>30 & longitude <= 290, latitude > -30 & latitude <= 50);
            
            %转置原矩阵使符合正常角度
            uwnd = uwnd';
            vwnd = vwnd';

            % 上下翻转矩阵，因为原矩阵上面为负的N坐标值
            uwnd = flipud(uwnd);
            vwnd = flipud(vwnd);

            %每 4*4方阵进行平均 0.25°*0.25° -> 1°*1°
            for m = 1:(size(uwnd,1)/4)
                for n = 1:(size(uwnd,2)/4)
                    uwnd(m,n) = mean(mean(uwnd((m-1)*4+1:m*4 , (n-1)*4+1:n*4)));
                    vwnd(m,n) = mean(mean(vwnd((m-1)*4+1:m*4 , (n-1)*4+1:n*4)));
                end
            end
            uwnd = uwnd(1:m,1:n);
            vwnd = vwnd(1:m,1:n);

            uwnd_average = uwnd_average + uwnd / batch_num;
            vwnd_average = vwnd_average + vwnd / batch_num;
        end

        uwnd_all = [uwnd_all; reshape(uwnd_average, 1, 80 * 260)];
        vwnd_all = [vwnd_all; reshape(vwnd_average, 1, 80 * 260)];


        disp(['Process ' num2str(i) ' / ' num2str(size(week_OISST, 1))]);
        toc
    end

    dlmwrite('data/uwnd_WIND_CCMP_merge_OISST_weekly.dat', uwnd_all, 'delimiter', ' ');
    dlmwrite('data/vwnd_WIND_CCMP_merge_OISST_weekly.dat', vwnd_all, 'delimiter', ' ');
