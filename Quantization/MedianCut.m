function [color_pallete] = MedianCut(P, quan_value)
    A = P;
    %Reshaping image matrix to 2D matrix with number of pixelsXchannels.
    [unique_color_map, labels_start, labels] = unique(reshape(A, [], 3), 'rows', 'stable');
    [N,EDGES] = histcounts(labels,size(labels_start,1));

    % figure(1)
    % bar(N);
    [k_popular_freq, freq_index] = maxk(N,size(labels,1));
    k_color_map = unique_color_map(freq_index,:);
    k_color_map(:,4) = N(freq_index);

    Box_sets = {};
    [Box_initial] = CreateColorBox(k_color_map, 0);
    Box_sets{1} = Box_initial;
    p = 1;
    Done = 0;

    while (p < quan_value) && (Done == 0)
        [newBox, inx] = FindSplitBox(Box_sets);
        if (isempty(newBox) == 0)
            [Box1,Box2] = SplitBox(newBox);
            p = p + 1;
            Box_sets{inx} = Box1;
            Box_sets{end+1} = Box2;
        else
            Done = 1;
        end
    end

    %average the pixels in each box
    color_pallete = zeros(quan_value,3);
    for i = 1:length(Box_sets)
        color_pallete(i,1) = mean(Box_sets{i}{1}(:,1));
        color_pallete(i,2) = mean(Box_sets{i}{1}(:,2));
        color_pallete(i,3) = mean(Box_sets{i}{1}(:,3));
    end
end

