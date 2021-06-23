%Popularity Algorithm for colour image quantization
clear all;clc;
orig_bits = 8;
quan_value = 256;
P = imread('../../Pamela.PNG');

A = P;
%Reshaping image matrix to 2D matrix with number of pixelsXchannels.
[unique_color_map, labels_start, labels] = unique(reshape(A, [], 3), 'rows', 'stable');
[N,EDGES] = histcounts(labels,size(labels_start,1));

% figure(1)
% bar(N);
[k_popular_freq, freq_index] = maxk(N,quan_value);
k_color_map = unique_color_map(freq_index,:);

%Generating new Image using color_pallete(k_color_map)
new_Image = zeros(size(P));
P_double = im2double(A)*255;
for i = 1:size(A,1)
    for j = 1:size(A,2)
        D_old = intmax;
        q_color = [0, 0, 0];
        for k = 1:size(k_color_map,1)
            r = k_color_map(k,1);
            b = k_color_map(k,2);
            g = k_color_map(k,3);
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
