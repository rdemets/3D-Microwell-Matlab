clc;
clear all;
close all;

lp                                               %%%     load path for data
filename='Endoscopy';                 %%%     filename

dx=0.08;                                   %%%    pixel size (?)
dz=0.3;                                     %%%    delta z (?)
delta=0.10;                                %%%   +/- pourcentage of the radius for projection

ch1='488';                                  %%%    wavelength channel 1
ch2='647';                                  %%%    wavelength channel 2
ch3='561';

%%%%%%%%%%%%%%%%%%%%
 
voxel=dz/dx;                              %%% aspect ratio for proper image scaling
list=filelist(path0,ch1,'.tif');           %%%   list of files in the directory

if ~exist([path0 'x/']) 
    mkdir([path0 'x/']);
end;

for p=1:length(list);
%for p=47:62;
p
%%%%%%%%%%%%%%%%%%
a=mtifread([path0 filename '_' ch2 '_p' num2str(p) '.tif']);
im1=sum(a,3);
th=threshold(im1,99);

[x0,y0,R]=fit_circle_wall(im1,th);

%%%%%%%%%%%%%%%%%

[x1,y1]=circle(x0,y0,(1-delta)*R,100);
[x2,y2]=circle(x0,y0,(1+delta)*R,100);

path1=[path0 filename '_' ch1 '_p' num2str(p) '.tif'];
path647=[path0 filename '_' ch2 '_p' num2str(p) '.tif'];
path561=[path0 filename '_' ch3 '_p' num2str(p) '.tif'];
a=mtifread(path1);
b=mtifread(path647);
c=mtifread(path561);
im2=max(a,[],3);
  im561 = max(b,[],3);


f=figure(1);
set(f,'position',[200,350,350,350])
set(axes,'position',[0 0 1 1])
hold on
imagesc(im2)

line(x1,y1,'color',[1 0 1],'linewidth',2,'linestyle',':')
line(x2,y2,'color',[1 0 1],'linewidth',2,'linestyle',':')
axis equal

mean_bottom=circle_mask(im2,x0,y0,(1-delta)*R);

mip=mip_wall(a,x0,y0,R,delta,voxel);
mip647=mip_wall(b,x0,y0,R,delta,voxel);
mip561=mip_wall(c,x0,y0,R,delta,voxel);
[u,v]=size(mip);


bg=mean(mean(im2(1:40,1:40)));
ind=find(mip>bg);
mean_wall=mean(mean(mip.*(mip>bg)));

ratio=(mean_wall-bg)/(mean_bottom-bg);

g=figure(2);
set(g,'position',[100,150,0.5*v,0.5*u]);
set(axes,'position',[0 0 1 1])
imagesc(mip)
axis equal

dlmwrite([path0 'x/p' num2str(p) '.txt'],[x0 y0 R delta ratio dx dz]');

th=max(max(max(a)));

%  im2 = uint16(im2);
%  im561 = uint16(im561);
im2 = im2/th;
im561 = im561/th;
imwrite(im2,[path0 'x/bottom_p' num2str(p) '.tif']);
imwrite(im561,[path0 'x/bottom561_p' num2str(p) '.tif']);


%  mip = uint16(mip); 
%  mip647 = uint16(mip647);
%  mip561 = uint16(mip561);
mip = mip/th;
mip647 = mip647/th;
mip561 = mip561/th;

% mip647 = mip647/th;
imwrite(mip,[path0 'x/wall_488_p' num2str(p) '.tif']);
imwrite(mip647,[path0 'x/wall_647_p' num2str(p) '.tif']);
imwrite(mip561,[path0 'x/wall_561_p' num2str(p) '.tif']);

% pause;

end;







