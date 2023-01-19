clc;
clear all;
close all;
lp   

filename='wall';
ch1 = '488';                                 
%ch2 = '561';                               
ch3 = '647';

list=filelist(path0,ch1,'.tif');           %%%   list of files in the directory

if ~exist([path0 'y_plot/']) 
    mkdir([path0 'y_plot/']);
end;


for p=18:18;
%for p=34:length(list);
    p
    path1=[path0 filename '_' ch1 '_p' num2str(p) '.tif'];
    %path2=[path0 filename '_' ch2 '_p' num2str(p) '.tif'];
    path3=[path0 filename '_' ch3 '_p' num2str(p) '.tif'];
    
    A = imread(path1);
    %B = imread(path2);
    C = imread(path3);
    
    a_size = size(A);
    %b_size = size(B);
    c_size = size(C);
    
    
    for i = 1:a_size(1)
        a(i) = mean(A(i,:));
    end
     
     a_n = a/min(a);
     a_n = fliplr(a_n);
     
%     for j = 1:a_size(1)
%         b(j) = mean(B(j,:));
%     end
%     
%      b_n = b/min(b);
%      b_n = fliplr(b_n);
     
     for k = 1:c_size(1)
         c(k) = mean(C(k,:));
     end
     
     
     c_n = c/max(c);
     c_n = fliplr(c_n);
 
     x = linspace(1,a_size(1),a_size(1));
     x = x/13.86;
     
     h = figure;
     plot(x,a_n,'g',x,c_n,'c');
     hleg1 = legend('E-cad-GFP','Wall');
     set(hleg1,'Location','NorthEast')
     set(hleg1,'Interpreter','none')
     
     xlabel('Bottom to Top(Micron)');
     ylabel('Normalized Intensity');
     % saveas(h,'yplot_p3','jpeg');
     saveas(h,[path0 'y_plot/yplot_p' num2str(p)],'jpeg');
     dlmwrite([path0 'y_plot/yplot_p' num2str(p) '.txt'],[x a a_n c c_n]);  
     
end
    


    
    