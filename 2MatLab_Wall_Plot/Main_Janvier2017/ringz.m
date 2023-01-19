function wall=ringz(a,xc,yc,R,dr,voxel)
%     wall488=ringz(a,xc,yc,R,dr,voxel);

[~,~,n]=size(a); %nbrs de stack

px=((1-dr)*R:0.5:(1+dr)*R)-R; % Zone autour de R
voxel=2*voxel; % Pourquoi ?
m=n*voxel;
pz=fliplr((1:1/voxel:(m-mod(m,1))/voxel)); % inverse gauche/droite, change la résolution en Z : 1/(2*dz/dx). 
py=zeros(length(pz),length(px));
nangle=round(4*pi*R);

[px,pz]=meshgrid(px,pz);%permet addition de vecteurs ligne+colonne de tailles différentes

wall=[];

for i=1:nangle
    
    angle=2*pi*i/nangle; %1:2pi
    [px2,py2,pz2]=rot3d(px,py,pz,angle,[0 0 1]); % Définit l'axe de rotation
    px2=px2+xc+R*cos(angle); %Récupere les coordonnées x autour de R
    py2=py2+yc+R*sin(angle);
    
    b=max(interp3cpp(a,px2,py2,pz2),[],2); % Garde la valeur max d'intensité les coordonées px/py/pz
    
    wall=[wall b];
    
% figure(1)
% imagesc(wall)
% axis equal

end;




