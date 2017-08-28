function ordered_sylls=csoportositas_sort_by_distances3(matrix,sylls,syllsincat)

data1=mean(matrix(syllsincat,:),1);

for i=1:length(sylls)

    dist(i)=pdist([data1;matrix(sylls(i),:)]);
    
end
[sv, si]=sort(dist);
ordered_sylls=sylls(si);