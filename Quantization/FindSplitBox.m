function [Box, inx] = FindSplitBox(Box_set)
%FindSplitBox Summary of this function goes here
%   Detailed explanation goes here
    min_level = intmax;
    inx = 1;
    for i = 1:length(Box_set)
        if (size(Box_set{i}{1},1) >= 2)
            if (Box_set{i}{2} < min_level)
                Box = Box_set{i};
                min_level = Box_set{i}{2};
                inx = i;
            end
        end
    end
end

