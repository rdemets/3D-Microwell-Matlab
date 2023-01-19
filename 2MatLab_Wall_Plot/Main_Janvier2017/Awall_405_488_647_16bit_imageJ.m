clc;
clear all;
close all;



path0=uigetdir('/Users/nus/Desktop/PostDoc Singapore/Data/Fixed');
filename='GFP';                 %%%     filename

dx=0.06;                                   %%%    pixel size (?)
dz=0.3;                                     %%%    delta z (?)
dr=0.1;                                %%%   +/- pourcentage of the radius for projection
voxel=dz/dx;

ch2='RFP'; 
ch3='far-RED';
%ch4='Channel4';
% 
if ~exist([path0 '/Wall/']) 
    mkdir([path0 '/Wall/']);
end;


%list=filelist(path0,'.tif');
files = dir(strcat(path0,'/*.tif'));
file_list = {files.name};
jCh2=1;
jCh3=1;
%%
pas = input('Number of channel ? :');
%answer=str2num(answer);

%%
index=1;
for p=1:pas:length(file_list);
    fileCh1{index}=strcat(path0,'/',file_list{p});    
    fileCh2{index}=strcat(path0,'/',file_list{p+1});
    fileCh3{index}=strcat(path0,'/',file_list{p+2});
    index=index+1;
end

%for p=14:14;
%for p=1:length(fileCh3);
%pathtemp='/Users/richarddemets/Documents/MATLAB/Singapour/MatLab_Wall_Plot/Circle_fit_new/'
p=1;

for p=1:length(fileCh1)

a=mtifread(fileCh1{p}); %GFP
b=mtifread(fileCh2{p}); %RFP
c=mtifread(fileCh3{p}); %FarRed

%%%%%%%%%%%%%%
Test=fileCh2{p}(end-24:end);
disp(Test)
im=b(:,:,round(size(b,3)/2)); % Mettre le channel Actine
figure(1)
hold on
imagesc(im)
axis equal

%%%%%%%%%%%%%%



[x0,y0]=ginput(3);

[xc,yc,R,~]=circfit(x0,y0);
[x1,y1]=circle(xc,yc,R,100);

line(x1,y1,'color','r')

wall488=ringz(a,xc,yc,R,dr,voxel);
wall405=ringz(b,xc,yc,R,dr,voxel);
wall647=ringz(c,xc,yc,R,dr,voxel);




mip488 = wall488;
mip405 = wall405;
mip647 = wall647;

figure(2)
imagesc(mip488)
axis equal

%mip488=mip488/max(max(mip488));
%mip405=mip405/max(max(mip405));
%mip647=mip647/max(max(mip647));

mip488 = uint16(mip488);
mip405 = uint16(mip405);
mip647 = uint16(mip647);

%mkdir(fullfile(path0,'/Wall'));
imwrite(mip488,[path0 '/Wall/wall_GFP_p' num2str(p) '.tif']);
imwrite(mip405,[path0 '/Wall/wall_RFP_p' num2str(p) '.tif']);
imwrite(mip647,[path0 '/Wall/wall_far-RED_p' num2str(p) '.tif']);

end

