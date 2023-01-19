function [x0,y0,R]=fit_circle_wall(im,th)

[u,v]=size(im);
[u,v]=meshgrid((1:u),(1:u));

im=(im>th).*(im-th);
im0=10*im/max(max(im));

[y,x]=find(im0>0);
[ind]=find(im0>0);

X=[];
Y=[];

for i=1:length(ind)
    ind0=ind(i);
    for j=1:im0(ind0)
    X=[X x(i)];
    Y=[Y y(i)];
    end;       
end;

[x0,y0,R] = circfit(X,Y);
