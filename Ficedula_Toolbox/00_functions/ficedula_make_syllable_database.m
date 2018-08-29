function ficedula_make_syllable_database(path_data,resultsfilename)

load(resultsfilename)

n=0;
eredmeny=results;

for song=1:length(eredmeny)
    song
    e=eredmeny(song);
    s=e.filenev;
    vs=strfind(s,'_');
    
    ID=s(1:(vs(end)-1));
    songnum=s((vs(end)+1):(end-4));
    Fs=e.Fs;
   

    for syll=1:length(e.x1)
       n=n+1;
       database_syllables(n,:)={s ID songnum Fs e.x1(syll) e.x2(syll) e.y2(syll) e.y1(syll)};
    end
end

inds0=unique(database_syllables(:,2));
inds=inds0(randperm(length(inds0))); %randomizing recordings for clustering
save([path_data 'inds.mat'],'inds');
save([path_data 'database_syllables.mat'], 'database_syllables');

