% Read original image
original_image = imread('toy_formatted2.png');

gauss_filtered_image1 = gaussian_filter(original_image, 2.0);
gauss_filtered_image2 = gaussian_filter(original_image, 5.0);

figure('Position', [100, 100, 800, 800]);
subplot(3,1,1);
imshow(original_image);
title('Original image');

subplot(3,1,2);
imshow(gauss_filtered_image1);
title('Gaussian filter sigma=2.0');

subplot(3,1,3);
imshow(gauss_filtered_image2);
title('Gaussian filter sigma=5.0');