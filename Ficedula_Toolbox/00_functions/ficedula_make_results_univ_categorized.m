function ficedula_make_results_univ_categorized(path_data)

%% collect categories of univ groups
load([path_data 'database_syllables_measured_univ.mat'])
data_all=database_syllables_measured_univ;

data_all2=[];
cat={};
data_rec=data_all;
col_cat=size(data_rec,2)+1;
load([path_data 'universal.mat'])

for j=1:size(cat,1)
    cat1=cat{j,2};
    for k=1:length(cat1)
        data_rec{cat1(k),col_cat}=j;
    end
end
data_all2=[data_all2;data_rec];

% put NaN for uncategorized syllable
for i=1:size(data_all2,1)
    if isempty(data_all2{i,end})
        data_all2{i,end}=NaN;
    end
end
results=data_all2;


%% put univ categries into syllable table
load([path_data 'database_syllables_measured_univ_allinfo.mat'])
db=database_syllables_measured_univ_allinfo;
results_categorized_univ={};
for i=1:size(results,1)
    results_categorized_univ=[results_categorized_univ;db{i,15} repmat(results(i,14),size(db{i,15},1),1)];
end

save([path_data 'results_categorized_univ.mat'],'results_categorized_univ')