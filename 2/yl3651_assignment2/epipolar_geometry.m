clear all;
% toy1 = imread('toy1.JPG');
% toy2 = imread('toy2.JPG');
toy1 = imread('toy11.JPG');
toy2 = imread('toy22.JPG');
% toy1 = imread('left.jpg');
% toy2 = imread('right.jpg');

fig = figure(1);
set(fig, 'Position', [10,10,1440,600])
subplot(1,2,1);
image(toy1);
hold on;
[u1,v1] = ginput(8);
sz = 40;
c = [1, 0, 0];
scatter(u1,v1,sz,c,'filled');
title('Left Image');
pause(2);
hold off;

subplot(1,2,2);
image(toy2);
hold on;
[u2,v2] = ginput(8);
scatter(u2,v2,sz,c,'filled');
title('Right Image');
hold off;

pause(2);
close all;

%calculate F matrix
p=[];
temp=[];
for i=1:8
    temp=[u1(i)*u2(i),u1(i)*v2(i),u1(i),u2(i)*v1(i),v1(i)*v2(i),v1(i),u2(i),v2(i)];
    p=[p;temp];
end
I=-[1;1;1;1;1;1;1;1];

%f=inv(p)*I;
f=p\I;
f=[f;1];
F=[f(1),f(2),f(3);f(4),f(5),f(6);f(7),f(8),f(9)];

clear fig;

%calculate epipolar line l' in right image
fig = figure(1);
set(fig, 'Position', [50,50,1440,600]);
subplot(1,2,1);
image(toy1);
subplot(1,2,2);
image(toy2);

for i=1:4
    subplot(1,2,1);
    hold on;
    title([num2str(5-i),' points you can select in left image']);
    point_p=ginput(1);
    point_p=[point_p,1];
    scatter(point_p(1),point_p(2),50,'r','filled');
    l_prime=point_p*F;
    %l_prime=F*point_p';
    %first_two_norm = norm([l_prime(1),l_prime(2)]);
    %l_prime = l_prime*1/first_two_norm;
    %Because now the epipolar line l' is y=-l'(1)/l'(2)*x+l'(3)/l'(2)
    %then we can define this line
    x=1:4000;
    y=(-l_prime(1)/l_prime(2)) * x - l_prime(3)/l_prime(2);
    
    subplot(1,2,2);
    hold on;
    plot(x, y, 'color','r');
    title('Right Image');
    %hold off;
end
subplot(1,2,1);
title('left image');
pause(2);

%calculate epipolar line l in left image
for i=1:4
    subplot(1,2,2);
    hold on;
    title([num2str(5-i),' points you can select in right image']);
    point_p=ginput(1);
    point_p=[point_p,1];
    scatter(point_p(1),point_p(2),50,'b','filled');
    title('Right Image');
    l=F*transpose(point_p);
    %l=transpose(F)*transpose(point_p);
    %first_two_norm = norm([l(1),l(2)]);
    %l = l/first_two_norm;
    %Because now the epipolar line l is y=-l(1)/l(2)*x+l(3)/l(2)
    %then we can define this line
    x=1:4000;
    y=(-l(1)/l(2)) * x - l(3)/l(2);

    subplot(1,2,1);
    %image(toy1);
    hold on;
    plot(x, y, 'color', 'b');
    title('Left Image');
end
subplot(1,2,2);
title('right image');

%calculate right epipole
[ur,dr] = eigs(transpose(F) * F);
uur = ur(:,1);
uur = uur/uur(3)

%calculate left epipole
[ul,dl] = eigs(F * transpose(F));
uul = ul(:,1);
uul = uul/uul(3)
