function ordered_cat=csoportositas_sort_by_distances2(matrix,cat,syll)

data1=matrix(syll,:);

for i=1:size(cat,1)
    
    v=vertcat(cat{i,2});
    data=matrix(v,:);
    data_mean=mean(data,1);
    dist(i)=pdist([data1;data_mean]);

end
[sv, si]=sort(dist);
ordered_cat=(si);