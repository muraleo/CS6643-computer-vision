clear all

%Read image
image1=imread('im1.png');
image2=imread('im2.png');
image3=imread('im3.png');
image4=imread('im4.png');

%Divide by 255
image1 = double(image1)/255;
image2 = double(image2)/255;
image3 = double(image3)/255;
image4 = double(image4)/255;

%Determine the matrix V
v=[0,0,1;-0.2,0,1;0.2,0,1;0,-0.2,1];

%Linear least square
albedo = zeros(100);
p = zeros(100);
q = zeros(100);
normal_1 = [];
normal_2 = [];
normal_3 = [];

for i=1:100
    for j=1:100
        i_diag = [image1(i,j),0,0,0;
                  0,image2(i,j),0,0;
                  0,0,image3(i,j),0;
                  0,0,0,image4(i,j)];
        i_normal = [image1(i,j);image2(i,j);image3(i,j);image4(i,j)];
        g=pinv(i_diag*v)*(i_diag*i_normal);
        albedo(i,j)=norm(g);
        normal=g/norm(g);
        normal_1=[normal_1;normal(1)];
        normal_2=[normal_2;normal(2)];
        normal_3=[normal_3;normal(3)];
        p(i,j)=normal(1)/normal(3);
        q(i,j)=normal(2)/normal(3);
    end
end

%Integration
height_map=zeros(100);
%for each pixel in the left column of height map
for i=1:100
    if i == 1
        height_map(i,1)=0;
    else
        height_map(i,1)=height_map(i-1,1)+q(i,j);
    end
end
%for each row
for i=1:100
    for j=2:100
        height_map(i,j) = height_map(i,j-1)+p(i,j);
    end
end

%mesh viewing
%Albedo map
fig = figure(1);
set(fig, 'Position', [0,0,1440,600])
subplot(1,2,1);
imshow(albedo)
title('Albedo map')

%vector map
subplot(1,2,2);
spacing = 1;
[x,y] = meshgrid(1:spacing:100, 1:spacing:100);
quiver(x,y,p(1:spacing:end, 1:spacing:end),q(1:spacing:end, 1:spacing:end));
axis tight;
axis square;
title('Needle map');

%surface rendering
C = 100;
R = 100;
fig2 = figure(2);
set(fig2, 'Position', [0,0,1440,600])
subplot(1,2,1);
[x,y] = meshgrid( 1:C, 1:R );
surf(x,y, height_map,'EdgeColor','none');
camlight left;
lighting phong
title('Wirefram of depth map')

%Graylevel Depth image
subplot(1,2,2);
height_map = double(height_map)/-255;
imshow(height_map);
title('Graylevel Depth map')