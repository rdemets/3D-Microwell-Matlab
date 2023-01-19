function stack=mtifread(file)

info = imfinfo(file);
num= numel(info);

if strfind(info(1).ColorType,'grayscale')
    stack=zeros(info(1).Height,info(1).Width,num);
else
     stack=zeros(info(1).Height,info(1).Width,num,3);
end;

for i=1:num
    stack(:,:,i,:)=imread(file,i);
 end