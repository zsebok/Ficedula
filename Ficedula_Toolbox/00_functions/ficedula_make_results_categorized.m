function ficedula_make_results_categorized(path_data)

load([path_data 'database_syllables_measured.mat'])

data_all=database_syllables_measured;
recs=(unique(data_all(:,2)))';
data_all2=[];
for rec=recs
    cat={};
    data_rec=data_all(strcmp(data_all(:,2),rec),:);
    col_cat=size(data_rec,2)+1;
    load([path_data rec{1} '.mat'])
   
    for j=1:size(cat,1)
        cat1=cat{j,2};
        for k=1:length(cat1)
            data_rec{cat1(k),col_cat}=j;
        end
    end
    data_all2=[data_all2;data_rec];
end

% put NaN for uncategorized syllable
 for i=1:size(data_all2,1)
     if isempty(data_all2{i,end})
         data_all2{i,end}=NaN;
     end
 end
results_categorized=data_all2;
 save([path_data 'results_categorized.mat'],'results_categorized')
 
 