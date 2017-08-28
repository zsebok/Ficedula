function ordered_sylls=csoportositas_sort_by_distances(matrix,sylls,syll)

data1=matrix(syll,:);
for i=1:length(sylls)

    dist(i)=pdist([data1;matrix(sylls(i),:)]);

end
[sv, si]=sort(dist);
ordered_sylls=sylls(si);