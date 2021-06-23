function [Source_Jittered] = Jittered_sampling(Source_L, Source_lab, N_sample)
    [rows, col] = size(Source_L);
    Step_x = floor(rows/sqrt(N_sample));
    Step_y = floor(col/sqrt(N_sample));

    sampling_index = randi([1, Step_x*Step_y], 1, N_sample);
    Source_Jittered = zeros(N_sample, 5);
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
            Source_Jittered(k,3) = Source_L(jitter_x,jitter_y);
            Source_Jittered(k,4) = Source_lab(jitter_x,jitter_y,2);
            Source_Jittered(k,5) = Source_lab(jitter_x,jitter_y,3);
            k = k + 1;
        end
        if ( k > N_sample)
            break;
        end
    end
end

