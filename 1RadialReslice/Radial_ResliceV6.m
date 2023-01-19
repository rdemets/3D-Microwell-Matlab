close all
clear;
clc
%%%%%%% Average the Radial reslice for the different region
%%%%%%% Background Substract Sub=mean(Image((1:10,1:10,:))


%Folder with data
dirname1=uigetdir('/Users/nus/Desktop/PostDoc Singapore/Data/Fixed/Microwell/12h','Please select Channel1 folder');
%dirname2=uigetdir('/Users/richarddemets/Desktop/PostDoc Singapore/Data','Please select Actin folder');
files1 = dir(strcat(dirname1,'/*.tif'));
%files2 = dir(strcat(dirname2,'/*.tif'));
file_list1 = {files1.name};
%file_list2 = {files2.name};

%disp([num2str(length(file_list)),' text files found.']);
j=1;
for i=1:length(file_list1)
    if findstr('GFP',file_list1{i})
        textCell{j}=file_list1{i};
        j=j+1;
    end
end
j=1;

for i=1:length(file_list1)
    if findstr('RFP',file_list1{i})
        textRFP{j}=file_list1{i};
        j=j+1;
    end
end
j=1;
for i=1:length(file_list1)
    if findstr('far',file_list1{i})
        textAct{j}=file_list1{i};
        j=j+1;
    end
end



fid1=fopen(fullfile(dirname1,'Results_MeanSignal.txt'),'a');
fprintf(fid1,'Channel1 \t Mean Contour \t Mean Membrane \t Mean Cytoplasm \t Mean Top \t Mean Side \t Mean Bottom\t \t Channel2 \t Mean Contour \t Mean Membrane \t Mean Cytoplasm \t Mean Top \t Mean Side \t Mean Bottom\t \t Channel3 \t Mean Contour \t Mean Membrane \t Mean Cytoplasm \t Mean Top \t Mean Side \t Mean Bottom\n');

%% Loop

for a=1:size(textCell,2)
    filepath=strcat(dirname1,'/',textCell{a});
    Actpath=strcat(dirname1,'/',textAct{a});
    RFPpath=strcat(dirname1,'/',textRFP{a});
    Cell=imread(filepath); %GFP
    Act=imread(Actpath);
    RFP=imread(RFPpath);
    disp(['Cell ',num2str(a),' sur ',num2str(size(textCell,2))]);
%    pathMask=strcat(dirname1,'/Mask',textCell{a}(5:end-4),'.mat');
% If Act and Mask are numerated in a different way : Uncomment this
    if a<10
        pathMask=strcat(dirname1,'/Mask00',num2str(a),'.mat');
    else 
        pathMask=strcat(dirname1,'/Mask0',num2str(a),'.mat');
    end

 %% 
 if size(Act,1)==size(Cell,1) %if Cell and actin images don't have the same size
     if size(Act,2)==size(Cell,2) % not analysed
         if exist(pathMask) %If Mask exist
            Masktemp=load(pathMask);
            Mask=Masktemp.Mask;
         else %else, draw it
            h1=figure('units','normalized','outerposition',[0 0 1 1]);
            
            %%%%%%%%% To modify according to the Actin Channel
            %%% Cell, RFP, Act
            imshow(RFP,[min(min(RFP)) max(max(RFP))])
            %%%%%%%%%
            
            Cont=roipoly;
            Mask=imfill(Cont,'holes');
            hfig=figure;
            imshow(Mask)
            if a>9
                Nom=strcat(dirname1,'/Mask0',num2str(a),'.mat');
            else
                Nom=strcat(dirname1,'/Mask00',num2str(a),'.mat');
            end
            save(Nom,'Mask');
            close(hfig);
            close(h1);
         end


%% Zone selection
            strelfactor=5;
            se=strel('disk',strelfactor);
            Cyto=logical(imerode(Mask,se));
            ContourMask=logical(Mask-Cyto);
            [row,col] = find(ContourMask);
            Minrow=min(row);
            Maxrow=max(row);
            Mincol=min(col);
            Maxcol=max(col);      
            %% Bottom

            TempBottom=zeros(size(Mask,1),size(Mask,2));
            TempBottom(Maxrow-4:end,:)=1;
            Bottom=logical(TempBottom.*ContourMask); 
            ContourMask=ContourMask-Bottom;
            %% Left and right
            TempSide=zeros(size(Mask,1),size(Mask,2));
            TempSide(:,1:Mincol+5)=1;
            TempSide(:,Maxcol-5:end)=1;
            Side=logical(TempSide.*ContourMask);
            ContourMask=ContourMask-Side;
            %% Top
            Top=logical(zeros(size(Mask,1),size(Mask,2)));
            Top(1:round(2*size(ContourMask,1)/3),:)=ContourMask(1:round(2*size(ContourMask,1)/3),:); 
            ContourMask=ContourMask-Top;
            Side=logical(Side+ContourMask);
            clear ContourMask
            ContourMask=logical(Top+Side+Bottom);
            %% Affichage
            Image=double(Cell);
            ImageRGB=zeros([size(Image) 3]);

            Itemp=Image/max(Image(:));
            Itemp(Cyto)=1;
            Itemp(Top)=1;
            ImageRGB(:,:,1)=Itemp;
            ImageRGB(:,:,2)=Image/max(Image(:));
            Itemp3=Image/max(Image(:));
            Itemp3(Bottom)=1;
            ImageRGB(:,:,2)=Itemp3;
            Itemp2=Image/max(Image(:));
            Itemp2(Side)=1;
            Itemp2(Top)=1;
            ImageRGB(:,:,3)=Itemp2;
            hseg=figure('Name','Image segmentation');
            figure(hseg)
            imshow(ImageRGB),title('Top:Purple,Bottom:Green,Side:Blue,Cyto,Red')
            Nom=strcat(dirname1,'/Cell',num2str(a),'_fig.fig');
            saveas(hseg,Nom);
            close(hseg);


            %% Measure mean intensity in the two regions
            Membrane=ContourMask-Bottom;
            CompteurMembrane=sum(sum(Membrane)); % Nbrs of pixel in Contour without bottom
            CompteurContour=sum(sum(ContourMask)); % Nbrs of pixel in Contour
            CompteurCyto=sum(sum(Cyto)); %Nbrs of pixel in Cyto
            CompteurTop=sum(sum(Top)); %Nbrs of pixel in Top
            CompteurSide=sum(sum(Side)); %Nbrs of pixel in Side
            CompteurBottom=sum(sum(Bottom)); %Nbrs of pixel in Bottom
            
            for k=1:3
                if k==1
                    Celltemp=imread(filepath);
                    %Cell=imread(filepath);
                elseif k==2
                    Celltemp=imread(RFPpath);
                    %Cell=imread(RFPpath);
                elseif k==3
                    Celltemp=imread(Actpath);
                    %Cell=imread(Actpath);
                end
                %% Normalisation by background substraction
                Background=mean(mean(Celltemp(1:10,1:10,:)));
                Cell(:,:,:)=Celltemp(:,:,:)-Background;
                %% Normalisation by total intensity of the contour
                TotalIntContour=sum(sum(double(Cell).*double(ContourMask)));
                CellNorm=double(Cell)/TotalIntContour;
%%%%%%%% Normalisation par rapport a la taille de la region a faire ne pas
%%%%%%%% oublier Mean * AreaTot / Area Zone
%%
                MeanMb=sum(sum(CellNorm.*Membrane))*CompteurContour/CompteurMembrane; %Adapt to image cell type
                MeanContour=sum(sum(CellNorm.*ContourMask)); %Adapt to image cell type
                MeanCyto=(sum(sum(double(Cell).*Cyto))/CompteurCyto)/(sum(sum(double(Cell).*ContourMask))/CompteurContour); %Mean intensity cyto/contour
                %MeanCyto=MeanCytoTemp*CompteurContour/CompteurCyto;
                %MeanTop1=sum(sum(CellNorm.*Top));
                MeanTop1=sum(sum(CellNorm.*Top))/CompteurTop;
                %MeanSide1=sum(sum(CellNorm.*Side));
                MeanSide1=sum(sum(CellNorm.*Side))/CompteurSide;
                %MeanBottom1=sum(sum(CellNorm.*Bottom));
                MeanBottom1=sum(sum(CellNorm.*Bottom))/CompteurBottom;
                Sum1=MeanTop1+MeanSide1+MeanBottom1;
                MeanTop=MeanTop1*1/Sum1;
                MeanSide=MeanSide1*1/Sum1;
                MeanBottom=MeanBottom1*1/Sum1;
%%
%                 disp(['Mean Contour : ',num2str(MeanContour)]);
%                 disp(['Mean Cytoplasm : ',num2str(MeanCyto)]);
                fprintf(fid1,['Cell%g\t %g\t %g\t %g\t %g\t %g\t %g\t \t'],a,MeanContour,MeanMb,MeanCyto,MeanTop,MeanSide,MeanBottom);
                if k==3
                    fprintf(fid1,'\n');
                end
            end
            %clear Cell Bottom Cyto Top Side ContourMask Cont
            clc;
     end
 end
end


