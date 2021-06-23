function [idx] = Match_pixel(pixel,samples)
    A = repmat(pixel, size(samples,1), 1);
    B = samples(:,3:4);
    Diff = (A-B).^2;
    
    weighted_average = 0.5 *Diff(:,1) + 0.5 *Diff(:,2);
    [~,idx] = min(weighted_average);
end

