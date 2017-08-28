%function ficedula_make_results_univ_categorized(path_data)
clear
path_data='data_folder\';
%        params=ficedula_loadparams;
%% collect categories of univ groups
load([path_data 'database_syllables_measured_univ.mat'])
data_all=database_syllables_measured_univ;

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
results_categorized_univ=data_all2;
% save([path_data 'results_categorized.mat'],'results_categorized')
%% put univ categries into syllable table

load([path_data 'results_categorized.mat'])
data0=results_categorized;
inds=unique(data0(:,2));
data2={};
col_univ=size(data0,2)+1;
n_univ=0;
for ind1=inds'
    data1=data0(strcmp(data0(:,2),ind1{1}),:);
    sylls_all=[data1{:,end}];
    sylls_cat=sylls_all(~isnan(sylls_all));
    cats=unique(sylls_cat);
    for cat1=cats
        n_univ=n_univ+1;
        v=find(sylls_all==cat1);
        data1(v,col_univ)=results_categorized_univ(n_univ,end);

        %data12=[data11(:,1:end), repmat(results_categorized_univ(n_univ,:),size(data11,1),1)];
        

    end
    data2=[data2;data1];
end
results_categorized_univ=data2;
save results_categorized_univ results_categorized_univ
 