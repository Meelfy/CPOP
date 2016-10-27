function SST_matrix = SST_vec_to_matrix(SST_vec)
% use contourf(flipud(SST_matrix)); to observe from the point of view
    row_num = 101;
    col_num = 191;
    SST_vec = SST_vec';
    mask = dlmread('data/SST_198112-201509_mask.dat');
    j = 1;
    for i = 1:size(mask, 2)
        if mask(i) == 0
            mask(i) = nan;
        else
            mask(i) = SST_vec(j);
            j = j + 1;
        end
    end
    SST_matrix = reshape(mask, row_num, col_num);
end