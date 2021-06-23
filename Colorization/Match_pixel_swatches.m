function [swatch_idx, idx] = Match_pixel_swatches(target_value, Swatches, Swatches_L, N_size)
    A = target_value;
    global_min = inf;

    swatch_idx =1;
    idx = 1;
    for z = 1:length(Swatches)
        swatch_padded = padarray(Swatches_L{z},[N_size, N_size]);
        for y = 1:size(Swatches{z},1)
            i = Swatches{z}(y,1)+N_size;
            j = Swatches{z}(y,2)+N_size;
            if ( i == N_size || j == N_size)
                continue;
            end
            B = swatch_padded(i-N_size:i+N_size,j-N_size:j+N_size);
            local_min = sum((A-B).^2, 'all');
            if (local_min < global_min)
                swatch_idx = z;
                idx = y;
                global_min = local_min;
            end
        end
    end
end

