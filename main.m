clc; clear all; close all;
addpath(genpath(pwd));
zones_Prec = get_zones_Prec_weekly();
OISST = dlmread('data/OISST_19811101-20161116.dat');

% Intercept SST to make them time consistent
OISST = OISST(1:size(zones_Prec, 1), :);
% idx   hiddenLayerSize delay_weeks trainPerformance    valPerformance  testPerformance performance trainR  valR    testR   R   region1 region2 region3 region4 region5 region6 region7 region8 region9
% result = tdnn_train(X, Y, delay_times, hiddenLayerSize)
result = [];
for delay_times = 1:20
    result_one = tdnn_train(OISST, zones_Prec, 6, 30)
    result = [result; result_one];
end