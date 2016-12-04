function weekly_Precipitation_Preprocessing()
% This function deals with the raw data of precipitation
% Mainly to achieve a certain period of time within the data extraction
% Time span 19800101 - 20140228  / 12478 weeks
    clear all;
    clc;
    Prec_daily = dlmread('data/daily_Prec_19800101-20140228.dat');
    Prec_weekly = [];

    % OISST 的第一部分 1981-11-01 ~ 1989-12-31 共 427 weeks
    % 向前的 7 天的平均值为当周的平均值
    start_date = datenum('1981-11-01') - datenum('1980-01-01') + 1;
    end_date   = datenum('1989-12-31') - datenum('1980-01-01') + 1;

    for i = start_date:7:end_date
        Prec_weekly = [Prec_weekly; mean(Prec_daily(i - 6:i, :))];
    end

    % OISST 的第二部分 1990-01-03 ~ 2014-02-26 
    % 向前的 7 天的平均值为当周的平均值
    start_date = datenum('1990-01-03') - datenum('1980-01-01') + 1;
    end_date   = datenum('2014-02-26') - datenum('1980-01-01') + 1;

    for i = start_date:7:end_date
        Prec_weekly = [Prec_weekly; mean(Prec_daily(i - 6:i, :))];
    end  

    dlmwrite('data/weekly_Prec_19811101-19891231_19900103-20140226.dat', Prec_weekly, 'delimiter', ' ');