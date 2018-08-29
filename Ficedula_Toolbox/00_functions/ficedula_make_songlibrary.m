function ficedula_make_songlibrary(path_in,path_out,path_data,results_songcut_filename)

warning off
load(results_songcut_filename)
res=results_songcut;
songlibrary={};

for rec=1:length(res)
    file=res(rec).filenev;
    dir1=[path_out file(1:end-4)];
    mkdir(dir1)
    
    info1 = audioinfo([path_in file]);
    siz=info1.TotalSamples;
    
    for song=1:length(res(rec).x1)
        
        N1=floor(res(rec).x1(song));
        if N1<1; N1=1; end
        N2=floor(res(rec).x2(song));
        if N2>siz; N2=siz; end
            
        [y,Fs]=audioread([path_in file],[N1 N2]);
        
        filename_out=sprintf('%03d',song);
       
        audiowrite([dir1 '\' file(1:end-4) '_' filename_out '.wav'],y(:,1),Fs)
       
        songlibrary=[songlibrary;{dir1} {file} {[file(1:end-4) '_' filename_out '.wav']} {N1/Fs} {N2/Fs}];
        
    end
end
songlibrary=[{'folder'} {'orig_filename'} {'songfile'} {'start'} {'end'};songlibrary];

save([path_data 'songlibrary.mat'],'songlibrary')
cell2csv([path_data 'songlibrary.csv'],songlibrary,',')