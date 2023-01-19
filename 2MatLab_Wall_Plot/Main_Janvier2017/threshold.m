function thresh=threshold(a,seuil)

[u,v,w]=size(a);
thresh=prctile(reshape(a,1,u*v*w),seuil);