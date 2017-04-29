clear all;
t1 = imread('tetrahedron1.JPG');
t2 = imread('tetrahedron2.JPG');

fig = figure(1);
set(fig, 'Position', [10,10,1440,600])
subplot(1,2,1);
image(t1);
hold on;
[u1,v1] = ginput(4);
sz = 40;
c = [1, 0, 0]
scatter(u1,v1,sz,c,'filled');
title('Left Image')
pause(2);
hold off;

subplot(1,2,2);
image(t2);
hold on;
[u2,v2] = ginput(4);
scatter(u2,v2,sz,c,'filled');
title('Right Image')
hold off;

pause(2);
close all;

%sensor model
%name: Sony IMX315 Exmor Rs
%size: 4.8 * 3.6 mm
%image resolution: 4032 * 3024 pixels
%focal length: 4.02mm

B = 30   %(unit:mm)
f = 4.02 %(unit:mm)
u0 = 2003 %data from assignment1
v0 = 1514 %data from assignment1

%calculate horizontal disparity
%convert pixel to mm unit

%Wrong way to calculate coordinate, need to consider u0, v0 
% for i = 1:4
%     u1(i) = u1(i) * 4.8/4032;
%     u2(i) = u2(i) * 4.8/4032;
%     v1(i) = v1(i) * 3.6/3024;
%     v2(i) = v2(i) * 3.6/3024;
% end

%Correct convert pixel to mm unit
for i = 1:4
    u1(i) = (u1(i)-u0) * 4.8/4032;
    u2(i) = (u2(i)-u0) * 4.8/4032;
    v1(i) = (v1(i)-v0) * 3.6/3024;
    v2(i) = (v2(i)-v0) * 3.6/3024;
end

%Get world coordinates
z = [];
for i = 1:4
    temp = f*B/abs(u1(i)-u2(i));
    z = [z;temp];
end

x=[]
for i = 1:4
    temp = -u1(i)*z(i)/f;
    x = [x;temp];
end

y=[]
for i = 1:4
    temp = -v1(i)*z(i)/f;
    y = [y;temp];
end

figure(1);
hold on;
plot3([x(1),x(2)],[y(1),y(2)],[z(1),z(2)])
plot3([x(1),x(3)],[y(1),y(3)],[z(1),z(3)])
plot3([x(1),x(4)],[y(1),y(4)],[z(1),z(4)])
plot3([x(2),x(3)],[y(2),y(3)],[z(2),z(3)])
plot3([x(2),x(4)],[y(2),y(4)],[z(2),z(4)])
plot3([x(3),x(4)],[y(3),y(4)],[z(3),z(4)])
scatter3(x,y,z,'r','filled')

%check result, check the length of each edge in the reconstruted polygon
result = [] %use to store the length of each edge of the reconstracted polygon
for i=1:3
    for j=i+1:4
        temp = norm([x(i)-x(j),y(i)-y(j),z(i)-z(j)]);
        result = [result;temp];
    end
end

disp('result:');
disp(result);
disp('the mean and variance of the result are:');
disp('mean:');
disp(mean(result));
disp('variance:');
disp(var(result));