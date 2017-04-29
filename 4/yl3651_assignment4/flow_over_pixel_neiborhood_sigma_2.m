%read images
image1 = imread('toy_formatted2.png');
image2 = imread('toy_formatted3.png');

%applying smoothing to the images
sigma = 2.0;
filtered_image1 = gaussian_filter(double(image1), sigma);
filtered_image2 = gaussian_filter(double(image2), sigma);

%calculate temporal gradient
temporal_gradient = double(filtered_image2)-double(filtered_image1);

%estimate spatial derivatives
e_x = zeros(266,534);
for i=2:266
    for j=1:534
        e_x(i-1,j) = double(filtered_image1(i,j))-double(filtered_image1(i-1,j));
    end
end

e_y = zeros(266,534);
for i=1:266
    for j=2:534
        e_y(i,j-1) = double(filtered_image1(i,j))-double(filtered_image1(i,j-1));
    end
end

%calculate normal flow
v=zeros(266,534,2);

for i=1:265
    for j=1:533
        a=[e_x(i,j),e_y(i,j);
           e_x(i,j+1),e_y(i,j+1);
           e_x(i+1,j),e_y(i+1,j);
           e_x(i+1,j+1),e_y(i+1,j+1);];
        b=[temporal_gradient(i,j);
           temporal_gradient(i,j+1);
           temporal_gradient(i+1,j);
           temporal_gradient(i+1,j+1);];
        temp=-pinv(a'*a)*a'*b;
        v(i,j,1)=temp(1);
        v(i,j,2)=temp(2);
    end
end

figure(1);
imshow(image1);
hold on;
quiver(v(:,:,1),v(:,:,2));
title('Flow on raw image with sigma = 2.0');
hold off;

figure(2);
imshow(image1);
hold on;
quiver(v(:,:,1),v(:,:,2));
title('Image filtered by a Gaussian smothing of sigma=2.0');
hold off;