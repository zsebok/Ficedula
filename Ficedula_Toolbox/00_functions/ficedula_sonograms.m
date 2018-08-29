% initialization
clear
path_songs='song_library\';
path_data='data_folder\';

mkdir([path_data 'sonograms\by individual\'])
 

load([path_data 'results_categorized.mat'])
data0=results_categorized;
%%
%choose 1 recording
inds=unique(data0(:,2));
for ind1=inds'
    ind1
    rows=find(strcmp(data0(:,2),ind1));
    
    data2=ficedula_csoportositas_meresossz4(rows,path_songs,data0);
    
    %choose 1 syll from each category
    cats_all=[data0{rows,14}];
    cats_ok=find(~isnan(cats_all));
    cats_missing=find(isnan(cats_all));
    [cats]=unique(cats_all(cats_ok));
    
    sylls_n=0;
    clear sylls; clear sylls_name
    for cat1=cats
        sylls_n=sylls_n+1;
        v=find(cats_all==cat1);
        row_data0=rows(v(1));
        row_data2=v(1);
        sylls(sylls_n)=row_data2;
        sylls_name(sylls_n)=row_data0;
        sylls_cat(sylls_n)=cat1;
        sylls_width(sylls_n)=length(data2(row_data2).T);
    end
    
    %how many syllable? how many window?
    specrow=data2(1).rows(1);
    syll_row=5;
    
    syll_maxlength=max(sylls_width);
    
    xlim_max=8000;
    ylim_max=specrow*syll_row;
    
    syll_col=floor(xlim_max/syll_maxlength);
    syll_perpage=syll_col*syll_row;
    pagenum=ceil(sylls_n/syll_perpage);
    sylls_n_index=0;
    page_index=0;
    while sylls_n_index<sylls_n
        page_index=page_index+1;
        sylls_v=(sylls_n_index+1):(sylls_n_index+syll_perpage-1);
        if max(sylls_v)>sylls_n
            sylls_v=(sylls_n_index+1):sylls_n;
            sylls_n_index=sylls_n;
        else
            sylls_n_index=sylls_n_index+syll_perpage;
        end
        %  close all
        
        fig=figure('units','normalized','position',[0.1,0.1,0.7,0.8]);
        
        ax1=axes('parent',fig,'position',[0.05,0.05,0.9,0.9]);
        [P3,P3_2]=ficedula_csoportositas_abratabla3(data2,sylls(sylls_v),syll_row);
        h=surf(P3,'edgecolor','none','parent',ax1);
        view(2); grid off; axis off
        xlim([1 xlim_max])
        ylim([1 ylim_max])
        title([ind1{1} ', page: ' num2str(page_index) ' from ' num2str(pagenum)])
        yadj=20;
        
        for n=1:max(P3_2(:))
            v=find(P3_2==n);
            [v1 v2]=find(P3_2==n);
            pos1=v2(1); pos2=v1(end);
            text(pos1,pos2-yadj,0,['cat: ' num2str(sylls_cat(sylls_v(n))),', row:' num2str(sylls_name(sylls_v(n)))],...
                'fontsize',10,'BackgroundColor','white')
            
        end
         set(fig,'PaperPositionMode','auto');    
  print(fig,'-djpeg','-r300',[path_data 'sonograms\by individual\' ind1{1} '_page' num2str(page_index) '.jpg'])
    try;close(fig);end
    end
   
   
end
