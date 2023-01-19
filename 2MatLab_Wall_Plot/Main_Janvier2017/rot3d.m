function [x,y,z]=rot3d(x,y,z,r,A)
% Rotation 3D autour de l'axe défini par A
[m,n]=size(x);

A = A/norm(A);
u = A(1);
v = A(2);
w = A(3);
c = cos(r);
s = sin(r);

R = nan(3);
R(1,1) =  u^2 + (v^2 + w^2)*c;
R(1,2) = u*v*(1-c) - w*s;
R(1,3) = u*w*(1-c) + v*s;
R(2,1) = u*v*(1-c) + w*s;
R(2,2) = v^2 + (u^2+w^2)*c;
R(2,3) = v*w*(1-c) - u*s;
R(3,1) = u*w*(1-c) - v*s;
R(3,2) = v*w*(1-c)+u*s;
R(3,3) = w^2 + (u^2+v^2)*c;
% Matrice rotation autour de Z[cos -sin 0][sin cos 0][0 0 1]
pt=R*[reshape(x,m*n,1) reshape(y,m*n,1) reshape(z,m*n,1)]'; % Passe une matrice en 1 colonne
x=reshape(pt(1,:),m,n);
y=reshape(pt(2,:),m,n);
z=reshape(pt(3,:),m,n);