clc
clear all
close all
folders=uipickfiles('FilterSpec','/Users/richarddemets/Desktop/PostDoc Singapore/Data');
fid1=fopen(fullfile(folders{1},'resultats_fit_Begin.txt'),'a');
fid2=fopen(fullfile(folders{1},'resultats_fit_Middle.txt'),'a');
fid3=fopen(fullfile(folders{1},'resultats_fit_End.txt'),'a');

fprintf(fid1,'Cell \t Amplitude(a.u.) \t Centre(px) \t Half-width(px) \t Offset(a.u) \t R-fit\n');
fprintf(fid2,'Cell \t Amplitude(a.u.) \t Centre(px) \t Half-width(px) \t Offset(a.u) \t R-fit\n');
fprintf(fid3,'Cell \t Amplitude(a.u.) \t Centre(px) \t Half-width(px) \t Offset(a.u) \t R-fit\n');

disp([num2str(length(folders)),' folders selected.']);

%% Major Loop
for l=1:length(folders)
    %%
    dirname=folders{l};
    files = dir(strcat(dirname,'/*.txt'));
    file_list = {files.name};
    disp([num2str(length(file_list)),' text files found.']);

    %Copy Begin/Middle/End for each cells in a different matrix
    jBeg=1;
    jMid=1;
    jEnd=1;
    for i=1:length(file_list)
        if strncmp(file_list{i},'Begin',5)
            textFileBegin{jBeg}=file_list{i};
            jBeg=jBeg+1;
        end
        if strncmp(file_list{i},'Mid',3)
            textFileMiddle{jMid}=file_list{i};
            jMid=jMid+1;
        end
        if strncmp(file_list{i},'End',3)
            textFileEnd{jEnd}=file_list{i};
            jEnd=jEnd+1;
        end    
    end

%%
%Charge datas from the txt file
    filename=strcat(dirname,'/',textFileBegin{1});
    [xTemp yTemp]=textread(filename,'%f %f');
    Begin(1,:)=yTemp;
    
    filename=strcat(dirname,'/',textFileMiddle{1});
    [xTemp yTemp]=textread(filename,'%f %f');
    Middle(1,:)=yTemp;

    filename=strcat(dirname,'/',textFileEnd{1});
    [xTemp yTemp]=textread(filename,'%f %f');
    End(1,:)=yTemp;



%cftool;

%% Fit Maison


%Gaussian function + offset
%a1*exp(-((x-b1)/c1)^2)+d1
%% Begin of stack
    GaussianOffset = fittype(@(a, b, c, d, x, y) a*exp(-((x-b)/c).^2)+d, 'coefficients', {'a', 'b', 'c', 'd'}, 'independent', {'x'}, 'dependent', {'y'});
    x=[1:size(Begin,2)];    
    [Result gof] = fit(x', Begin', GaussianOffset, ...
        'StartPoint', [300, 100, 30, 100], ...
        'Lower', [0, 0, 0, 0], ...
        'Upper', [Inf, 200, 100, Inf], ...
        'Robust', 'LAR' );
%% Figure
    h=figure;
    Name=strcat('Cell ',num2str(l));
    plot(Begin,'*r')
    hold on
    plot(Result,'-b')
    legend(Name,'Fit')
    hold off
    saveas(h,[folders{l},'_Begin_Fit.fig']);
    Cfinal=1.66*Result.c;
    %fprintf(fid,[cellname,'\t',imname,'\t %o \t %g \t %g \t %g  \t %g \t %g \t %g  \t %g \t %g \t %g  \t %g \n'],uint8(corr_pb),tniv_cyto,tnFA(1),tnFA(2),tnFA(3),tnFA(4),varI_cyto,varI(1),varI(2),varI(3),varI(4));
    fprintf(fid1,['%s \t %f \t %f \t %f \t %f \t %f \n'],Name,Result.a,Result.b,Cfinal,Result.d,gof.rsquare);
close(h);

%% Middle of stack
    x=[1:size(Middle,2)];    
    [Result gof] = fit(x', Middle', GaussianOffset, ...
        'StartPoint', [300, 100, 30, 100], ...
        'Lower', [0, 0, 0, 0], ...
        'Upper', [Inf, 200, 100, Inf], ...
        'Robust', 'LAR' );
%% Figure
    h=figure;
    Name=strcat('Cell ',num2str(l));
    plot(Middle,'*r')
    hold on
    plot(Result,'-b')
    legend(Name,'Fit')
    hold off
    saveas(h,[folders{l},'_Middle_Fit.fig']);
    Cfinal=1.66*Result.c;
    %fprintf(fid,[cellname,'\t',imname,'\t %o \t %g \t %g \t %g  \t %g \t %g \t %g  \t %g \t %g \t %g  \t %g \n'],uint8(corr_pb),tniv_cyto,tnFA(1),tnFA(2),tnFA(3),tnFA(4),varI_cyto,varI(1),varI(2),varI(3),varI(4));
    fprintf(fid2,['%s \t %f \t %f \t %f \t %f \t %f \n'],Name,Result.a,Result.b,Cfinal,Result.d,gof.rsquare);
close(h);

%% End of stack
    x=[1:size(End,2)];    
    [Result gof] = fit(x', End', GaussianOffset, ...
        'StartPoint', [300, 100, 30, 100], ...
        'Lower', [0, 0, 0, 0], ...
        'Upper', [Inf, 200, 100, Inf], ...
        'Robust', 'LAR' );
%% Figure
    h=figure;
    Name=strcat('Cell ',num2str(l));
    plot(End,'*r')
    hold on
    plot(Result,'-b')
    legend(Name,'Fit')
    hold off
    saveas(h,[folders{l},'_End_Fit.fig']);
    Cfinal=1.66*Result.c;
    %fprintf(fid,[cellname,'\t',imname,'\t %o \t %g \t %g \t %g  \t %g \t %g \t %g  \t %g \t %g \t %g  \t %g \n'],uint8(corr_pb),tniv_cyto,tnFA(1),tnFA(2),tnFA(3),tnFA(4),varI_cyto,varI(1),varI(2),varI(3),varI(4));
    fprintf(fid3,['%s \t %f \t %f \t %f \t %f \t %f \n'],Name,Result.a,Result.b,Cfinal,Result.d,gof.rsquare);
close(h);

end
fclose(fid1);
fclose(fid2);
fclose(fid3);

