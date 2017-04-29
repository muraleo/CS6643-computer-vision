clear all

%Read image
image1=imread('real1.bmp');
image2=imread('real2.bmp');
image3=imread('real3.bmp');
image4=imread('real4.bmp');

%Divide by 255
image1 = double(image1)/255;
image2 = double(image2)/255;
image3 = double(image3)/255;
image4 = double(image4)/255;

%Determine the matrix V
v=[0.38359,0.236647,0.89266;
   0.372825,-0.303914,0.87672;
   -0.250814,-0.34752,0.903505;
   -0.203844,0.096308,0.974255];

%Linear least square
albedo = zeros(460);
p = zeros(460);
q = zeros(460);
normal_1 = [];
normal_2 = [];
normal_3 = [];

for i=1:460
    for j=1:460
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
height_map=zeros(460);
%for each pixel in the left column of height map
for i=1:460
    if i == 1
        height_map(i,1)=0;
    else
        height_map(i,1)=height_map(i-1,1)+q(i,j);
    end
end
%for each row
for i=1:460
    for j=2:460
        height_map(i,j) = height_map(i,j-1)+p(i,j);
    end
end

%----------mesh viewing -----------

%Albedo map
fig = figure(1);
set(fig, 'Position', [0,0,1440,600])
subplot(1,2,1);
imshow(albedo)
title('Albedo map')

%vector map
subplot(1,2,2);
spacing = 5;
[x,y] = meshgrid(1:spacing:460, 1:spacing:460);
quiver(x,y,p(1:spacing:end, 1:spacing:end),q(1:spacing:end, 1:spacing:end));
axis tight;
axis square;
title('Needle map');

%surface randering
C = 460;
R = 460;
figure(2);
[x,y] = meshgrid( 1:C, 1:R );
surf(x,y, height_map,'EdgeColor','none');
camlight left;
lighting phong
title('Wirefram of depth map')

%Graylevel Depth image
figure(3);
height_map = double(height_map)/-255;
imshow(height_map);
title('Graylevel Depth map')