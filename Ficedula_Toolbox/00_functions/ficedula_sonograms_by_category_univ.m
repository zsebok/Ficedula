function ficedula_sonograms_by_category_univ(path_songs,path_data)

warning off

load([path_data 'results_categorized_univ.mat'])
data0=results_categorized_univ;


%%
rows=1:size(data0,1);
cats_all=[data0{:,end}];

[cats]=unique(cats_all);


clear sylls; clear sylls_name
for cat1=cats

    v=find(cats_all==cat1);
    
    data2=ficedula_csoportositas_meresossz4(v,path_songs,data0);
    
    row_data0=v;
    row_data2=1:length(v);
    
    sylls=row_data2;
    sylls_n=length(sylls);
    sylls_name=row_data0;
    sylls_cat=cat1;
    
    clear sylls_width
    for i=1:length(sylls)
        sylls_width(i)=length(data2(i).T);
    end
    
    %how many syllable? how many window?
    specrow=data2(1).rows(1);
    syll_row=5;
    
    syll_maxlength=max(sylls_width)+300;
    
    xlim_max=15000;
    ylim_max=specrow*syll_row;
    
    syll_col=floor(xlim_max/syll_maxlength);
    syll_perpage=syll_col*syll_row;
    pagenum=ceil(sylls_n/syll_perpage);
    sylls_n_index=0;
    page_index=0;
    
    
    while sylls_n_index<sylls_n
        %cat1
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
        title(['category: ' num2str(cat1) ', page: ' num2str(page_index) ' from ' num2str(pagenum)])
        yadj=0;
        yadj2=20;
        for n=1:max(P3_2(:))
            v=find(P3_2==n);
            [v1 v2]=find(P3_2==n);
            pos1=v2(1); pos2=v1(end);
            id_name=data0{sylls_name(sylls_v(n)),1};id_name(5)='-';
            
            text(pos1,pos2-yadj,0,['row:' num2str(sylls_name(sylls_v(n)))],...
                'fontsize',8,'BackgroundColor','white')
            text(pos1,pos2-yadj2,0,[id_name(1:end-4)],...
                'fontsize',8,'BackgroundColor','white')
            
        end
        set(fig,'PaperPositionMode','auto');
        
        print(fig,'-djpeg','-r300',[path_data 'sonograms\by univ category\cat'  sprintf('%04d',(cat1)) '_page' sprintf('%02d',(page_index)) '.jpg'])
        try;close(fig);end
    end
  
end


