function OISST_Preprocessing()
    % this funciton uses read_grib to read grb file. The read_grid is cloned
    % form https://github.com/BrianOBlanton/read_grib
    % Time span 19811101 - 20161116 weekly
    clear all;
    clc;
    file_path = 'E:\Datasets\SST\OISST\daily\GRIB\';
    file_name = dir([file_path, '*.grb']);
    file_num  = size(file_name, 1);

    OISST = zeros(file_num, 180*360);


    for i = 1:file_num
        gribFileName = [file_path, file_name(i).name];
        grib_struct = read_grib(gribFileName, [1]);
        oneRow_SST = grib_struct(1).fltarray;
        OISST(i, :) = oneRow_SST;
    end

    dlmwrite('data\OISST_19811101-20161116.dat', OISST, 'delimiter', ' ');


% gds=grib_struct(1).gds;
% lon=gds.Lo1:gds.Di:gds.Lo2+360;
% lat=gds.La1:-gds.Dj:gds.La2;
% ThisUgrd=reshape(grib_struct(1).fltarray,gds.Ni,gds.Nj)';
% pcolor(lon,lat,ThisUgrd)

% 截取时间段
for i =1 :1965
    day(i,:) =  str2num(file_name(i).name(end-11:end-4));
end
% total_day 使用excel生成完整的时间
% 去两者差集
y = setdiff(total_day, day, 'rows');