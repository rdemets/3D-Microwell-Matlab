clc;
clear all;
close all;
path='/Users/zheweng/Documents/MATLAB/Circle_fit_new/a2_w2488 CSU_s7_t7.TIF';
pathout='/Users/zheweng/Documents/MATLAB/Circle_fit_new/Wall/Wall_s7_t7.TIF'; 
 
dx=0.169;
dz=0.5;
dr=0.1;   %%%   +/- pourcentage of the radius

%%%%%%%%%%%%%%%%%%%
voxel=dz/dx;
a=mtifread(path);
im=max(a,[],3);

figure(1)
hold on
imagesc(im)
axis equal

[x0,y0]=ginput(3);
% x0=[64 122 60];
% y0=[54 94 112];

[xc,yc,R,~]=circfit(x0,y0);
[x1,y1]=circle(xc,yc,R,100);

line(x1,y1,'color','k')

wall=ringz(a,xc,yc,R,dr,voxel);

% abc = wall - 1;
% bcd = unit16(abc);
%imwrite(abc,pathout)



%wall=wall/max(max(wall));
% normalize the image from 0-1,
% final image is 8 -bit

%wall_16 = im2uint16(wall);
%wall_16 = uint16(round(wall*65535));
%wall = uint16(wall - 1);
% convert an intensity image from double to unit16
%wall_16 = unit16(wall);

% wall_161 = uint16(wall-1);
% imwrite(wall_161,pathout1)

figure(2)
imagesc(wall)
axis equal

wall_16 = uint16(wall);
% convert an intensity image from double to unit16

imwrite(wall_16,pathout)


%imwrite(uint16(wall),pathout)




