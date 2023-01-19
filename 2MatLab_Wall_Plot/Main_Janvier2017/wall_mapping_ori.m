clc;
clear all;
close all;

path='/Users/zheweng/Desktop/test.tif'; 
pathout='/Users/zheweng/Desktop/test2.tif'; 
dx=0.25;
dz=0.5;
dr=0.25;   %%%   +/- pourcentage of the radius

%%%%%%%%%%%%%%%%%%%
voxel=dz/dx;
a=mtifread(path);
im=max(a,[],3);

info = imfinfo(path)

figure(1)
hold on
imagesc(im)
axis equal

% [x0,y0]=ginput(3);
% x0=[64 122 60];
% y0=[54 94 112];
% 
% [xc,yc,R,~]=circfit(x0,y0);
% [x1,y1]=circle(xc,yc,R,100);
% 
% line(x1,y1,'color','k')
% 
% wall=ringz(a,xc,yc,R,dr,voxel);
% wall=wall/max(max(wall));
% 
% figure(2)
% imagesc(wall)
% axis equal
% 
% imwrite(wall,pathout)
% 
% 
% 
% 
