function mip=mip_wall(a,x0,y0,R,delta,voxel)

[~,~,n]=size(a);

px=((1-delta)*R:0.5:(1+delta)*R)-R;
voxel=2*voxel;
m=n*voxel;
pz=fliplr((1:1/voxel:(m-mod(m,1))/voxel));
py=zeros(length(pz),length(px));
nangle=round(4*pi*R);

[px,pz]=meshgrid(px,pz);

mip=[];

for i=1:nangle
    
    angle=2*pi*i/nangle;
    [px2,py2,pz2]=rot3d(px,py,pz,angle,[0 0 1]);
    px2=px2+x0+R*cos(angle);
    py2=py2+y0+R*sin(angle);
    
    b=max(interp3cpp(a,px2,py2,pz2),[],2);    
    mip=[mip b];
    
end;


