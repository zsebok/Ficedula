function csoportositas5(varargin)
warning off

%%% initializations

if nargin
    main.path_songs=varargin{1};
    main.path_data=varargin{2};
    main.mode=varargin{3};
else
    main.path_songs='';
    main.path_data='';
    main.mode='individual';
end

if strcmp(main.mode,'individual')
    inds=csoportositas_load_inds(main.path_data);
else
    inds{1}='universal';
end

inds_num=1;
main.backcolor=[0.5 0.5 0.5];
main.textbackcolor=[0.8 0.8 0.8];
buildfig
clear_axes
main.al1_selected=[];
set(main.edit_path_songs,'string',main.path_songs)

%%% functions

    function clear_axes
        main.al1_row=4;
        main.al1_window=16;% number of syll in a window
        main.al1_step=12;% step in syll
        main.al1_sylls=[];
        main.al1_num=[];
        cla(main.al1)
        
        main.ar1_row=1; main.ar1_window=4;main.ar1_step=3;main.ar1_sylls=[];main.ar1_num=0;
        main.ar2_row=1; main.ar2_window=4;main.ar2_step=3;main.ar2_sylls=[];main.ar2_num=0;
        main.ar3_row=1; main.ar3_window=4;main.ar3_step=3;main.ar3_sylls=[];main.ar3_num=0;
        main.ar4_row=5; main.ar4_window=30;main.ar4_step=20;main.ar4_sylls=[];main.ar4_num=0;
        main.ar5_row=5; main.ar5_window=30;main.ar5_step=20;main.ar5_sylls=[];main.ar5_num=0;
        main.ar6_row=5; main.ar6_window=30;main.ar6_step=20;main.ar6_sylls=[];main.ar6_num=0;
        
        cla(main.ac1)
        cla(main.ac2)
        
        cla(main.ar1)
        cla(main.ar2)
        cla(main.ar3)
        
        %clear categories
        main.cat={};
        main.act_cat={};
    end
    function buildfig
        main.fig=figure('units','normalized','position',[0 0 1 1],'Name','Flycatcher Syllable Clustering',...
            'menubar','none','Numbertitle','off','CloseRequestFcn',@myclosefcn,'KeyPressFcn', @keyPress);
        set(main.fig,'colormap',jet)
        if strcmp(inds{1},'universal')
                set(main.fig,'Name','Flycatcher Syllable Group Clustering')
       end        
        %%% decoration %%%
        
        main.decor1=annotation('rectangle','Position',[0.04,0.87,0.35,0.1],'facecolor',[0 0.8 0]);
        main.decor2=annotation('rectangle','Position',[0.008 0.024 0.406 0.83],'edgecolor',[0 0 1],'LineWidth',2,'hittest','off');
        main.decor3=annotation('rectangle','Position',[0.578 0.025 0.406 0.275],'edgecolor',[0 0 1],'LineWidth',2,'hittest','off');
        main.decor4=annotation('rectangle','Position',[0.578 0.325 0.406 0.275],'edgecolor',[1 0.3 0],'LineWidth',2,'hittest','off');
        main.decor5=annotation('rectangle','Position',[0.578 0.625 0.406 0.275],'edgecolor',[1 0.3 0],'LineWidth',2,'hittest','off');
        
        %%% axes %%%%%%%%%%%%%%%%%%%%%%
        main.al1=axes('units','normalized','position',[0.01 0.08 0.4 0.75],...
            'xtick',[],'ytick',[],'ButtonDownFcn',@al1_down,'color',main.backcolor);
        %  uistack(main.al1,'top')
        main.ar1=axes('units','normalized','position',[0.58 0.675 0.4 0.2],...
            'xtick',[],'ytick',[],'color',main.backcolor);
        main.ar2=axes('units','normalized','position',[0.58 0.375 0.4 0.2],...
            'xtick',[],'ytick',[],'color',main.backcolor);
        main.ar3=axes('units','normalized','position',[0.58 0.075 0.4 0.2],...
            'xtick',[],'ytick',[],'color',main.backcolor);
        
        main.ac1=axes('units','normalized','position',[0.42 0.25 0.15 0.2],...
            'xtick',[],'ytick',[],'color',main.backcolor);
        main.ac2=axes('units','normalized','position',[0.42 0.6 0.15 0.2],...
            'xtick',[],'ytick',[],'color',main.backcolor);
        
        %%% buttons %%%%%%%%%%%%%%%%%%%%
        
        main.but_add=uicontrol('style','pushbutton','units','normalized','position',[0.45 0.52 0.10 0.05],...
            'string','add to category','callback',{@addtocategory_callback});
        main.but_newcat=uicontrol('style','pushbutton','units','normalized','position',[0.45 0.85 0.10 0.05],...
            'string','create new category','callback',{@createnewcategory_callback});
        main.but_loadind=uicontrol('style','pushbutton','units','normalized','position',[0.3 0.88 0.08 0.03],...
            'string','load','callback',{@loadindividual_callback});
        
        main.but_ind_forw=uicontrol('style','pushbutton','units','normalized','position',[0.1 0.88 0.05 0.03],...
            'string','>','callback',{@ind_forw_callback});
        main.but_ind_back=uicontrol('style','pushbutton','units','normalized','position',[0.05 0.88 0.05 0.03],...
            'string','<','callback',{@ind_back_callback});
        
%         main.but_a1_back=uicontrol('style','pushbutton','units','normalized','position',[0.01 0.03 0.05 0.04],...
%             'string','<','callback',{@al1_back_callback});
%         main.but_a1_forw=uicontrol('style','pushbutton','units','normalized','position',[0.36 0.03 0.05 0.04],...
%             'string','>','callback',{@al1_forw_callback});
%         
        
       main.but_a1_back=uicontrol('style','pushbutton','units','normalized','position',[0.07 0.03 0.05 0.04],...
            'string','<<','callback',{@al1_back_callback});
        main.but_a1_forw=uicontrol('style','pushbutton','units','normalized','position',[0.3 0.03 0.05 0.04],...
            'string','>>','callback',{@al1_forw_callback});
        
        main.but_a2_back=uicontrol('style','pushbutton','units','normalized','position',[0.01 0.03 0.05 0.04],...
            'string','|<','callback',{@al2_back_callback});
        main.but_a2_forw=uicontrol('style','pushbutton','units','normalized','position',[0.36 0.03 0.05 0.04],...
            'string','>|','callback',{@al2_forw_callback});
        
        
        
        main.but_ar1_back=uicontrol('style','pushbutton','units','normalized','position',[0.58 0.63 0.1 0.04],...
            'string','<','callback',{@ar1_back_callback});
        main.but_ar1_forw=uicontrol('style','pushbutton','units','normalized','position',[0.88 0.63 0.1 0.04],...
            'string','>','callback',{@ar1_forw_callback});
        main.but_ar2_back=uicontrol('style','pushbutton','units','normalized','position',[0.58 0.33 0.1 0.04],...
            'string','<','callback',{@ar2_back_callback});
        main.but_ar2_forw=uicontrol('style','pushbutton','units','normalized','position',[0.88 0.33 0.1 0.04],...
            'string','>','callback',{@ar2_forw_callback});
        main.but_ar3_back=uicontrol('style','pushbutton','units','normalized','position',[0.58 0.03 0.1 0.04],...
            'string','<','callback',{@ar3_back_callback});
        main.but_ar3_forw=uicontrol('style','pushbutton','units','normalized','position',[0.88 0.03 0.1 0.04],...
            'string','>','callback',{@ar3_forw_callback});
        
        main.but_delcat=uicontrol('style','pushbutton','units','normalized','position',[0.45 0.16 0.1 0.04],...
            'string','delete category','callback',{@delcat_callback});
        main.but_delsyllfromcat=uicontrol('style','pushbutton','units','normalized','position',[0.45 0.12 0.1 0.04],...
            'string','delete syllable','callback',{@delsyllfromcat_callback});

        if strcmp(inds{1},'universal')
        main.but_delcat=uicontrol('style','pushbutton','units','normalized','position',[0.45 0.16 0.1 0.04],...
            'string','delete universal category','callback',{@delcat_callback});
        main.but_delsyllfromcat=uicontrol('style','pushbutton','units','normalized','position',[0.45 0.12 0.1 0.04],...
            'string','delete category','callback',{@delsyllfromcat_callback});

        end
        
        main.but_orderingbydistances=uicontrol('style','pushbutton','units','normalized','position',[0.16 0.03 0.05 0.04],...
            'string','order','callback',{@orderingbydistance_callback});
        
        
        main.but_save=uicontrol('style','pushbutton','units','normalized','position',[0.7 0.92 0.1 0.05],...
            'string','save','callback',{@save_callback},'backgroundcolor',[0 0.8 0]);
        
        main.but_ar4=uicontrol('style','pushbutton','units','normalized','position',[0.73 0.63 0.1 0.04],...
            'string','show all','callback',{@ar4_callback});
        
        main.but_ar5=uicontrol('style','pushbutton','units','normalized','position',[0.73 0.33 0.1 0.04],...
            'string','show all','callback',{@ar5_callback});
        
        main.but_ar6=uicontrol('style','pushbutton','units','normalized','position',[0.73 0.03 0.1 0.04],...
            'string','show all','callback',{@ar6_callback});
        
        %%% edit %%%
        main.edit_path_songs=uicontrol('style','edit','units','normalized','position',[0.15,0.93,0.2,0.03],'String','','callback',{@edit_path_song_callback},...
            'backgroundcolor',[0.6 1 0.6]);
        main.multiadd_check=uicontrol('style','checkbox','units','normalized','position',[0.48 0.49 0.05 0.02],...
            'string','multi add','backgroundcolor',main.textbackcolor);
        
        %%% text %%%
        main.text_path_songs=uicontrol('style','text','units','normalized','position',[0.06 0.935 0.08 0.02],...
            'string','path of songs:','backgroundcolor',[0 0.8 0]);
        
        main.text_ind=uicontrol('style','text','units','normalized','position',[0.16 0.885 0.13 0.02],...
            'string',[num2str(inds_num) '. ' inds{inds_num}],'backgroundcolor',[0.6 1 0.6]);
        
        main.text_ac2=uicontrol('style','text','units','normalized','position',[0.42 0.80 0.15 0.02],...
            'string','Actual syllable:','backgroundcolor',main.textbackcolor,'foregroundcolor',[0 0 1],'fontweight','bold');
        main.text_ac1=uicontrol('style','text','units','normalized','position',[0.42 0.45 0.15 0.02],...
            'string','Actual category:','backgroundcolor',main.textbackcolor,'foregroundcolor',[1 0.3 0],'fontweight','bold');
        
        main.text_ar1=uicontrol('style','text','units','normalized','position',[0.58 0.875 0.3 0.02],...
            'string','Hints for categories:','horizontalalignment','left','backgroundcolor',main.textbackcolor,'foregroundcolor',[1 0.3 0],'fontweight','bold');
        main.text_ar2=uicontrol('style','text','units','normalized','position',[0.58 0.575 0.3 0.02],...
            'string','Categories:','horizontalalignment','left','backgroundcolor',main.textbackcolor,'foregroundcolor',[1 0.3 0],'fontweight','bold');
        main.text_ar3=uicontrol('style','text','units','normalized','position',[0.58 0.275 0.3 0.02],...
            'string','Syllables in the current category:','horizontalalignment','left','backgroundcolor',main.textbackcolor,'foregroundcolor',[0 0 1],'fontweight','bold');
        main.text_info=uicontrol('style','text','units','normalized','position',[0.40 0.95 0.2 0.03],...
            'string','InfoBox','backgroundcolor',main.textbackcolor,'foregroundcolor',[0 0.6 0],'fontweight','bold');
        main.text_al1=uicontrol('style','text','units','normalized','position',[0.01 0.83 0.4 0.02],...
            'string','Remaining syllables:','horizontalalignment','left','backgroundcolor',main.textbackcolor,'foregroundcolor',[0 0 1],'fontweight','bold');
     
        if strcmp(inds{1},'universal')
            
        main.text_ac2=uicontrol('style','text','units','normalized','position',[0.42 0.80 0.15 0.02],...
            'string','Actual group:','backgroundcolor',main.textbackcolor,'foregroundcolor',[0 0 1],'fontweight','bold');
        main.text_ac1=uicontrol('style','text','units','normalized','position',[0.42 0.45 0.15 0.02],...
            'string','Actual universal group:','backgroundcolor',main.textbackcolor,'foregroundcolor',[1 0.3 0],'fontweight','bold');
        
        main.text_ar1=uicontrol('style','text','units','normalized','position',[0.58 0.875 0.3 0.02],...
            'string','Hints for universal categories:','horizontalalignment','left','backgroundcolor',main.textbackcolor,'foregroundcolor',[1 0.3 0],'fontweight','bold');
        main.text_ar2=uicontrol('style','text','units','normalized','position',[0.58 0.575 0.3 0.02],...
            'string','Universal categories:','horizontalalignment','left','backgroundcolor',main.textbackcolor,'foregroundcolor',[1 0.3 0],'fontweight','bold');
        main.text_ar3=uicontrol('style','text','units','normalized','position',[0.58 0.275 0.3 0.02],...
            'string','Groups in the current universal category:','horizontalalignment','left','backgroundcolor',main.textbackcolor,'foregroundcolor',[0 0 1],'fontweight','bold');
        main.text_info=uicontrol('style','text','units','normalized','position',[0.40 0.95 0.2 0.03],...
            'string','InfoBox','backgroundcolor',main.textbackcolor,'foregroundcolor',[0 0.6 0],'fontweight','bold');
        main.text_al1=uicontrol('style','text','units','normalized','position',[0.01 0.83 0.4 0.02],...
            'string','Remaining groups:','horizontalalignment','left','backgroundcolor',main.textbackcolor,'foregroundcolor',[0 0 1],'fontweight','bold');
     
        end
    
    end

    function ind_forw_callback(src,evnt)
        inds_num=inds_num+1;
        if inds_num>length(inds)
            inds_num=length(inds);
        end
        set(main.text_ind,'string',[num2str(inds_num) '. ' inds{inds_num}]);
    end

    function ind_back_callback(src,evnt)
        inds_num=inds_num-1;
        if inds_num==0
            inds_num=1;
        end
        
        set(main.text_ind,'string',[num2str(inds_num) '. ' inds{inds_num}]);
    end
% 
%     function al1_forw_callback(src,evnt)
%         main.al1_num=main.al1_num+main.al1_window;
%         
%         if main.al1_num+main.al1_window-1>length(main.al1_sylls)
%             main.al1_num=length(main.al1_sylls)-main.al1_window+1;
%         end
%         if main.al1_num<0; main.al1_num=1;end
%         
%         sylls=main.al1_num:min(main.al1_num+main.al1_window-1,length(main.al1_sylls));
%         sylls_db=main.al1_sylls(sylls);
%         main.al1_sylls_inwindow2=sylls_db;
%         %sylls_db
%         draw_al1(sylls_db)
%         refresh_labels
%     end
% 
%     function al1_back_callback(src,evnt)
%         main.al1_num=main.al1_num-main.al1_window;
%         if main.al1_num<0; main.al1_num=1;end
%         
%         sylls=main.al1_num:min(main.al1_num+main.al1_window-1,length(main.al1_sylls));
%         
%         sylls_db=main.al1_sylls(sylls);
%         main.al1_sylls_inwindow2=sylls_db;
%         draw_al1(sylls_db)
%         refresh_labels
%     end


    function al1_forw_callback(src,evnt)
        main.al1_num=main.al1_num+main.al1_window;
        
        if main.al1_num+main.al1_window-1>length(main.al1_sylls)
            main.al1_num=length(main.al1_sylls)-main.al1_window+1;
        end
        if main.al1_num<0; main.al1_num=1;end
        
        sylls=main.al1_num:min(main.al1_num+main.al1_window-1,length(main.al1_sylls));
        sylls_db=main.al1_sylls(sylls);
        main.al1_sylls_inwindow2=sylls_db;
        %sylls_db
        draw_al1(sylls_db)
        refresh_labels
    end

    function al1_back_callback(src,evnt)
        main.al1_num=main.al1_num-main.al1_window;
        if main.al1_num<0; main.al1_num=1;end
        
        sylls=main.al1_num:min(main.al1_num+main.al1_window-1,length(main.al1_sylls));
        
        sylls_db=main.al1_sylls(sylls);
        main.al1_sylls_inwindow2=sylls_db;
        draw_al1(sylls_db)
        refresh_labels
    end
%%%%%%%%%%%%%%%%%%%%%%%%%

    function al2_forw_callback(src,evnt)
        main.al1_num=length(main.al1_sylls);
        
        if main.al1_num+main.al1_window-1>length(main.al1_sylls)
            main.al1_num=length(main.al1_sylls)-main.al1_window+1;
        end
        if main.al1_num<0; main.al1_num=1;end
        
        sylls=main.al1_num:min(main.al1_num+main.al1_window-1,length(main.al1_sylls));
        sylls_db=main.al1_sylls(sylls);
        main.al1_sylls_inwindow2=sylls_db;
        %sylls_db
        draw_al1(sylls_db)
        refresh_labels
    end

    function al2_back_callback(src,evnt)
        main.al1_num=1;
        if main.al1_num<0; main.al1_num=1;end
        
        sylls=main.al1_num:min(main.al1_num+main.al1_window-1,length(main.al1_sylls));
        
        sylls_db=main.al1_sylls(sylls);
        main.al1_sylls_inwindow2=sylls_db;
        draw_al1(sylls_db)
        refresh_labels
    end


    function loadindividual_callback(src,evnt)
        clear_axes
        set(main.text_info,'string','Loading...');
        drawnow
        
           [main.data, main.matrix]=csoportositas_meresossz5(inds{inds_num},main.path_songs,main.path_data);
        
        
        set(main.text_info,'string',[num2str(length(main.data)) ' syllables are loaded.']);
        drawnow
        main.al1_num=1;
        
        %
        try %try to load the categorization
            [main.cat,main.al1_sylls,data]=csoportositas_load_cat(inds{inds_num},main.path_data);
            main.act_cat=1;
            main.al1_sylls
            inds{inds_num}
            % main.al1_sylls=1;
            
            if ~isempty(main.al1_sylls)
                %draw al1
                sylls=1:min(length(main.al1_sylls),main.al1_window);
                
                syllsdb=main.al1_sylls(sylls);
                draw_al1(syllsdb)
                main.al1_sylls_inwindow2=syllsdb;
            else
                set(main.al1,'xlim',[0 400])
            end
            %draw ar2
            main.ar2_num=1;
            main.ar2_sylls=horzcat(main.cat{:,1});
            sylls=1:min(length(main.ar2_sylls),main.ar2_window);
            syllsdb=main.ar2_sylls(sylls);
            draw_ar2(syllsdb)
            %syllsdb
            main.ar2_sylls_inwindow2=sylls;
            %sylls
            
            %draw ar3
            main.ar3_num=1;
            main.ar3_sylls=horzcat(main.cat{main.act_cat,2});
            sylls=1:min(length(main.ar3_sylls),main.ar3_window);
            syllsdb=main.ar3_sylls(sylls);
            
            main.ar3_sylls_inwindow2=syllsdb;
            draw_ar3(syllsdb)
            
            main.ar1_sylls_inwindow2=[];
            
            %draw ac1
            syll=main.cat{main.act_cat,1};
            %axes(main.ac1);
            surf(main.ac1,main.data(syll).P,'edgecolor','none'); view(main.ac1,2); %axis(main.ac1, 'off')
            set(main.text_ac1,'string',['Actual category: ' num2str(main.act_cat)]);
            lim_eq(main.al1,main.ac1)
            set(main.ac1,'xticklabel',[],'yticklabel',[],'color',main.backcolor)
            grid on
            set(main.ac1,'layer','top')
            'új adat betöltve'
        catch err
            err
            
            main.al1_sylls=1:length(main.data);
            sylls=1:(min(main.al1_window,main.al1_sylls));
            'hey'
            sylls=main.al1_sylls;
            
            'nincs régi adat'
            syllsdb=main.al1_sylls(sylls);
            draw_al1(syllsdb)
            main.al1_sylls_inwindow2=syllsdb;
            main.ar1_sylls_inwindow2=[];
            main.ar2_sylls_inwindow2=[];
            main.ar3_sylls_inwindow=[];
            
            
        end
        refresh_labels
    end

    function draw_al1(sylls)
        [main.al1_P3 main.al1_P3_2]=csoportositas_abratabla3(main.data,main.matrix,sylls,main.al1_row);
        main.al1_sylls_inwindow=sylls;
        %axes(main.al1)
        main.h=surf(main.al1,main.al1_P3,'edgecolor','none');
        view(main.al1,2)
        %axis off
        set(main.h,'HitTest','off')
        set(main.al1,'ButtonDownFcn',@al1_down,'xtick',[],'ytick',[],'color',main.backcolor);
        set(main.al1,'xlim',[0 500])
        
    end

    function draw_ar2(sylls)
        [main.ar2_P3 main.ar2_P3_2]=csoportositas_abratabla3(main.data,main.matrix,sylls,main.ar2_row);
        main.ar2_sylls_inwindow=sylls;
        %axes(main.ar2)
        h=surf(main.ar2,main.ar2_P3,'edgecolor','none');
        view(main.ar2,2)
        %axis off
        
        lim_eq(main.al1,main.ar2)
        set(h,'HitTest','off')
        set(main.ar2,'ButtonDownFcn',@ar2_down,'xtick',[],'ytick',[],'color',main.backcolor);
    end

    function draw_ar3(sylls)
        [main.ar3_P3 main.ar3_P3_2]=csoportositas_abratabla3(main.data,main.matrix,sylls,main.ar3_row);
        main.ar3_sylls_inwindow=sylls;
        %axes(main.ar3)
        h=surf(main.ar3,main.ar3_P3,'edgecolor','none');
        view(main.ar3,2)
        lim_eq(main.al1,main.ar3)
        %axis off
        set(h,'HitTest','off')
        set(main.ar3,'ButtonDownFcn',@ar3_down,'xtick',[],'ytick',[],'color',main.backcolor);
    end

    function draw_ar1(sylls)
        [main.ar1_P3 main.ar1_P3_2]=csoportositas_abratabla3(main.data,main.matrix,sylls,main.ar1_row);
        main.ar1_sylls_inwindow=sylls;
        %axes(main.ar1)
        h=surf(main.ar1,main.ar1_P3,'edgecolor','none');
        view(main.ar1,2)
        lim_eq(main.al1,main.ar1)
        %axis off
        set(h,'HitTest','off')
        set(main.ar1,'ButtonDownFcn',@ar1_down,'xtick',[],'ytick',[],'color',main.backcolor);
    end

    function al1_down(src,evnt)
        
        %main.al1_sylls_inwindow
        % 'al1_down'
        
        posxy=get(src,'CurrentPoint');
        try
            selected0=main.al1_P3_2(floor(posxy(1,2)),floor(posxy(1,1)));
        catch
            selected0=NaN;
        end
     
        
        if ~isnan(selected0)
            selected=main.al1_sylls_inwindow(selected0);
            main.al1_selected0=selected0;
            main.al1_selected=selected;
            
            h=surf(main.ac2,main.data(main.al1_selected).P,'edgecolor','none'); view(main.ac2,2);%axis(main.ac2,'off')
            set(h,'HitTest','off')
            % 'hey'
            set(main.ac2,'ButtonDownFcn',@ac2_down,'xticklabel',[],'yticklabel',[],'color',main.backcolor)
           
            
            grid on
            set(main.ac2,'layer','top')
            
            lim_eq(main.al1,main.ac2)
            
            
            set(main.text_ac2,'string',['Actual syllable: ' num2str(main.al1_selected)]);
            
            predict2([])
            main.ar1_num=1;
        else
            main.al1_selected=[];
            cla(main.ac2)
            %axis(main.ac2,'off')
            set(main.ac1,'xtick',[],'ytick',[],'color',main.backcolor)
        end
        
        if get(main.multiadd_check,'value')
            addtocategory_callback
        end
    end


    function predict2(exclude)
        
        if ~isempty(exclude)
            
        end
        if size(main.cat,1)>1
         
            newpredicts=csoportositas_sort_by_distances2(main.matrix,main.cat,main.al1_selected);
            main.ar1_num=1;
            
            main.ar1_sylls=horzcat(main.cat{newpredicts,1});
            main.ar1_cats=newpredicts;
            
            sylls_v=1:min(length(newpredicts),main.ar1_window);
            
            syllsdb=main.ar1_sylls(sylls_v);
            
            draw_ar1(syllsdb)
            
            main.ar1_sylls_inwindow2=main.ar1_cats(sylls_v);
            
            
        end
        
        %drawing
        refresh_labels
    end

    function keyPress(src,lenyomtam)
        switch lenyomtam.Key
            case 'a'
                addtocategory_callback
        end
    end

    function addtocategory_callback(src,evnt)
        if ~isempty(main.al1_selected)
            
            if isempty(main.act_cat) %ha nincs kategória kiválasztva
                
                %új kat hozzáadása
                main.act_cat=size(main.cat,1)+1;
                main.cat{main.act_cat,1}=main.al1_selected;
                main.cat{main.act_cat,2}=main.al1_selected;
                
                
                %rajzolás - categories ar2
                main.ar2_sylls=vertcat(main.cat{:,1});
                
                catstodraw_end=main.act_cat;
                catstodraw_start=catstodraw_end-main.ar2_window+1;
                if catstodraw_start<1;catstodraw_start=1;end
                draw_ar2(main.ar2_sylls(catstodraw_start:catstodraw_end))
                
            else %ha van kiálasztva kategória
                
                catcontent=main.cat{main.act_cat,2};
                catcontent_new=[catcontent;main.al1_selected];
                main.cat{main.act_cat,2}=catcontent_new;
                
            end
    
            %% 
            
            %ar3-at frissíteni
            main.ar3_sylls=main.cat{main.act_cat,2};
            catstodraw_end=find(main.al1_selected==main.ar3_sylls);
            catstodraw_start=catstodraw_end-main.ar3_window+1;
            if catstodraw_start<1;catstodraw_start=1;end
            draw_ar3(main.ar3_sylls(catstodraw_start:catstodraw_end))
            
            %% 0.8
            
            %eltávolítani az aktuális syllabust
            
            syll_to_remove=find(main.al1_selected==main.al1_sylls);
            main.al1_sylls(syll_to_remove)=[];
            
            %% vajon rajta van-e al1-en?
            
            if any(main.al1_sylls_inwindow==main.al1_selected)
                v0=find(main.al1_sylls_inwindow==main.al1_selected);
                [v1 v2]=find(main.al1_P3_2==v0);
                main.al1_P3_2(main.al1_P3_2==v0)=NaN;
                main.al1_sylls_inwindow2(main.al1_sylls_inwindow2==syll_to_remove)=[];
                
               
                hold(main.al1,'on')
               
                x=[min(v1) max(v1) min(v1) max(v1)];
                y=[min(v2) max(v2) max(v2) min(v2)];
                z=repmat(max(main.al1_P3(:)),1,4);
                
                plot3(main.al1,y,x,z,'-','linewidth',10,'color',main.backcolor)
                hold(main.al1,'off')
                
            end
            %% 1.1 sec
            
          
            main.al1_selected=[];
            cla(main.ac2)
            set(main.text_ac2,'string','Actual syllable:');
            
          
            %rajzolás - ac1-t frissíteni
            syll=main.cat{main.act_cat,1};
            %axes(main.ac1);
            surf(main.ac1,main.data(syll).P,'edgecolor','none'); view(main.ac1,2); %axis(main.ac1, 'off')
            set(main.text_ac1,'string',['Actual category: ' num2str(main.act_cat)]);
            lim_eq(main.al1,main.ac1)
            set(main.ac1,'xtick',[],'ytick',[],'color',main.backcolor)
            refresh_labels
        end
    end

    function createnewcategory_callback(src,evnt)
        create_new_category
    end
    function create_new_category
        main.act_cat={};
        cla(main.ac1)
        set(main.text_ac1,'string','Actual category:')
    end

    function ar2_forw_callback(src,evnt)
        'hey'
        main.ar2_num=main.ar2_num+main.ar2_window-1;
        
        if main.ar2_num+main.ar2_window-1>length(main.ar2_sylls)
            main.ar2_num=length(main.ar2_sylls)-main.ar2_window+1;
        end
        if main.ar2_num<1; main.ar2_num=1;end
        
        
        sylls=main.ar2_num:min(main.ar2_num+main.ar2_window-1,length(main.ar2_sylls));
        %sylls
        main.ar2_sylls_inwindow2=sylls;
        sylls_db=main.ar2_sylls(sylls);
        
        draw_ar2(sylls_db)
        refresh_labels
    end

    function ar2_back_callback(src,evnt)
        main.ar2_num=main.ar2_num-main.ar2_window+1;
        if main.ar2_num<1; main.ar2_num=1;end
        %al1_num=main.al1_num
        sylls=main.ar2_num:min(main.ar2_num+main.ar2_window-1,length(main.ar2_sylls));
        %sylls
        sylls_db=main.ar2_sylls(sylls);
        main.ar2_sylls_inwindow2=sylls;
        draw_ar2(sylls_db)
        refresh_labels
    end

    function ar3_forw_callback(src,evnt)
        main.ar3_num=main.ar3_num+main.ar3_window-1;
        
        if main.ar3_num+main.ar3_window-1>length(main.ar3_sylls)
            main.ar3_num=length(main.ar3_sylls)-main.ar3_window+1;
        end
        if main.ar3_num<1; main.ar3_num=1;end
        
        
        sylls=main.ar3_num:min(main.ar3_num+main.ar3_window-1,length(main.ar3_sylls));
        
        sylls_db=main.ar3_sylls(sylls);
        main.ar3_sylls_inwindow=sylls_db;
        draw_ar3(sylls_db)
        
        refresh_labels
    end

    function ar3_back_callback(src,evnt)
        main.ar3_num=main.ar3_num-main.ar3_window+1;
        if main.ar3_num<1; main.ar3_num=1;end
       
        sylls=main.ar3_num:min(main.ar3_num+main.ar3_window-1,length(main.ar3_sylls));
        %sylls
        sylls_db=main.ar3_sylls(sylls);
        main.ar3_sylls_inwindow=sylls_db;
        draw_ar3(sylls_db)
        refresh_labels
    end

    function delsyllfromcat_callback(src,evnt)
        axes(main.ar3)
        go=1;
       % while go==1
            [x,y, but] = ginput(1);
            if but==1
                selected0=main.ar3_P3_2(floor(y),floor(x)); %sorszam
                
                if ~isnan(selected0)
                    selectedsyll=main.ar3_sylls_inwindow(selected0);
                   
                    syllsincat=main.cat{main.act_cat,2};
                    f=find(syllsincat==selectedsyll);
                    syllsincat(find(syllsincat==selectedsyll))=[];
                    main.cat{main.act_cat,2}=syllsincat;
                    
                    if length(syllsincat)>0 & f==1 %if it was the first syllable in the group
                        main.cat{main.act_cat,1}=syllsincat(1);
                        
                        main.ar2_sylls(find(main.ar2_sylls==selectedsyll))=syllsincat(1);
                        sylls=main.ar2_num:min(main.ar2_num+main.ar2_window-1,length(main.ar2_sylls));
                        main.ar2_sylls_inwindow2=sylls;
                        sylls_db=main.ar2_sylls(sylls);
                        draw_ar2(sylls_db)
                        
                        main.ar1_sylls(find(main.ar1_sylls==selectedsyll))=syllsincat(1);
                        sylls=main.ar1_num:min(main.ar1_num+main.ar1_window-1,length(main.ar1_sylls));
                        main.ar1_sylls_inwindow2=sylls;
                        sylls_db=main.ar1_sylls(sylls);
                        draw_ar1(sylls_db)
                        
                        
                    end
                    
                    main.ar3_sylls=syllsincat;
                    
                    
                    main.al1_sylls=[main.al1_sylls selectedsyll];
                    
                    
                    %if it was the last syll in this cat
                    if isempty(main.ar3_sylls)
                        remove_cat(main.act_cat)
                        
                    else
                        %ar3-at frissíteni
                        catstodraw_start=1;
                        catstodraw_end=min(length(main.ar3_sylls),main.ar3_window);
                        
                        draw_ar3(main.ar3_sylls(catstodraw_start:catstodraw_end))
                    end
                    
                   
                    
                end
                refresh_labels
            else
                go=0;
            end
       % end
        refresh_labels
    end

    function delcat_callback(src,evnt)
        axes(main.ar2)
        go=1;
        %while go==1
        [x,y, but] = ginput(1);
        if but==1
            selected0=main.ar2_P3_2(floor(y),floor(x));
            
            if ~isnan(selected0)
                selected1=main.ar2_sylls_inwindow(selected0);
                selectedcat=find(vertcat(main.cat{:,1})==selected1);
                
                remove_cat(selectedcat)
              
                
            end
        else
            go=0;
        end
        %end
    end
    function remove_cat(selectedcat)
        
        %put back all syllables to database
        sylls=main.cat{selectedcat,2}';
        main.al1_sylls=[main.al1_sylls sylls];
        
        %delete the category
        main.cat(selectedcat,:)=[];
        main.ar2_sylls=vertcat(main.cat{:,1});
        main.ar3_sylls=[];cla(main.ar3)
        main.ar3_sylls_inwindow=[];
        
        main.ar1_sylls=[];
        main.ar1_sylls_inwindow=[];
        main.ar1_sylls_inwindow2=[];
        main.ar1_num=0;
        cla(main.ar1)
        
        
        %rajzolás - categories ar2
        if ~isempty(main.cat)
            catstodraw_end=min(length(main.ar2_sylls),main.ar2_window);
            catstodraw_start=1;%catstodraw_end-main.ar2_window+1;
            draw_ar2(main.ar2_sylls(catstodraw_start:catstodraw_end))
        else
            cla(main.ar2)
            cla(main.ar3)
        end
        main.act_cat=[];
        cla(main.ac1)
        set(main.text_ac1,'string','Actual category:')
        
        refresh_labels
    end

    function ar2_down(src,evnt)
        
       
        
        posxy=get(src,'CurrentPoint');
        selected0=main.ar2_P3_2(floor(posxy(1,2)),floor(posxy(1,1)));
        
        if ~isnan(selected0)
            selected1=main.ar2_sylls_inwindow(selected0);
            selectedcat=find(vertcat(main.cat{:,1})==selected1);
            
            main.act_cat=selectedcat;
            syll=main.cat{selectedcat,1};
            surf(main.ac1,main.data(syll).P,'edgecolor','none'); view(main.ac1,2);%axis(main.ac1,'off')
            
            lim_eq(main.al1,main.ac1)
            set(main.ac1,'xticklabel',[],'yticklabel',[],'color',main.backcolor)
            grid on
            set(main.ac1,'layer','top')
            
            set(main.text_ac1,'string',['Actual category: ' num2str(main.act_cat)]);
            
            %ar3-at frissíteni
            main.ar3_sylls=main.cat{main.act_cat,2};
            catstodraw_start=1;
            catstodraw_end=min(length(main.ar3_sylls),main.ar3_window);
            draw_ar3(main.ar3_sylls(catstodraw_start:catstodraw_end))
            
            
        end
        refresh_labels
        
    end

    

    function ar1_down(src,evnt)
        
     
        
        posxy=get(src,'CurrentPoint');
        selected0=main.ar1_P3_2(floor(posxy(1,2)),floor(posxy(1,1)));
        
        if ~isnan(selected0)
            selected1=main.ar1_sylls_inwindow(selected0);
            selectedcat=find(vertcat(main.cat{:,1})==selected1);
            
            main.act_cat=selectedcat;
            syll=main.cat{selectedcat,1};
            surf(main.ac1,main.data(syll).P,'edgecolor','none'); view(main.ac1,2);%axis(main.ac1,'off')
            
            lim_eq(main.al1,main.ac1)
            
            set(main.ac1,'xticklabel',[],'yticklabel',[],'color',main.backcolor)
            grid on
            set(main.ac1,'layer','top')
            set(main.text_ac1,'string',['Actual category: ' num2str(main.act_cat)]);
            
            %ar3-at frissíteni
            main.ar3_sylls=main.cat{main.act_cat,2};
            catstodraw_start=1;
            catstodraw_end=min(length(main.ar3_sylls),main.ar3_window);
            draw_ar3(main.ar3_sylls(catstodraw_start:catstodraw_end))
            
            
        end
        refresh_labels
        
    end


    function lim_eq(orig1,copy1)
       
        
        pos1=get(orig1,'position');w1=pos1(3);lim1=get(orig1,'xlim');w12=lim1(2);
        pos2=get(copy1,'position');w2=pos2(3);lim2=get(copy1,'xlim');
        w22=w12*w2/w1;
        
        set(copy1,'xlim',[0 w22])
      
    end


    function orderingbydistance_callback(src,evnt)
        
      
        if ~isempty(main.al1_selected)
           
            syll=main.al1_selected;
            main.al1_sylls=csoportositas_sort_by_distances(main.matrix,main.al1_sylls,syll);
        else
          
            syllsincat=main.cat{main.act_cat,2};
            main.al1_sylls=csoportositas_sort_by_distances3(main.matrix,main.al1_sylls,syllsincat);
        end
        
        
        main.al1_num=1;
       
        sylls=1:min(main.al1_window,length(main.al1_sylls));
        syllsdb= main.al1_sylls(sylls);
       
        draw_al1(syllsdb)
    end



    function myclosefcn(src,evnt)
        
        choice=questdlg('What do you want?', 'Warning', 'Go back to the program', 'Close the program' ,'Go back to the program');
        
        switch choice
            case 'Go back to the program'
                return
            case 'Close the program'
                delete(gcf)
               
        end
    end
    function edit_path_song_callback(src,evnt)
        main.path_songs=get(main.edit_path_songs,'string');
        
        string1=main.path_songs;

if ~(string1(end)=='\')
    string1=[string1 '\'];
    main.path_songs=string1;
    set(main.edit_path_songs,'string',main.path_songs);
end


        
    end

    function save_callback(src,evnt)
       try
        set(main.text_info,'string','Saving data...')
        drawnow
           cat=main.cat;
        remainedsylls=main.al1_sylls;
        
        data=main.data;
        data = rmfield(data, {'P','F','T','rows','y'});
        save([main.path_data inds{inds_num} '.mat'], 'cat','data','remainedsylls')
       set(main.text_info,'string','Saving was successful!')
        drawnow
  
       catch
        set(main.text_info,'string','Error in saving!')
        drawnow
           
       end
    end
    function refresh_labels
        ar1text=num2str(main.ar1_sylls_inwindow2);
        
        ar2text=[num2str(main.ar2_sylls_inwindow2) ' (all in all: ' num2str(length(main.ar2_sylls)) ')'];
        ar3text=[num2str(main.ar3_sylls_inwindow') ' (all in all: ' num2str(length(main.ar3_sylls)) ')'];
        al1text=[num2str(length(main.al1_sylls)) ' to go'];
        
        set(main.text_ar1,'string',['Hints for categories: ' ar1text]);
        set(main.text_ar2,'string',['Categories: ' ar2text]);
        set(main.text_ar3,'string',['Syllables in the current category: ' ar3text]);
        set(main.text_al1,'string',['Remaining syllables: ' al1text]);
    end

    function ar1_forw_callback(src,evnt)
        main.ar1_num=main.ar1_num+main.ar1_window-1;
        
        if main.ar1_num+main.ar1_window-1>length(main.ar1_sylls)
            main.ar1_num=length(main.ar1_sylls)-main.ar1_window+1;
        end
        if main.ar1_num<1; main.ar1_num=1;end
        
        
        sylls=main.ar1_num:min(main.ar1_num+main.ar1_window-1,length(main.ar1_sylls));
        %sylls
        
        sylls_db=main.ar1_sylls(sylls);
        main.ar1_sylls_inwindow2=main.ar1_cats(sylls);
        draw_ar1(sylls_db)
        refresh_labels
    end

    function ar1_back_callback(src,evnt)
        main.ar1_num=main.ar1_num-main.ar1_window+1;
        if main.ar1_num<1; main.ar1_num=1;end
     
        sylls=main.ar1_num:min(main.ar1_num+main.ar1_window-1,length(main.ar1_sylls));
     
        
        sylls_db=main.ar1_sylls(sylls);
        main.ar1_sylls_inwindow2=main.ar1_cats(sylls);
        draw_ar1(sylls_db)
        refresh_labels
    end
    function ars()
        main.fig_ars=figure('units','normalized','position',[0 0.7 0.15 0.2],'Name','Actual syllable',...
            'menubar','none','Numbertitle','off','CloseRequestFcn',@closears);
        main.ars=axes('units','normalized','position',[0.01 0.07 0.98 0.9],...
            'xtick',[],'ytick',[],'color',main.backcolor);
        surf(main.ars,main.data(main.al1_selected).P,'edgecolor','none'); view(main.ars,2);%axis(main.ac2,'off')
        
        set(main.ars,'xticklabel',[],'yticklabel',[],'color',main.backcolor)
        
        pos1f=get(main.fig_arall,'position');w1f=pos1f(3);
        pos2f=get(main.fig_ars,'position');w2f=pos2f(3);
        orig1=main.arall;
        copy1=main.ars;
      
        pos1=get(orig1,'position');w1=pos1(3);lim1=get(orig1,'xlim');w12=lim1(2);
        pos2=get(copy1,'position');w2=pos2(3);lim2=get(copy1,'xlim');w22=lim2(2);
        w22=w12*(w2*w2f)/(w1*w1f);
        
        set(copy1,'xlim',[0 w22])
        
    end

    function ar4_callback(src,event)
        main.fig_arall=figure('units','normalized','position',[0.15 0 0.85 1],'Name','All category',...
            'menubar','none','Numbertitle','off','CloseRequestFcn',@closears);
        
        main.arall=axes('units','normalized','position',[0.01 0.07 0.98 0.9],...
            'xtick',[],'ytick',[],'color',main.backcolor);
        main.but_ar4_back=uicontrol('style','pushbutton','units','normalized','position',[0.01 0.01 0.1 0.04],...
            'string','<','callback',{@ar4_back_callback});
        main.but_ar4_forw=uicontrol('style','pushbutton','units','normalized','position',[0.88 0.01 0.1 0.04],...
            'string','>','callback',{@ar4_forw_callback});
        main.ar4_num=1;
        main.ar4_cats=main.ar1_cats;
        main.ar4_sylls=main.ar1_sylls;
        sylls_v=1:min(length(main.ar4_cats),main.ar4_window);
        
        syllsdb=main.ar4_sylls(sylls_v);
        
        set(main.fig_arall,'name',['categories from ' num2str(main.ar4_num) ' to ' num2str(main.ar4_num+main.ar4_window-1) ' (all in all : ' num2str(length(main.ar4_cats)) ')'])
        
        
        draw_ar4(syllsdb)
        ars
    end
    function closears(src,evnt)
        delete(main.fig_arall)
        delete(main.fig_ars)
    end

    function ar5_callback(src,event)
        main.fig_arall=figure('units','normalized','position',[0.15 0 0.85 1],'Name','All category',...
            'menubar','none','Numbertitle','off','CloseRequestFcn',@closears);
        main.arall=axes('units','normalized','position',[0.01 0.07 0.98 0.9],...
            'xtick',[],'ytick',[],'color',main.backcolor);
        main.but_ar5_back=uicontrol('style','pushbutton','units','normalized','position',[0.01 0.01 0.1 0.04],...
            'string','<','callback',{@ar5_back_callback});
        main.but_ar5_forw=uicontrol('style','pushbutton','units','normalized','position',[0.88 0.01 0.1 0.04],...
            'string','>','callback',{@ar5_forw_callback});
        main.ar5_num=1;
        
        main.ar5_sylls=main.ar2_sylls;
        sylls_v=1:min(length(main.ar5_sylls),main.ar5_window);
        
        syllsdb=main.ar5_sylls(sylls_v);
        
        draw_ar5(syllsdb)
        set(main.fig_arall,'name',['categories from ' num2str(main.ar5_num) ' to ' num2str(main.ar5_num+main.ar5_window-1) ' (all in all : ' num2str(length(main.ar5_sylls)) ')'])
        
        ars
    end

    function ar6_callback(src,event)
        main.fig_arall=figure('units','normalized','position',[0.15 0 0.85 1],'Name','All category',...
            'menubar','none','Numbertitle','off','CloseRequestFcn',@closears);
        main.arall=axes('units','normalized','position',[0.01 0.07 0.98 0.9],...
            'xtick',[],'ytick',[],'color',main.backcolor);
        main.but_ar6_back=uicontrol('style','pushbutton','units','normalized','position',[0.01 0.01 0.1 0.04],...
            'string','<','callback',{@ar6_back_callback});
        main.but_ar6_forw=uicontrol('style','pushbutton','units','normalized','position',[0.88 0.01 0.1 0.04],...
            'string','>','callback',{@ar6_forw_callback});
        main.ar6_num=1;
      
        main.ar6_sylls=main.ar3_sylls;
        sylls_v=1:min(length(main.ar6_sylls),main.ar6_window);
        
        syllsdb=main.ar6_sylls(sylls_v);
        
        draw_ar6(syllsdb)
        set(main.fig_arall,'name',['syllables from ' num2str(main.ar6_num) ' to ' num2str(main.ar6_num+min(main.ar6_window,length(syllsdb))-1) ' (all in all : ' num2str(length(main.ar6_sylls)) ')'])
        
        ars
        
    end


    function ar6_forw_callback(src,evnt)
        main.ar6_num=main.ar6_num+main.ar6_window;
        
        if main.ar6_num+main.ar6_window-1>length(main.ar6_sylls)
            main.ar6_num=length(main.ar6_sylls)-main.ar6_window+1;
        end
        if main.ar6_num<1; main.ar6_num=1;end
        
        
        sylls=main.ar6_num:min(main.ar6_num+main.ar6_window-1,length(main.ar6_sylls));
       
        
        sylls_db=main.ar6_sylls(sylls);
        
        
        draw_ar6(sylls_db)
       
        set(main.fig_arall,'name',['syllables from ' num2str(main.ar6_num) ' to ' num2str(main.ar6_num+min(main.ar6_window,length(sylls_db))-1) ' (all in all : ' num2str(length(main.ar6_sylls)) ')'])
        
        refresh_labels
    end

    function ar6_back_callback(src,evnt)
        main.ar6_num=main.ar6_num-main.ar6_window;
        if main.ar6_num<1; main.ar6_num=1;end
       
        sylls=main.ar6_num:min(main.ar6_num+main.ar6_window-1,length(main.ar6_sylls));
      
        sylls_db=main.ar6_sylls(sylls);
        
        draw_ar6(sylls_db)
        
        set(main.fig_arall,'name',['syllables from ' num2str(main.ar6_num) ' to ' num2str(main.ar6_num+min(main.ar6_window,length(sylls_db))-1) ' (all in all : ' num2str(length(main.ar6_sylls)) ')'])
        
        refresh_labels
    end





    function ar4_forw_callback(src,evnt)
        main.ar4_num=main.ar4_num+main.ar4_window;
        
        if main.ar4_num+main.ar4_window-1>length(main.ar4_sylls)
            main.ar4_num=length(main.ar4_sylls)-main.ar4_window+1;
        end
        if main.ar4_num<1; main.ar4_num=1;end
        
        
        sylls=main.ar4_num:min(main.ar4_num+main.ar4_window-1,length(main.ar4_sylls));
       
        
        sylls_db=main.ar4_sylls(sylls);
        main.ar4_sylls_inwindow2=main.ar4_cats(sylls);
        draw_ar4(sylls_db)
        set(main.fig_arall,'name',['categories from ' num2str(main.ar4_num) ' to ' num2str(main.ar4_num+main.ar4_window-1) ' (all in all : ' num2str(length(main.ar4_cats)) ')'])
        
        refresh_labels
    end

    function ar4_back_callback(src,evnt)
        main.ar4_num=main.ar4_num-main.ar4_window;
        if main.ar4_num<1; main.ar4_num=1;end
       
        sylls=main.ar4_num:min(main.ar4_num+main.ar4_window-1,length(main.ar4_sylls));
      
        sylls_db=main.ar4_sylls(sylls);
        main.ar4_sylls_inwindow2=main.ar4_cats(sylls);
        draw_ar4(sylls_db)
        
        
        set(main.fig_arall,'name',['categories from ' num2str(main.ar4_num) ' to ' num2str(main.ar4_num+main.ar4_window-1) ' (all in all : ' num2str(length(main.ar4_cats)) ')'])
        
        refresh_labels
    end

    function ar5_forw_callback(src,evnt)
        main.ar5_num=main.ar5_num+main.ar5_window-1;
        
        if main.ar5_num+main.ar5_window-1>length(main.ar5_sylls)
            main.ar5_num=length(main.ar5_sylls)-main.ar5_window+1;
        end
        if main.ar5_num<1; main.ar5_num=1;end
        
        
        sylls=main.ar5_num:min(main.ar5_num+main.ar5_window-1,length(main.ar5_sylls));
        
        
        sylls_db=main.ar5_sylls(sylls);
        
        draw_ar5(sylls_db)
        set(main.fig_arall,'name',['categories from ' num2str(main.ar5_num) ' to ' num2str(main.ar5_num+main.ar5_window-1) ' (all in all : ' num2str(length(main.ar5_sylls)) ')'])
        
        refresh_labels
    end

    function ar5_back_callback(src,evnt)
        main.ar5_num=main.ar5_num-main.ar5_window+1;
        if main.ar5_num<1; main.ar5_num=1;end
        
        sylls=main.ar5_num:min(main.ar5_num+main.ar5_window-1,length(main.ar5_sylls));
       
        
        sylls_db=main.ar5_sylls(sylls);
        set(main.fig_arall,'name',['categories from ' num2str(main.ar5_num) ' to ' num2str(main.ar5_num+main.ar5_window-1) ' (all in all : ' num2str(length(main.ar5_sylls)) ')'])
        
        
        draw_ar5(sylls_db)
        refresh_labels
    end

    function draw_ar4(sylls)
        [main.ar4_P3 main.ar4_P3_2]=csoportositas_abratabla3(main.data,main.matrix,sylls,main.ar4_row);
        main.ar4_sylls_inwindow=sylls;
        
        h=surf(main.arall,main.ar4_P3,'edgecolor','none');
        view(main.arall,2)
        lim_eq(main.al1,main.arall)
        
        set(h,'HitTest','off')
        set(main.arall,'ButtonDownFcn',@ar4_down,'xtick',[],'ytick',[],'color',main.backcolor);
    end
    function draw_ar5(sylls)
        [main.ar5_P3 main.ar5_P3_2]=csoportositas_abratabla3(main.data,main.matrix,sylls,main.ar5_row);
        main.ar5_sylls_inwindow=sylls;
        
        h=surf(main.arall,main.ar5_P3,'edgecolor','none');
        view(main.arall,2)
        lim_eq(main.al1,main.arall)
        
        set(h,'HitTest','off')
        set(main.arall,'ButtonDownFcn',@ar5_down,'xtick',[],'ytick',[],'color',main.backcolor);
    end
    function draw_ar6(sylls)
        [main.ar6_P3 main.ar6_P3_2]=csoportositas_abratabla3(main.data,main.matrix,sylls,main.ar6_row);
        main.ar6_sylls_inwindow=sylls;
       
        h=surf(main.arall,main.ar6_P3,'edgecolor','none');
        view(main.arall,2)
        lim_eq(main.al1,main.arall)
        
        set(main.arall,'xtick',[],'ytick',[],'color',main.backcolor);
    end

    function ar4_down(src,evnt)
        
       
        
        posxy=get(src,'CurrentPoint');
        selected0=main.ar4_P3_2(floor(posxy(1,2)),floor(posxy(1,1)));
        
        if ~isnan(selected0)
            close(main.fig_arall)
            selected1=main.ar4_sylls_inwindow(selected0);
            selectedcat=find(vertcat(main.cat{:,1})==selected1);
            
            main.act_cat=selectedcat;
            syll=main.cat{selectedcat,1};
            surf(main.ac1,main.data(syll).P,'edgecolor','none'); view(main.ac1,2);%axis(main.ac1,'off')
            
            lim_eq(main.al1,main.ac1)
            set(main.ac1,'xticklabel',[],'yticklabel',[],'color',main.backcolor)
            grid on
            set(main.ac1,'layer','top')
            
            set(main.text_ac1,'string',['Actual category: ' num2str(main.act_cat)]);
            
            %ar3-at frissíteni
            main.ar3_sylls=main.cat{main.act_cat,2};
            catstodraw_start=1;
            catstodraw_end=min(length(main.ar3_sylls),main.ar3_window);
            draw_ar3(main.ar3_sylls(catstodraw_start:catstodraw_end))
            
            
            
            refresh_labels
        end
        
        
    end

    function ar5_down(src,evnt)
        
    
        posxy=get(src,'CurrentPoint');
        selected0=main.ar5_P3_2(floor(posxy(1,2)),floor(posxy(1,1)));
        
        if ~isnan(selected0)
            close(main.fig_arall)
            selected1=main.ar5_sylls_inwindow(selected0);
            selectedcat=find(vertcat(main.cat{:,1})==selected1);
            
            main.act_cat=selectedcat;
            syll=main.cat{selectedcat,1};
            surf(main.ac1,main.data(syll).P,'edgecolor','none'); view(main.ac1,2);%axis(main.ac1,'off')
            
            lim_eq(main.al1,main.ac1)
            set(main.ac1,'xticklabel',[],'yticklabel',[],'color',main.backcolor)
            grid on
            set(main.ac1,'layer','top')
            
            set(main.text_ac1,'string',['Actual category: ' num2str(main.act_cat)]);
            
            %ar3-at frissíteni
            main.ar3_sylls=main.cat{main.act_cat,2};
            catstodraw_start=1;
            catstodraw_end=min(length(main.ar3_sylls),main.ar3_window);
            draw_ar3(main.ar3_sylls(catstodraw_start:catstodraw_end))
            
            
            
            refresh_labels
        end
        
        
    end


    function ac2_down(src,evnt)
        
        syll1=main.cat{main.act_cat,1};
        syll2=main.al1_selected;
        
        
        surf(main.ac2,main.data(syll1).P,'edgecolor','none');lim_eq(main.al1,main.ac2);view(main.ac2,2)
       
        set(main.ac2,'xticklabel',[],'yticklabel',[],'color',main.backcolor)
        
        
        set(main.ac2,'layer','top')
        grid on
        drawnow
        
        wavplay(main.data(syll1).y,main.data(syll1).Fs/5)
       
        
        h=surf(main.ac2,main.data(syll2).P,'edgecolor','none');lim_eq(main.al1,main.ac2);view(main.ac2,2)
        set(main.ac2,'xticklabel',[],'yticklabel',[],'color',main.backcolor)
        
        grid on
        set(main.ac2,'layer','top')
        drawnow
        wavplay(main.data(syll2).y,main.data(syll2).Fs/5)
        
        set(h,'HitTest','off');
        set(main.ac2,'ButtonDownFcn',@ac2_down,'xticklabel',[],'yticklabel',[],'color',main.backcolor);
        
        grid on
        set(main.ac2,'layer','top')
        
    end
end
