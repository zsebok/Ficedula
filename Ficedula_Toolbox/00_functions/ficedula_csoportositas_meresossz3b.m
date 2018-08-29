function [data,matrix]=ficedula_csoportositas_meresossz4(rows,path_songs,path_data)


col_start=5;
col_end=6;

cols_measurements_start=9;

load([path_data 'database_syllables_measured.mat'])

database_syllables=database_syllables_measured;

v=rows;
n=0;

for syll=1:length(v)
    syll
    
    db=database_syllables(v(syll),:);
    filename=[db{2} '\' db{1}];
    [y,Fs]=audioread([path_songs '\' filename]);
    
    n=n+1;
    
    N1=floor(db{col_start});
    if N1<1; N1=1; end
    N2=floor(db{col_end});
   
    
    data1=csoportositas_meres_rajz3b(y,Fs,N1,N2);
    data(n).P=data1.P;
    data(n).F=data1.F;
    data(n).T=data1.T;
    
    data(n).filename=ind1;
    data(n).syll=syll;
    data(n).Fs=Fs;
   
    data(n).rows=length(data1.F);
    matrix(n,:)=[db{cols_measurements_start:end}];
    
    %standardization
    min1=min(matrix);
    matrix=matrix-repmat(min1,size(matrix,1),1);
    max1=max(matrix);
    matrix=matrix./repmat(max1,size(matrix,1),1);
    
    data(n).N1=N1;
    data(n).N2=N2;
    data(n).y=y(N1:N2,1)/max(y(N1:N2,1))*0.9;
    
    
end
