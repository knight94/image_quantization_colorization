%Floyed and Steinberg algorithm for colour image quantization
clear all;clc;
quan_value = 8;
P = imread('../../Pamela.PNG');

[color_pallete] = MedianCut(P, quan_value);
%[color_pallete] = Popularity(P, quan_value);

%Generating new Image using color_pallete
new_Image = zeros(size(P));
A = P;
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
        %Quantization error
        E_r = P_double(i,j,1) - new_Image(i,j,1);
        E_g = P_double(i,j,2) - new_Image(i,j,2);
        E_b = P_double(i,j,3) - new_Image(i,j,3);
        
%         %Propagate the error to the nearest pixels
%         if( i+1 <= size(A,1))
%             P_double(i+1,j,1) = P_double(i+1,j,1) + E_r*3/8;
%             P_double(i+1,j,2) = P_double(i+1,j,2) + E_g*3/8;
%             P_double(i+1,j,3) = P_double(i+1,j,3) + E_b*3/8;
%             if( j+1 <= size(A,2))
%                 P_double(i,j+1,1) = P_double(i,j+1,1) + E_r*3/8;
%                 P_double(i+1,j+1,1) = P_double(i+1,j+1,1) + E_r*2/8;
%                 P_double(i,j+1,2) = P_double(i,j+1,2) + E_g*3/8;
%                 P_double(i+1,j+1,2) = P_double(i+1,j+1,2) + E_g*2/8;
%                 P_double(i,j+1,3) = P_double(i,j+1,3) + E_b*3/8;
%                 P_double(i+1,j+1,3) = P_double(i+1,j+1,3) + E_b*2/8;
%             end
%         elseif( j+1 <= size(A,2))
%             P_double(i,j+1,1) = P_double(i,j+1,1) + E_r*3/8;
%             P_double(i,j+1,2) = P_double(i,j+1,2) + E_g*3/8;
%             P_double(i,j+1,3) = P_double(i,j+1,3) + E_b*3/8;
%         end
        %Propagate the error to the nearest pixels
        if( i+1 <= size(A,1))
            P_double(i+1,j,1) = P_double(i+1,j,1) + E_r*7/16;
            P_double(i+1,j,2) = P_double(i+1,j,2) + E_g*7/16;
            P_double(i+1,j,3) = P_double(i+1,j,3) + E_b*7/16;
            if( j+1 <= size(A,2))
                P_double(i,j+1,1) = P_double(i,j+1,1) + E_r*5/16;
                P_double(i+1,j+1,1) = P_double(i+1,j+1,1) + E_r*1/16;
                P_double(i,j+1,2) = P_double(i,j+1,2) + E_g*5/16;
                P_double(i+1,j+1,2) = P_double(i+1,j+1,2) + E_g*1/16;
                P_double(i,j+1,3) = P_double(i,j+1,3) + E_b*5/16;
                P_double(i+1,j+1,3) = P_double(i+1,j+1,3) + E_b*1/16;
                if (i-1 > 0)
                    P_double(i-1,j+1,1) = P_double(i-1,j+1,1) + E_r*3/16;
                    P_double(i-1,j+1,2) = P_double(i-1,j+1,2) + E_g*3/16;
                    P_double(i-1,j+1,3) = P_double(i-1,j+1,3) + E_b*3/16;
                end
            end
        elseif( j+1 <= size(A,2))
            P_double(i,j+1,1) = P_double(i,j+1,1) + E_r*5/16;
            P_double(i-1,j+1,1) = P_double(i-1,j+1,1) + E_r*3/16;
            P_double(i,j+1,2) = P_double(i,j+1,2) + E_g*5/16;
            P_double(i-1,j+1,2) = P_double(i-1,j+1,2) + E_g*3/16;
            P_double(i,j+1,3) = P_double(i,j+1,3) + E_b*5/16;
            P_double(i-1,j+1,3) = P_double(i-1,j+1,3) + E_b*3/16;
        end
    end
end
figure(1)
imshow(P);
% figure(2)
% imshow(uint8(new_Image_withoutdither));
figure(3)
imshow(uint8(new_Image));