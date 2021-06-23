%Median Cut Algorithm for colour image quantization
clear all;clc;
quan_value = 8;
P = imread('../../Pamela.PNG');

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

%Generating new Image using color_pallete
new_Image = zeros(size(P));
P_double = im2double(A)*255;
for i = 1:size(A,1)
    for j = 1:size(A,2)
        D_old = intmax;
        q_color = [0, 0, 0];
        for k = 1:size(color_pallete,1)
            r = color_pallete(k,1);
            b = color_pallete(k,2);
            g = color_pallete(k,3);
            D_new = sqrt((P_double(i,j,1)-double(r(1)))^2+(P_double(i,j,2)-double(b(1)))^2+(P_double(i,j,3)-double(g(1)))^2);
            if D_new < D_old
                q_color(1) = r;
                q_color(2) = b;
                q_color(3) = g;
                D_old = D_new;
            end
        end
        new_Image(i,j,1) =  q_color(1);
        new_Image(i,j,2) =  q_color(2);
        new_Image(i,j,3) =  q_color(3);
    end
end
figure(2)
imshow(P);
figure(3)
imshow(uint8(new_Image));



