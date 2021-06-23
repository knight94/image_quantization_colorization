%Swatch matching algorithm for colorizing the greyscal images
%Determine the swatches in the image
%   Covert the colored swatch source image to lab space
%   Histogram matching of luminance source image to target image Matchhist
%   Calculated standard deviation using 5x5 neighbourhood pixels J = stdfilt(I,nhood)
%   Take 50 samples from source image (Jittered sampling)
%   Using weighted average (0.5*luminance + 0.5*standard deviation find the
%   nearest pixel
% Using a Neighbourhood

clear all;clc;
Source = imread('../../source_image.jpg');
Target = imread('../../target_image.jpg');
Num_Swatches = 2;
if ( size(Target,3) == 3)
    Target = rgb2gray(Target);
end
Target_D = im2double(Target);
Swatches_L = {};
Swatches = {};
Swatches_rect = {};
for o = 1:Num_Swatches
    %Get the swatches using imrect
    f = figure;
    ax1 = subplot(1,2,1);
    imshow(Source);
    ax2 = subplot(1,2,2);
    imshow(Target);
    A = round(wait(imrect(ax1))); % result assigned to objectRegionA
    B = round(wait(imrect(ax2))); % result assigned to objectRegionB
    close(f);
    Swatches_rect{o,1} = A;
    Swatches_rect{o,2} = B;

    subimage_source = imcrop(Source,A);
    subimage_Target = imcrop(Target,B);

    [color_swatch_Target] = Color_swatch(subimage_source,subimage_Target, 64);

    Swatch_lab = rgb2lab(color_swatch_Target);

    Swatches_L{o} = Swatch_lab(:,:,1)./100;
    [Swatches{o}] = Jittered_sampling(Swatch_lab(:,:,1), Swatch_lab, 64);
end
%Texture matching using these two swatches.
N_L2 = 5;
N_size = floor(N_L2/2);

%Transfer the color to target image
new_Image_lab = zeros([size(Target_D),3]);
Target_padded = padarray(Target_D,[N_size, N_size],0.5);
for i = 1:size(Target_D,1)
    for j = 1:size(Target_D,2)
        target_value = Target_padded(i:i+2*N_size,j:j+2*N_size);
        [swatch_idx, idx] = Match_pixel_swatches(target_value, Swatches, Swatches_L, N_size);
        new_Image_lab(i,j,1) = Target_D(i,j)*100;
        new_Image_lab(i,j,2:3) = Swatches{swatch_idx}(idx,4:5);
    end
end

color_target_final = lab2rgb(new_Image_lab);

Swatch_color = ['r','g','b','c','m','y','k','w'];
figure
subplot(1,3,1)
imshow(Source);
for o = 1:Num_Swatches
    rectangle('Position',Swatches_rect{o,1}, 'Edgecolor', Swatch_color(o), 'LineWidth', 2);
end
subplot(1,3,2)
imshow(Target);
for o = 1:Num_Swatches
    rectangle('Position',Swatches_rect{o,2}, 'Edgecolor', Swatch_color(o), 'LineWidth', 2);
end
subplot(1,3,3)
imshow(color_target_final);





