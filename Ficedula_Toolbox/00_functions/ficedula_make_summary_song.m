function ficedula_make_summary_song(path_data)

load([path_data 'results_categorized.mat'])
load([path_data 'songlibrary.mat'])
songlibrary=songlibrary(2:end,:);

data_all=results_categorized;
recs=(unique(data_all(:,2)))';
recnum=0;
rectable={};
songnum=0;
for rec=recs
    recnum=recnum+1;
    
    %based on songlibrary
    data_rec=songlibrary(strcmp(songlibrary(:,2),[rec{1} '.wav']),:);
    
    songs=unique(data_rec(:,3));
    [sv,si]=sort(data_rec(:,3));
    data_rec=data_rec(si,:);
    
    song_start=[data_rec{:,4}];
    song_end=[data_rec{:,5}];
    
    song_intervals=song_start(2:end)-song_start(1:end-1);
    song_durations=song_end-song_start;
    if isempty(song_intervals); song_intervals=NaN; end
        
    %repertoire size
     data_rec2=data_all(strcmp(data_all(:,2),rec),:);
    sylls_all=[data_rec2{:,14}];
    sylls_all_cat=sylls_all(~isnan(sylls_all));
    
    sylls_num=length(sylls_all_cat);
    rep_size=length(unique(sylls_all_cat));
    numberofsongs=length(songs);
    
    rectable(recnum,:)=[{data_rec{1,2}(1:end-4)} sylls_num rep_size numberofsongs...
        mean(song_intervals) std(song_intervals)...
        median(song_intervals) min(song_intervals) max(song_intervals)...
        mean(song_durations) std(song_durations)...
        median(song_durations) min(song_durations) max(song_durations)];
    
   
    %based on syllable table
   
    songs2=unique(data_rec2(:,1));
   
    for song1=songs2'
        songnum=songnum+1;
        data_song=data_rec2(strcmp(data_rec2(:,1),song1),:);
        
        song_sylls_all=[data_song{:,14}];
        v_cat=find(~isnan(song_sylls_all));
        song_sylls_cat=song_sylls_all(v_cat);
        
        song1_rec(songnum,1:2)=data_song(1,1:2);
        %song syllnumber
        song1_syllnum(songnum,1)=length(song_sylls_cat);
        
        %song versatility
        song1_versatility(songnum,1)=length(unique(song_sylls_cat));
        
        %song measurements
        song1_meas=cell2mat(data_song(v_cat,9:end-1));
        
        song1_min(songnum,:)=min(song1_meas);
        song1_max(songnum,:)=max(song1_meas);
        song1_mean(songnum,:)=mean(song1_meas);
        
    end
    
end

hdr0={};
for i=1:size(song1_min,2);hdr0=[hdr0 ['measurement_' num2str(i) '_mean']];end
for i=1:size(song1_min,2);hdr0=[hdr0 ['measurement_' num2str(i) '_min']];end
for i=1:size(song1_min,2);hdr0=[hdr0 ['measurement_' num2str(i) '_max']];end


  
songtable=[song1_rec num2cell([song1_syllnum,song1_versatility,song1_mean,song1_min,song1_max])];
songtable_hdr=[{'songfile', 'recording','number_syllable','versatility'},hdr0];
rectable_hdr={'recording','number_sylls','repertoiresize','number_song','songinterval.mean','songinterval.sd','songinterval.median',...
    'songinterval.min','songinterval.max',...
    'songduration.mean','songduration.sd','songduration.median',...
    'songduration.min','songduration.max'};

rectable=[rectable_hdr;rectable];
songtable=[songtable_hdr;songtable];

cell2csv([path_data 'summary_on_recordings.csv'],rectable);
cell2csv([path_data 'summary_on_songs.csv'],songtable);
