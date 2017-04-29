% Get pixel coordinates of the picture
image(pattern);
[x,y]= ginput(22);

%Store world coordinates of each point on the picture
pw=[38,27.6,0,1;
149,27.8,0,1;
93.2,55.2,0,1;
65.5,83,0,1;
177,83,0,1;
121.4,111,0,1;
38,138.8,0,1;
177,138.8,0,1;
93.5,166.2,0,1;
149.5,194,0,1;
66,221.8,0,1;
0,27.6,39,1;
0,27.6,150.2,1;
0,55.3,94.4,1;
0,83,66.5,1;
0,83,178,1;
0,111,122,1;
0,138.8,38.8,1;
0,138.8,177.8,1;
0,166.5,94,1;
0,194,150,1;
0,222,66,1];

%get little p matrix
p=[]
temp=[]
for i=1:22
    temp=[pw(i,:),0,0,0,0,pw(i,:)*x(i)*(-1)]
    p=[p;temp]
    temp=[0,0,0,0,pw(i,:),pw(i,:)*y(i)*(-1)]
    p=[p;temp]
end

%Get m matrix
[U S V] = svd(p);
[min_val, min_index] = min(diag(S(1:12,1:12)));
m = V(1:12,min_index);

m_big=[m(1),m(2),m(3),m(4);
m(5),m(6),m(7),m(8);
m(9),m(10),m(11),m(12);]

%Get a1, a2, a3
a1 = [m(1),m(2),m(3)]
a2 = [m(5),m(6),m(7)]
a3 = [m(9),m(10),m(11)]

a3_norm = norm(a3)

%Get intrinsic parameters
rho = 1/a3_norm
r3 = a3 * rho

u0 = dot(a1,a3)*rho*rho
v0 = dot(a2,a3)*rho*rho

cos_theta = -1*dot(cross(a1,a3),cross(a2,a3))/(norm(cross(a1,a3))*norm(cross(a2,a3)))
theta = acos(cos_theta)

alpha = rho*rho*norm(cross(a1,a3))*sin(theta)
beta = rho*rho*norm(cross(a2,a3))*sin(theta)

r1 = cross(a2,a3)/norm(cross(a2,a3))
r2 = cross(r3,r1)
r=[r1;r2;r3]

%From here is the reconstruction part
tz = (m(12))
ty = (m(8)-v0*tz)*sin(theta)/beta
tx = (m(4)+alpha*cot(theta)*ty-v0*tz)/alpha

t=[tx;ty;tz] * rho

%k=[alpha,-1*alpha*cot(theta),u0;
%0,beta/sin(theta),v0;
%0,0,1]

%point=[38;27.6;0]
%point_test = k*(r*point+t)/tz

m1=[m(1),m(2),m(3),m(4)]
m2=[m(5),m(6),m(7),m(8)]
m3=[m(9),m(10),m(11),m(12)]

%u = m1*pw(1,:)'/(m3*pw(1,:)')
%v = m2*pw(1,:)'/(m3*pw(1,:)')

%Reconstruct the image coordinates
p_reconstruct=[]
for i=1:22
    temp=[m1*pw(i,:)'/(m3*pw(i,:)'),m2*pw(i,:)'/(m3*pw(i,:)')]
    p_reconstruct=[p_reconstruct;temp]
end

%Compare the calculated pixel location and measured pixel location
error_ratio = []
x_new = p_reconstruct(:,1)
y_new = p_reconstruct(:,2)

for i=1:22
    temp=[(x_new(i)-x(i))/x(i),(y_new(i)-y(i))/y(i)]
    error_ratio = [error_ratio;temp]
end
100*error_ratio