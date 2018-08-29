function ficedula_make_measurements(path_songs,path_data)

%adatbázisból másolja a matrix-ban található mérési eredményeket!
load([path_data 'database_syllables.mat'])

%path_songs='c:\_munka\__project_toolbox\02_make_songlibrary\';
col_start=5;
col_end=6;
col_minf=7;
col_maxf=8;

n=0;

for syll=1:size(database_syllables,1)
    syll
    
    db=database_syllables(syll,:);
    filename=[db{2} '\' db{1}];
    
    [y,Fs]=audioread([path_songs '\' filename]);
    y=y(:,1);
    
    n=n+1;
    
    N1=floor(db{col_start});
    N2=floor(db{col_end});
    if N1>N2;N1=floor(db{col_end});N2=floor(db{col_start}); end
    
    if N1<1; N1=1; end
    if N2>length(y); N2=length(y); end
    
    minf=db{col_minf};
    maxf=db{col_maxf};
        
    data1=ficedula_measurements1(y,Fs,N1,N2,minf,maxf);
    
    data(n).P=data1.P;
    data(n).F=data1.F;
    data(n).T=data1.T;
    
    data(n).filename=filename;
    data(n).syll=syll;
    data(n).Fs=Fs;
    data(n).row=length(data1.F);

    matrix(n,:)=data1.d;
        
    data(n).N1=N1;
    data(n).N2=N2;
    data(n).y=y(N1:N2,1)/max(y(N1:N2,1))*0.9;
    
    
end

%standardization
%min1=min(matrix);
%matrix=matrix-repmat(min1,size(matrix,1),1);
%max1=max(matrix);
%matrix=matrix./repmat(max1,size(matrix,1),1);

database_syllables_measured=[database_syllables num2cell(matrix)];
save([path_data 'database_syllables_measured.mat'], 'database_syllables_measured')
