function ficedula_univ_database_maker(path_data) 

load([path_data 'results_categorized.mat'])
data0=results_categorized;
inds=unique(data0(:,2));
data2={};
data3={};
n_cat=0;
for ind1=inds'
    data1=data0(strcmp(data0(:,2),ind1{1}),:);
    sylls_all=[data1{:,14}];
    sylls_cat=sylls_all(~isnan(sylls_all));
    cats=unique(sylls_cat);
    for cat1=cats
        n_cat=n_cat+1;
        data11=data1(sylls_all==cat1,1:end-1);
        data12=[data11(1,1:8), num2cell(mean(cell2mat(data11(:,9:end)),1))];
        data13=[data12 n_cat {data1(sylls_all==cat1,:)}];
        
        data2=[data2;data12];
        data3=[data3;data13];
    end
end
database_syllables_measured_univ=data2;
save([path_data 'database_syllables_measured_univ.mat'],'database_syllables_measured_univ')
database_syllables_measured_univ_allinfo=data3;
save([path_data 'database_syllables_measured_univ_allinfo.mat'],'database_syllables_measured_univ_allinfo')
