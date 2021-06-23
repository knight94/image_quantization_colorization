function [Box1,Box2] = SplitBox(Box)
%SplitBox Summary of this function goes here
%   Detailed explanation goes here
    level = Box{2};
    colour_map = Box{1};
    %Determine the dimension to split along
    var_1 = Box{4}-Box{3};
    var_2 = Box{6}-Box{5};
    var_3 = Box{8}-Box{7};
    [~,dim] = max([var_1,var_2,var_3]);
    med_cor = median(colour_map(:,dim));
    colour_map_1 = [];
    j = 1;
    colour_map_2 = [];
    k = 1;
    for i = 1:length(colour_map)
        if (colour_map(i,dim) < med_cor)
            colour_map_1(j,:) = colour_map(i,:);
            j = j + 1;
        else
            colour_map_2(k,:) = colour_map(i,:);
            k = k + 1;
        end
    end
    [Box1] = CreateColorBox(colour_map_1, level+1);
    [Box2] = CreateColorBox(colour_map_2, level+1);
end

