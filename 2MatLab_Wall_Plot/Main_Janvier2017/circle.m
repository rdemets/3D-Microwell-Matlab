function [x,y]=circle(x0,y0,r,n)

i=linspace(0,2*pi,n);
x=x0+r*cos(i);
y=y0+r*sin(i);
