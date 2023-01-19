function x=circle_mask(im,x0,y0,R)

[u,v]=size(im);
[x,y]=meshgrid((1:u),(1:v));

mask=(x-x0).^2+(y-y0).^2<R.^2;
im=im.*mask;

x=sum(sum(im))/(pi*R^2);
