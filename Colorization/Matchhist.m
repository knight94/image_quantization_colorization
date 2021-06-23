function [im_n] = Matchhist(im,im2)
%Matchhist Summary of this function goes here

% im = imread('givenhist','jpg');
im = im2double(im);
[hist_Y,hist_X] = imhist(im);
prob = hist_Y./(size(im,1)*size(im,2));
L = 256;
p = 0;
s = hist_X;
for i = 1:L
        p = p + prob(i);
        s(i) = floor((L-1)*p);
end


% im2 = imread('sphist','jpg');
im2 = im2double(im2);
[hist_Y2,hist_X2] = imhist(im2);
prob2 = hist_Y2./(size(im2,1)*size(im2,2));
L = 256;
p2 = 0;
s2 = hist_X2;
for i = 1:L
        p2 = p2 + prob2(i);
        s2(i) = floor((L-1)*p2);
end
% figure
% stem(hist_X,hist_Y);
% figure
% stem(hist_X,s);

% im_n2 = im2;
% for i = 1:size(im2,1)
%     for j = 1:size(im2,2)
%         im_n2(i,j) = s(im2(i,j)*255 + 1);
%     end
% end
s3 = s2;
s3_index= s2;
for k = 1:256
    min = inf;
    for l = 1:256
        e = s2(l) - s(k);
        if(e>0 && e<min)
            min = e;
            s3(k) = s2(l);
            s3_index(k) = l;
        end
    end
end

im_n = im;
for i = 1:size(im,1)
    for j = 1:size(im,2)
        im_n(i,j) = hist_X2(s3_index(im(i,j)*255 + 1));
    end
end

% % im_n = im_n ./(max(max(im_n)));
% figure
% subplot(2,1,1)
% imshow(im);
% subplot(2,1,2)
% imhist(im);
% figure
% subplot(2,1,1)
% imshow(im2);
% subplot(2,1,2)
% imhist(im2)
% figure
% subplot(2,1,1)
% imshow(im_n);
% subplot(2,1,2)
% imhist(im_n)
end

