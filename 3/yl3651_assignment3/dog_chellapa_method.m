clear all

%Read image
image1=imread('dog1.png');
image2=imread('dog2.png');
image3=imread('dog3.png');
image4=imread('dog4.png');

%Divide by 255
image1 = double(image1)/255;
image2 = double(image2)/255;
image3 = double(image3)/255;
image4 = double(image4)/255;

%Determine the matrix V
%normalize source vector
%v1=[16,19,30]/norm([16,19,30]);
v2=[13,16,30]/norm([13,16,30]);
v3=[-17,10.5,26.5]/norm([-17,10.5,26.5]);
v4=[9,-25,4]/norm([9,-25,4]);
v=[v2;v3;v4];

%Linear least square
albedo = zeros(400);
p = zeros(400);
q = zeros(400);
normal_1 = [];
normal_2 = [];
normal_3 = [];

for i=1:400
    for j=1:400
%         i_diag = [image1(i,j),0,0,0;
%                   0,image2(i,j),0,0;
%                   0,0,image3(i,j),0;
%                   0,0,0,image4(i,j)];
%        i_normal = [image1(i,j);image2(i,j);image3(i,j);image4(i,j)];
        i_normal = [image2(i,j);image3(i,j);image4(i,j)];
%        g=pinv(i_diag*v)*(i_diag*i_normal);
        g=pinv(v)*i_normal;
        albedo(i,j)=norm(g);
        if albedo(i,j)==0
            normal_1=[normal_1;0];
            normal_2=[normal_2;0];
            normal_3=[normal_3;0];
            p(i,j)=0;
            q(i,j)=0;
        else
            normal=g/norm(g);
            normal_1=[normal_1;normal(1)];
            normal_2=[normal_2;normal(2)];
            normal_3=[normal_3;normal(3)];
            p(i,j)=normal(1)/normal(3);
            q(i,j)=normal(2)/normal(3);
        end
    end
end

%Intergration with the Chellappa method
height_map = frankotchellappa(p, q);

%mesh viewing
%Albedo map
fig = figure(1);
set(fig, 'Position', [0,0,1440,600])
imshow(albedo)
title('Albedo map')

%vector map
figure(2);
spacing = 1;
[x,y] = meshgrid(1:spacing:400, 1:spacing:400);
quiver(x,y,p,q);
axis tight;
axis square;
title('Needle map');

%surface randering
C = 400;
R = 400;
figure(3);
[x,y] = meshgrid( 1:C, 1:R );
surf(x,y, height_map,'EdgeColor','none');
camlight left;
lighting phong;
title('Wirefram of depth map');

%Graylevel Depth image
figure(4);
height_map = double(height_map)/-255;
imshow(height_map);
title('Graylevel Depth map')