clear
load eredmeny

%%

n=0;

for song=1:length(eredmeny)
    song
    e=eredmeny(song);
    s=e.filenev;
    vs=strfind(s,'_');
    year=s(1:(vs(1)-1));
    ID=s((vs(1)+1):(vs(2)-1));
    songnum=s((vs(2)+1):(end-4));
    Fs=e.Fs;
    recID=s(1:(vs(2)-1));
   
    for j=1:length(e.x1)
       n=n+1;
       database_syllables(n,:)={s year ID songnum Fs e.x1(j) e.x2(j) 2000 20000 {} recID};
    end
end

inds0=unique(database_syllables(:,11));
inds=inds0(randperm(length(inds0)));
save inds inds
save database_syllables database_syllables

