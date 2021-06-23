function [color_target] = Color_swatch(Source, Target, N_sample)
Target_D = im2double(Target);
N_size = 5;
% N_sample = 256;


%Step 1
Source_lab = rgb2lab(Source);

%Step 2 remapping and histogram matching
Source_L = Source_lab(:,:,1);
mean_source = mean(Source_L(:));
mean_Target = mean(Target_D(:));
Var_source = std(Source_L(:));
Var_Target = std(Target_D(:));

Scaled_source_L = Var_Target/Var_source * (Source_L - mean_source) + mean_Target;
[Source_remapped] = Matchhist(im2uint8(Scaled_source_L), im2uint8(Target_D));

%Step 3 Neighbourhood stats
N_sds = nlfilter(Source_remapped,[N_size N_size],'std2');
N_sds_T = nlfilter(Target_D,[N_size N_size],'std2');
%imshow(N_sds)

%Step 4 Jittered sampling of color source image to N sample. N should be a
%perfect square. For now we will take 256

[rows, col] = size(Source_remapped);
Step_x = floor(rows/sqrt(N_sample));
Step_y = floor(col/sqrt(N_sample));

sampling_index = randi([1, Step_x*Step_y], 1, N_sample);
Source_Jittered = zeros(N_sample, 6);
k = 1;
for j = 1:Step_y:col-Step_y-1
    for i = 1:Step_x:rows-Step_x-1
        if ( k > N_sample)
            break;
        end
        index_sample = sampling_index(k);
        rand_y = ceil(index_sample / Step_x);
        rand_x = index_sample - (rand_y-1)*Step_x;
        jitter_x = i + rand_x-1;
        jitter_y = j + rand_y-1;
        
        Source_Jittered(k,1) = jitter_x;
        Source_Jittered(k,2) = jitter_y;
        Source_Jittered(k,3) = Source_remapped(jitter_x,jitter_y);
        Source_Jittered(k,4) = N_sds(jitter_x,jitter_y);
        Source_Jittered(k,5) = Source_lab(jitter_x,jitter_y,2);
        Source_Jittered(k,6) = Source_lab(jitter_x,jitter_y,3);
        k = k + 1;
    end
    if ( k > N_sample)
        break;
    end
end

%Transfer the color to target image
new_Image_lab = zeros([size(Target_D),3]);
for i = 1:size(Target_D,1)
    for j = 1:size(Target_D,2)
        target_value = [Target_D(i,j), N_sds_T(i,j)];
        [idx] = Match_pixel(target_value,Source_Jittered);
        new_Image_lab(i,j,1) = Target_D(i,j)*100;
        new_Image_lab(i,j,2:3) = Source_Jittered(idx,5:6);
    end
end

color_target = lab2rgb(new_Image_lab);

end

