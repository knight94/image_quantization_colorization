function [Box] = CreateColorBox(ColorSet, splitlevel)
%CreateColorBox Summary of this function goes here
%   Return box details, number of color, level and max/min of each channel.
Box = {};
Box{1} = ColorSet;
Box{2} = splitlevel;
%Red channel 1
Box{3} = min(ColorSet(:,1));
Box{4} = max(ColorSet(:,1));
%green channel 2
Box{5} = min(ColorSet(:,2));
Box{6} = max(ColorSet(:,2));
%blue channel 3
Box{7} = min(ColorSet(:,3));
Box{8} = max(ColorSet(:,3));
end

