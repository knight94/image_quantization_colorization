function [color_pallete] = Popularity(P, quan_value)
    A = P;
    %Reshaping image matrix to 2D matrix with number of pixelsXchannels.
    [unique_color_map, labels_start, labels] = unique(reshape(A, [], 3), 'rows', 'stable');
    [N,EDGES] = histcounts(labels,size(labels_start,1));


    [k_popular_freq, freq_index] = maxk(N,quan_value);
    color_pallete = unique_color_map(freq_index,:);
end

