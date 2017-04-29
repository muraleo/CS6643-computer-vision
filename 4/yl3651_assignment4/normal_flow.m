%read images
image1 = imread('toy_formatted2.png');
image2 = imread('toy_formatted3.png');
image3 = imread('toy_formatted4.png');
image4 = imread('toy_formatted5.png');
image5 = imread('toy_formatted6.png');
image6 = imread('toy_formatted7.png');
image7 = imread('toy_formatted8.png');
image8 = imread('toy_formatted9.png');

%applying smoothing to the images
sigma = 4.5;
filtered_image1 = gaussian_filter(double(image1), sigma);
filtered_image2 = gaussian_filter(double(image2), sigma);
%use to get result from unfiltered
% filtered_image1 = double(image1); 
% filtered_image2 = double(image2);
filtered_image3 = gaussian_filter(double(image3), sigma);
filtered_image4 = gaussian_filter(double(image4), sigma);
filtered_image5 = gaussian_filter(double(image5), sigma);
filtered_image6 = gaussian_filter(double(image6), sigma);
filtered_image7 = gaussian_filter(double(image7), sigma);
filtered_image8 = gaussian_filter(double(image8), sigma);

figure(1);
imshow(filtered_image1);
title('Filtered image1');

%calculate temporal gradient
offset = 90; %use to move double pixel value to integer range

temporal_gradient = double(filtered_image2)-double(filtered_image1);
figure(2);
imshow(temporal_gradient+offset,[0,255]);
title('Temporal gradient map');

%estimate spatial derivatives
e_x = zeros(266,534);
for i=2:266
    for j=1:534
        e_x(i-1,j) = double(filtered_image1(i,j))-double(filtered_image1(i-1,j));
    end
end
figure(3);
imshow(e_x+offset,[0,255]);
title('Spatial derivatives of x');

e_y = zeros(266,534);
for i=1:266
    for j=2:534
        e_y(i,j-1) = double(filtered_image1(i,j))-double(filtered_image1(i,j-1));
    end
end
figure(4);
imshow(e_y+offset,[0,255]);
title('Spatial derivatives of y');

%calculate normal flow
u=zeros(265,533);
v=zeros(265,533);

for i=1:265
    for j=1:533
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