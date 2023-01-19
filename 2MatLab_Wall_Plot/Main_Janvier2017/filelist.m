function sortlist=filelist(path,ext,ext2)

list=dir(path);
j=0;
for i=1:length(list)
    if ( ~isempty(strfind(list(i).name,ext))...
            ||~isempty(strfind(list(i).name,upper(ext))) )...
            && (isempty(strfind(list(i).name,'thumb')))...
            && ( ~isempty(strfind(list(i).name,ext2)))
        j=j+1;
        sortlist(j).name=list(i).name;
    end;
end;

if (exist('sortlist','var')==0)
    disp('..........No Data.........')
    sortlist='';
end;