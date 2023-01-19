clc
clear all
close all
dirname=uigetdir('/Users/nus/Desktop/PostDoc Singapore/Data/Fixed/Microwell/');
%% This program will show the distribution of the maximum of an intensity profile



dx=0.108;                                   %%%    pixel size (?)
dz=0.2;                                     %%%    delta z (?)
voxel=dx/2 ;                                 %%% Pixel cubique après wall plot

%% Charge the files
Images = dir(strcat(dirname,'/*.tif'));
image_list = {Images.name};
files = dir(strcat(dirname,'/*.txt'));
file_list = {files.name};

j=1;
for i=1:length(image_list)
    if strncmp(image_list{i},'wall',4)
        textImage{j}=image_list{i};
        j=j+1;
    end
end
j=1;
for i=1:length(file_list)
    if strncmp(file_list{i},'wall',4)
        textFile{j}=file_list{i};
        j=j+1;
    end
end

disp([num2str(size(textFile,2)),' text files found.']);
disp([num2str(size(textImage,2)),' images files found.']);

%%
% for i=1:size(textImage,2)
%     filename=strcat(dirname,'/',textImage{i});
%     Temp=imread(filename);
%     Temp2=mean(Temp,2);
%     
%     xi=1:1000; % Vector of interpolation with coordinate
%     x=linspace(0,1000,size(Temp2,1));
%     Interp=interp1(x,Temp2,xi,'spline'); % Vector interpolate to add in the image   
%     Data(i,:)=Interp(:)';
% end
% 
% %% Part1 : Find where is the maxima on the entire wall plot
% 
% [Max IndexGlobal]=max(Data'); %Maximum on all wall plot
% RatioGlobal=(size(Data,2)-IndexGlobal)/size(Data,2)*100;
% %% Plot the histogram of the position of the Max for each cell.
% 
% histglobal=figure;
% subplot(1,2,1)
% MeanRatio=mean(RatioGlobal);
% MedianRatio=median(RatioGlobal);
% hist(gca,RatioGlobal,40) %%%%%%%%%%%%% Change number of bins
% set(gca,'xlim',[0 100])
% set(gca,'view',[90 -90])
% %set(gca,'XDir','reverse');
% text('units', 'normalized','Position',[0.8 0.8],'String',...
%     sprintf('Mean : %g%% \n Median : %g%% \n',MeanRatio(1),MedianRatio(1)));
% text('units', 'normalized','Position',[0.8 0.9],'String',...
%     sprintf('Top'));
% text('units', 'normalized','Position',[0.8 0.1],'String',...
%     sprintf('Bottom'));
% xlabel('Normalized distance to the bottom (%)');
% ylabel('Count');
% 
% subplot(1,2,2)
% bplot(RatioGlobal);
% set(gca,'XDir','reverse');
% xlabel('BoxPlot')
% axis([-0.5 3 0 100])
% 
% 
% %% Save results
% fid1=fopen(fullfile(dirname,'Results_FullCell_hist_max.txt'),'a');
% fprintf(fid1,'Cell \t MaxPosition (%%) \n');
% 
% for i=1:size(RatioGlobal,2)
%     fprintf(fid1,['Cell %g\t %g\n'],i,RatioGlobal(1,i));
% end
% NomGlob=strcat(dirname,'/Hist_FullCell.fig');
% saveas(histglobal,NomGlob);
% close(histglobal);




%% Part 2, histogram of the maxima on small part of the image

fid2=fopen(fullfile(dirname,'Results_Column.txt'),'a');
fprintf(fid2,['Cell\t Mean\t Std\t Columns1-60\t \t 0-10\t 10-20\t 20-30\t 30-40\t 40-50\t 50-60\t 60-70\t 70-80\t 80-90\t 90-100\t RangeMax\t ColorCode\n']);
CompteurText=0;
itext=1;
% Loop for each cell
for i=1:size(textImage,2);
    path=strcat(dirname,'/',textImage{i});
    %% Load file for realignment
%     Temp=str2double(path(end-5:end-4));
%     if isnan(Temp)
%         NumCell=path(end-4);
%     else
%         NumCell=path(end-5:end-4);
%     end
    %path2=strcat(path(1:end-7),'roi.txt');
    %TextFileName=strcat(textFile{1}(1:end-5),NumCell,'.txt');
%    TextFileName=strcat(textFile{1}(1:end-5),NumCell,'.txt');
%    path2=strcat(dirname,'/',TextFileName);
    

    if CompteurText==3
        CompteurText=0;
        itext=itext+1;
    end
    CompteurText=CompteurText+1;
    path2=strcat(dirname,'/',textFile{itext});
    WallPlotTemp=imread(path);
%    [xAlign Number]=textread(path2,'%f %f');
    [xAlign Number]=textread(path2,'%f %f');
    maxNumber=max(Number);
    WallPlot=WallPlotTemp;

%     for h=1:size(xAlign,1) %Exclude 0
%         if xAlign(h)==0
%             xAlign(h)=1;
%         end
%         if xAlign(h)==size(WallPlotTemp,1) % Border Condition
%             xAlign(h)=xAlign(h)-1;
%         end
%         if Number(h)==0 %Exclude 0
%             Number(h)=1;
%         end
%         if h<size(xAlign,1) %Border condition
%             for b=xAlign(h):xAlign(h+1)
%                 Vector=WallPlotTemp(Number(h):size(WallPlotTemp,1),b); % Vector to interpolate
%                 xi=1:size(Vector,1)/size(WallPlot,1):size(WallPlot,1); % Vector of interpolation with coordinate
%                 x=1:size(Vector,1);
%                 InterTemp=interp1(x,double(Vector)',xi,'linear'); % Vector interpolate to add in the image
%                 WallPlot(:,b)=uint8(InterTemp(1:size(WallPlot,1)))';
%             end
%         end    
%     end
    for h=1:size(xAlign,1) %Exclude 0
        if xAlign(h)==0
            xAlign(h)=1;
        end
        if xAlign(h)==size(WallPlotTemp,1) % Border Condition
            xAlign(h)=xAlign(h)-1;
        end
        if Number(h)==0 %Exclude 0
            Number(h)=1;
        end
        if h<size(xAlign,1) %Border condition
            for b=xAlign(h):xAlign(h+1)
                Vector=WallPlotTemp(Number(h):size(WallPlotTemp,1),b); % Vector to interpolate
                xi=1:size(Vector,1)/size(WallPlot,1):size(WallPlot,1); % Vector of interpolation with coordinate
                x=1:size(Vector,1);
                InterTemp=interp1(x,double(Vector)',xi,'linear'); % Vector interpolate to add in the image
                WallPlot(:,b)=uint16(InterTemp(1:size(WallPlot,1)))';
            end
        end    
    end
%% Parameter to adjust :
    %gap=50; %Number of columns merged, change if needed
    gap=floor(size(WallPlot,2)/36); 
    l=1;
    IndexPart=zeros(floor(size(WallPlot,2)/gap),1); %Number of region analysed
    for val=0:35
        if val==0
            k=1;
        else
            k=gap*val;
        end
        Mean=mean(WallPlot(:,floor(k:(k+gap-1))),2);
        [Max Index]=max(Mean);
        IndexPart(l)=Index;
        l=l+1;
    end    
    %Convert height in pourcetange
    RatioPart=(size(WallPlot,1)-IndexPart)/size(WallPlot,1)*100; 
    meanRatioPart=mean(RatioPart);
    stdRatio=std(RatioPart);
    NomTemp=textImage{i};
    NomFinal=NomTemp(1:end-4);
    fprintf(fid2,['%s\t %f\t %f\t'],NomFinal,meanRatioPart,stdRatio);
    for j=1:size(RatioPart,1)
        fprintf(fid2,'%g\t',RatioPart(j));
    end
    
    %% Belt Criteria
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    Bin=10; % Range for each bin in %
    
    BeltCriteria=0;
    for r=1:100/Bin
        Bin1=find(RatioPart(:)>((r-1)*10) & RatioPart(:)<((r-1)*10+10));
        maxi=size(Bin1,1);
        fprintf(fid2,'%f\t',maxi);
        if maxi>BeltCriteria
            BeltCriteria=maxi;
            rang=r;
        end
    end
    
%%%%%%%%%%% Threshold value, if more 50% in one range, then belt
        if BeltCriteria>size(RatioPart,1)/100*50
            fprintf(fid2,'%g-%g\t',(rang-1)*10,rang*10);
            fprintf(fid2,'1\n');
            
        else
            fprintf(fid2,'%g-%g\t',(rang-1)*10,rang*10);
            fprintf(fid2,'0\n');
        end

    
%%%%%%%%%%%%%%%%%%%%
    %% Save hist images
    histo=figure('units','normalized','outerposition',[0 0 1 1]);
    subplot(2,2,[1 3])
    hist(gca,RatioPart,floor((max(RatioPart)-min(RatioPart))/2)) % Change number of bins
    set(gca,'xlim',[0 100])
    set(gca,'view',[90 -90])
    name=strcat('Cell ',num2str(i));
    title(name)
    subplot(2,2,2)
    imshow(WallPlotTemp,[min(min(WallPlotTemp)) max(max(WallPlotTemp))])
    hold on
    for o=1:size(xAlign)
        plot(xAlign(o),Number(o),'+y');
    end
    hold off
    title('RAW Cell');
    subplot(2,2,4)
    imshow(WallPlot,[min(min(WallPlotTemp)) max(max(WallPlotTemp))])
    title('Realign cell + Maxima');
    hold on
    n=1;
    for m=round(gap/2):gap:size(IndexPart,1)*gap
        plot(m,IndexPart(n),'+r');
        plot(n*gap,[1:10:size(WallPlot,1)],'.b','MarkerSize',2)
        n=n+1;
    end

    Nom=strcat(dirname,'/',NomFinal,'_hist.fig');
    saveas(histo,Nom);
    close(histo)
    %%
    %clear RatioPart IndexPart
end
fprintf(fid2,['\n\n\n']);
%fclose(fid1);
fclose(fid2);



