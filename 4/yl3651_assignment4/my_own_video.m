clear all;
mov = VideoReader('roll.MOV');
frames = read(mov);
number=mov.NumberOfFrames;
% for i=1:26
%     imshow(frames(:,:,:,i));
%     grayImage = rgb2gray(frames(:,:,:,i));
% end
image1 = rgb2gray(frames(:,:,:,2));
image2 = rgb2gray(frames(:,:,:,3));

%applying smoothing to the images
sigma = 4.5;
filtered_image1 = gaussian_filter(double(image1), sigma);
filtered_image2 = gaussian_filter(double(image2), sigma);

figure(1);
imshow(filtered_image1,[0,255]);
title('Filtered image1');

%calculate temporal gradient
offset = 90; %use to move double pixel value to integer range

temporal_gradient = double(filtered_image2)-double(filtered_image1);
figure(2);
imshow(temporal_gradient+offset,[0,255]);
title('Temporal gradient map');

%estimate spatial derivatives
e_x = zeros(1079,1920);
for i=2:1080
    for j=1:1920
        e_x(i-1,j) = double(filtered_image1(i,j))-double(filtered_image1(i-1,j));
    end
end
figure(3);
imshow(e_x+offset,[0,255]);
title('Spatial derivatives of x');

e_y = zeros(1080,1919);
for i=1:1080
    for j=2:1920
        e_y(i,j-1) = double(filtered_image1(i,j))-double(filtered_image1(i,j-1));
    end
end
figure(4);
imshow(e_y+offset,[0,255]);
title('Spatial derivatives of y');

%calculate normal flow
u=zeros(1079,1919);
v=zeros(1079,1919);

for i=1:1079
    for j=1:1919
        temp = e_x(i,j)*e_x(i,j)+e_y(i,j)*e_y(i,j);
        u(i,j) = -1.0*double(temporal_gradient(i,j))*e_x(i,j)/temp;
        v(i,j) = -1.0*double(temporal_gradient(i,j))*e_y(i,j)/temp;
    end
end

figure(5);
imshow(image1);
hold on;
quiver(u,v);
title('Flow vector map');
hold off;