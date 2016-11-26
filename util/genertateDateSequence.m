function dateSequence = genertateDateSequence(start_date, end_date)
% Generate a daily time series
    t0 = datenum(start_date);
    dt = 1;
    tf = datenum(end_date);
    T=t0:dt:tf;
    dv = datevec(T);
    C = mat2cell(dv(1:end, 1:3),ones(length(T),1), 3);
    S = cellfun(@(t) {sprintf('%4i%02i%02i',t)} , C);
    dateSequence = str2num(cell2mat(S));
end