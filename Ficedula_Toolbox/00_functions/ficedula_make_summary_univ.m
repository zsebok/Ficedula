function ficedula_make_summary_univ(path_data)

%make summary table for categories
load([path_data 'results_categorized_univ.mat'])
db=results_categorized_univ;
db_cat=unique([db{:,end}]);
 
recs=unique(db(:,2));
for rec1n=1:length(recs)
    rec1=recs(rec1n);
    db1=db(strcmp(db(:,2),rec1),:);
    db1_cat=[db1{:,end}];
    table(rec1n,:) = histc(db1_cat,1:max(db_cat));
end

rowsum_cat=sum(table>0,2);
rowsum_syll=sum(table,2);
colsum_ind=sum(table>0,1);
colsum_syll=sum(table,1);
cats={};
for catsn=1:size(table,2)
    cats=[cats {['cat' num2str(catsn)]}];
end
xls1=num2cell([table rowsum_cat rowsum_syll; colsum_ind NaN NaN; colsum_syll NaN NaN]);
xls1_hdr1=[recs; {'sum of individuals'};{'sum of syllables'}];
xls1_hdr2=[{'recording'}  cats {'sum of categories'} {'sum of syllables'}];
xls2=[xls1_hdr2;xls1_hdr1 xls1];
cell2csv([path_data 'summary_on_universal_categories.csv'],xls2);
