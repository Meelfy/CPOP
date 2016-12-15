function OISST_Preprocessing()
    % this funciton uses read_grib to read grb file. The read_grid is cloned
    % form https://github.com/BrianOBlanton/read_grib
    % Time span 19811101 - 20161116 weekly
    % Space span 30°S - 50°N, 30°E - 70°W

    % OISST
    % The sst, error and ice fields are on a 1-degree (360 lon by 180 lat) grid.
    % The first gridbox of each array is centered on 0.5E, 89.5S.  The points
    % move eastward to 359.5E, then northward to 89.5N. 

    % The unit of OISST is K
    
    clear all;
    clc;
    file_path = 'E:/Datasets/SST/OISST/daily/GRIB/';
    file_name = dir([file_path, '*.grb']);
    file_num  = size(file_name, 1);

    OISST = zeros(file_num, 20800);% 80 * 260


    for i = 1:file_num
        gribFileName = [file_path, file_name(i).name];
        grib_struct = read_grib(gribFileName, [1]);
        oneRow_SST = grib_struct(1).fltarray;

        % set 0.5E, 89.5N to (0, 0)
        grid_SST = reshape(oneRow_SST, grib_struct(1).gds.Ni,...
                                       grib_struct(1).gds.Nj);
        grid_SST = flipud(grid_SST');

        % x ~ 90 - 50(50°N) : 90 + 29(30°S)
        % y ~ 31(30°E)      : 180 + (180 - 70) (70°W)
        grid_SST = grid_SST(40:119, 31:290);
        OISST(i, :) = reshape(grid_SST, 1, 20800);
    end

    dlmwrite('data/OISST_19811101-20161116.dat', OISST, 'delimiter', ' ');


% clear all;
% clc;
% file_path = 'E:/Datasets/SST/OISST/daily/GRIB/';
% file_name = dir([file_path, '*.grb']);
% file_num  = size(file_name, 1);
% % 验证下载的数据是否缺少日期
% % % 截取时间段
% for i =1 :file_num
%     week(i,:) =  str2num(file_name(i).name(end-11:end-4));
% end
% % total_week 使用excel生成完整的时间
% % 取两者差集
% y = setdiff(total_week, week, 'rows');

% 19900103 is wrong

% gds=grib_struct(1).gds;
% lon=gds.Lo1:gds.Di:gds.Lo2+360;
% lat=gds.La1:-gds.Dj:gds.La2;
% ThisUgrd=reshape(grib_struct(1).fltarray,gds.Ni,gds.Nj)';
% pcolor(lon,lat,ThisUgrd)

% function OISST_Preprocessing()
%     % this funciton uses read_grib to read grb file. The read_grid is cloned
%     % form https://github.com/BrianOBlanton/read_grib
%     % Time span 19811101 - 20161116 weekly
%     clear all;
%     clc;
%     file_path = 'E:/Datasets/SST/OISST/daily/GRIB/';
%     file_name = dir([file_path, '*.grb']);
%     file_num  = size(file_name, 1);

%     OISST = zeros(file_num, 180*360);


%     for i = 1:file_num
%         gribFileName = [file_path, file_name(i).name];
%         grib_struct = read_grib(gribFileName, [1]);
%         oneRow_SST = grib_struct(1).fltarray;
%         OISST(i, :) = oneRow_SST;
%     end

%     dlmwrite('data/OISST_19811101-20161116.dat', OISST, 'delimiter', ' ');