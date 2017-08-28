function ficedula(varargin)

%settings


col1=[179 221 116]/256;col2=[232 163 125]/256;colors3=[222 193 115]/256;
colors4=[242 213 135]/256;col5=[33 33 33]/256;col6=[222 222 222]/256;

main.backcolor=col1;
main.textbackcolor=colors4;
main.textcolor=col5;
addpath_ %add toolbox folders to path
buildfig % build fugure
loadparams % try to load params


    function loadparams(varargin)
        
        params=ficedula_loadparams;
        
        
        %  try
        set(main.text_00a,'string',['folder of recordings: '  params.lastpath_songcut]);
        %end
        %try
        set(main.text_00b,'string',['folder of songs: '  params.lastpath_segment]);
        %end
        %try
        set(main.text_00c,'string',['folder of data: '  params.lastpath_data]);
        %end
        if isempty(params.lastpath_songcut); return; end
        
        %%% showing project data
        
        % number of recordings
        number_rec=length(dir([params.lastpath_songcut '*.wav']));
        
        
        set(main.text_01a, 'string',['number of recordings: ' num2str(number_rec)]);
        
        % cutting results
        
        results=ficedula_load_results_cutting(params.lastpath_data);
        number_rec_cut=length(results);
        
        set(main.text_01b, 'string',['number of recordings cut: ' num2str(number_rec_cut)]);
        
        
        for i=1:number_rec_cut
            num_song1(i)=length(results(i).x1);
        end
                
        if number_rec_cut>0
            number_songs=sum(num_song1);
        else
            number_songs=0;
            return
        end
               
        set(main.text_01c, 'string',['number of songs cut: ' num2str(number_songs)]);
        
        
                % songlibrary exist?
                files=dir([params.lastpath_data 'songlibrary.mat']);
                if length(files); str='yes'; else; str='no';  end
                set(main.text_02, 'string',['song library prepared: ' str]);
        
                % segmentation results
        
                results=ficedula_load_results_segmentation(params.lastpath_data);
                if isempty(results); return; end
                for i=1:length(results)
                    num_sylls1(i)=length(results(i).x1);
                end
                num_sylls_segmented=sum(num_sylls1);
                set(main.text_03a,'string',['number of songs segmented: ', num2str(length(results))]);
                set(main.text_03b,'string',['number of syllables resulted: ', num2str(num_sylls_segmented)]);
        
                % database_syllables_measured exist?
                files=dir([params.lastpath_data 'database_syllables_measured.mat']);
                if length(files); str='yes'; else; str='no';  end
                set(main.text_04, 'string',['syllables measured: ' str]);
        
                % number of recordings clustered
                results=ficedula_load_database_syllables_measured(params.lastpath_data);
                recs=unique(results(:,2));
                  num_rec_clust=0;
                for rec1=recs'
                    files=dir([params.lastpath_data rec1{1} '.mat']);
                     if ~isempty(files);  num_rec_clust=  num_rec_clust+1;end
                end
               
                 set(main.text_05, 'string',['number of recordings clustered: ' num2str(num_rec_clust)]);

        
        
        
                % database_syllables_measured_univ exist?
                files=dir([params.lastpath_data 'database_syllables_measured_univ.mat']);
               
                if ~isempty(files); str='yes'; else; str='no';  end
                set(main.text_07a,'string', ['prepared:' str])
        
        
    end

    function addpath_()
        
        addpath('00_functions\')
        addpath('01_songcut\')
        addpath('03_segmentation\')
        addpath('05_clustering\')
        
    end

    function buildfig()
        main.fig=figure('units','normalized','position',[0.1 0.1 0.8 0.8],'Name','Ficedula Toolbox for clustering syllables',...
            'menubar','none','Numbertitle','off','color',main.backcolor);
        
        %%% buttons %%%%%%%%%%%%%%%%%%%%
        bl=0.45;
        top=0.88;
        bl2=0.37;
        tl=0.03;
        tr=0.62;
        top2=top-0.015;
        
        %%% decoration %%%
        main.decor_cit=annotation('rectangle','Position',[0.05,0.03,0.9,0.1],'facecolor',colors4);
        
        main.decor0=annotation('rectangle','Position',[0.02,top-0.01,0.96,0.094],'facecolor',colors4);
        main.decor1=annotation('rectangle','Position',[0.02,top-0.11,0.96,0.094],'facecolor',colors4);
        main.decor2=annotation('rectangle','Position',[0.02,top-0.21,0.96,0.094],'facecolor',colors4);
        main.decor3=annotation('rectangle','Position',[0.02,top-0.31,0.96,0.094],'facecolor',colors4);
        main.decor4=annotation('rectangle','Position',[0.02,top-0.41,0.96,0.094],'facecolor',colors4);
        main.decor5=annotation('rectangle','Position',[0.02,top-0.51,0.96,0.094],'facecolor',colors4);
        main.decor6=annotation('rectangle','Position',[0.02,top-0.61,0.96,0.094],'facecolor',colors4);
        main.decor7=annotation('rectangle','Position',[0.02,top2-0.71,0.96,0.094],'facecolor',col2);
        
      
        
        main.but_setup=uicontrol('style','pushbutton','units','normalized','position',[bl top 0.15 0.07],...
            'string','setup','callback',{@setup_callback});
        
        main.but_songcut=uicontrol('style','pushbutton','units','normalized','position',[bl top-0.1 0.15 0.07],...
            'string','cut songs','callback',{@songcut_callback});
        
        main.but_songcut=uicontrol('style','pushbutton','units','normalized','position',[bl top-0.2 0.15 0.07],...
            'string','make songlibrary','callback',{@makesonglibrary_callback});
        
        main.but_segment=uicontrol('style','pushbutton','units','normalized','position',[bl top-0.3 0.15 0.07],...
            'string','segment syllables','callback',{@segmentation_callback});
        
        main.but_measure=uicontrol('style','pushbutton','units','normalized','position',[bl top-0.4 0.15 0.07],...
            'string','measure syllables','callback',{@measuring_callback});
        
        main.but_cluster=uicontrol('style','pushbutton','units','normalized','position',[bl top-0.5 0.15 0.07],...
            'string','cluster syllables','callback',{@clustering_callback});
        
        main.but_summary=uicontrol('style','pushbutton','units','normalized','position',[bl2 top-0.6 0.1 0.07],...
            'string','results','callback',{@summary_callback});
        main.but_sonograms_byrec=uicontrol('style','pushbutton','units','normalized','position',[bl2+0.11 top-0.6 0.1 0.07],...
            'string','sonograms by rec.','callback',{@sonograms_byrec_callback});
        main.but_sonograms_bycat=uicontrol('style','pushbutton','units','normalized','position',[bl2+0.22 top-0.6 0.1 0.07],...
            'string','sonograms by cat.','callback',{@sonograms_bycat_callback});
        
        main.but_univ_prep=uicontrol('style','pushbutton','units','normalized','position',[0.2 top2-0.7 0.1 0.05],...
            'string','prepare','callback',{@univ_prep_callback});
        main.but_univ_cluster=uicontrol('style','pushbutton','units','normalized','position',[0.47 top2-0.7 0.1 0.05],...
            'string','cluster','callback',{@univ_cluster_callback});
        
        main.but_univ_res=uicontrol('style','pushbutton','units','normalized','position',[0.67 top2-0.7 0.1 0.05],...
            'string','results','callback',{@univ_res_callback});
        %         main.but_univ_resbyrec=uicontrol('style','pushbutton','units','normalized','position',[0.74 top2-0.7 0.1 0.05],...
        %             'string','sonograms by rec.','callback',{@univ_resbyrec_callback});
        main.but_univ_resbycat=uicontrol('style','pushbutton','units','normalized','position',[0.80 top2-0.7 0.1 0.05],...
            'string','sonograms by cat.','callback',{@univ_resbycat_callback});
        
        main.but_manual=uicontrol('style','pushbutton','units','normalized','position',[bl+0.025 top-0.81 0.10 0.05],...
            'string','Manual','callback',{@manual_callback});
        
        %%% edit %%%
        %         main.edit_path_songs=uicontrol('style','edit','units','normalized','position',[0.15,0.93,0.2,0.03],'String','','callback',{@edit_path_song_callback},...
        %             'backgroundcolor',[0.6 1 0.6]);
        %         main.multiadd_check=uicontrol('style','checkbox','units','normalized','position',[0.48 0.49 0.05 0.02],...
        %             'string','multi add','backgroundcolor',main.textbackcolor);
        
        %%% text %%%
        
        main.text_00=uicontrol('style','text','units','normalized','position',[ tl top-0 0.4 0.05],'fontsize',11,...
            'string','00. Setting up the directories','backgroundcolor',main.textbackcolor,'foregroundcolor',main.textcolor,'horizontalalignment','right');
        main.text_01=uicontrol('style','text','units','normalized','position',[ tl+0.1 top-0.1 0.3 0.05],'fontsize',11,...
            'string','01. Cutting songs out from raw recordings','backgroundcolor',main.textbackcolor,'foregroundcolor',main.textcolor,'horizontalalignment','right');
        main.text_02=uicontrol('style','text','units','normalized','position',[ tl top-0.2 0.4 0.05],'fontsize',11,...
            'string','02. Preparing song library','backgroundcolor',main.textbackcolor,'foregroundcolor',main.textcolor,'horizontalalignment','right');
        main.text_03=uicontrol('style','text','units','normalized','position',[ tl top-0.3 0.4 0.05],'fontsize',11,...
            'string','03. Segmenting syllables from the cut out songs','backgroundcolor',main.textbackcolor,'foregroundcolor',main.textcolor,'horizontalalignment','right');
        main.text_04=uicontrol('style','text','units','normalized','position',[ tl top-0.4 0.4 0.05],'fontsize',11,...
            'string','04. Measuring syllables for clustering','backgroundcolor',main.textbackcolor,'foregroundcolor',main.textcolor,'horizontalalignment','right');
        main.text_05=uicontrol('style','text','units','normalized','position',[ tl top-0.5 0.4 0.05],'fontsize',11,...
            'string','05. Manual clustering with computer aid','backgroundcolor',main.textbackcolor,'foregroundcolor',main.textcolor,'horizontalalignment','right');
        
        main.text_06=uicontrol('style','text','units','normalized','position',[ tl top-0.6 0.3 0.06],'fontsize',11,...
            'string','06. Showing the results of the clustering','backgroundcolor',main.textbackcolor,'foregroundcolor',main.textcolor,'horizontalalignment','right');
        
        main.text_07=uicontrol('style','text','units','normalized','position',[ 0.18 top2-0.65 0.2 0.03],'fontsize',10,...
            'string','07. Prepare universal clustering','backgroundcolor',col2,'foregroundcolor',main.textcolor,'horizontalalignment','left');
        
        main.text_08=uicontrol('style','text','units','normalized','position',[ 0.47 top2-0.65 0.2 0.03],'fontsize',10,...
            'string','08. Universal clustering','backgroundcolor',col2,'foregroundcolor',main.textcolor,'horizontalalignment','left');
        
        main.text_09=uicontrol('style','text','units','normalized','position',[ 0.72 top2-0.65 0.2 0.03],'fontsize',10,...
            'string','09. Universal clustering results','backgroundcolor',col2,'foregroundcolor',main.textcolor,'horizontalalignment','left');
        
        main.text_07a=uicontrol('style','text','units','normalized','position',[ 0.31 top2-0.685 0.1 0.020],'fontsize',9,...
            'string','prepared: no','backgroundcolor',col2,'foregroundcolor',main.textcolor,'horizontalalignment','left');
        
        
        
        main.text_citation=uicontrol('style','text','units','normalized','position',[0.1 0.04 0.8 0.02],'fontsize',9,...
            'string','Citation: Zsebok, S., ..... (2016) Ficedula Toolbox for manual syllable clustering with computer aid. Some Journal pp  ','backgroundcolor',colors4,'foregroundcolor',main.textcolor);
        
        main.text_00a=uicontrol('style','text','units','normalized','position',[ tr top+0.048 0.3 0.025],'fontsize',9,...
            'string','rec folder: -','backgroundcolor',main.textbackcolor,'foregroundcolor',main.textcolor,'horizontalalignment','left');
        main.text_00b=uicontrol('style','text','units','normalized','position',[ tr top+0.022 0.3 0.025],'fontsize',9,...
            'string','song folder: -','backgroundcolor',main.textbackcolor,'foregroundcolor',main.textcolor,'horizontalalignment','left');
        main.text_00c=uicontrol('style','text','units','normalized','position',[ tr top-0.005 0.3 0.025],'fontsize',9,...
            'string','data folder: -','backgroundcolor',main.textbackcolor,'foregroundcolor',main.textcolor,'horizontalalignment','left');
        
        main.text_01a=uicontrol('style','text','units','normalized','position',[ tr top-0.1+0.048 0.3 0.025],'fontsize',9,...
            'string','number of recordings: 0','backgroundcolor',main.textbackcolor,'foregroundcolor',main.textcolor,'horizontalalignment','left');
        main.text_01b=uicontrol('style','text','units','normalized','position',[ tr top-0.1+0.022 0.3 0.025],'fontsize',9,...
            'string','number of recordings cut: 0','backgroundcolor',main.textbackcolor,'foregroundcolor',main.textcolor,'horizontalalignment','left');
        main.text_01c=uicontrol('style','text','units','normalized','position',[ tr top-0.1-0.005 0.3 0.025],'fontsize',9,...
            'string','number of songs cut: 0','backgroundcolor',main.textbackcolor,'foregroundcolor',main.textcolor,'horizontalalignment','left');
        
        main.text_02=uicontrol('style','text','units','normalized','position',[ tr top-0.2+0.015 0.3 0.035],'fontsize',9,...
            'string','song library prepared: no.','backgroundcolor',main.textbackcolor,'foregroundcolor',main.textcolor,'horizontalalignment','left');
        
        main.text_03a=uicontrol('style','text','units','normalized','position',[ tr top-0.3+0.03 0.3 0.035],'fontsize',9,...
            'string','number of songs segmented: 0','backgroundcolor',main.textbackcolor,'foregroundcolor',main.textcolor,'horizontalalignment','left');
        main.text_03b=uicontrol('style','text','units','normalized','position',[ tr top-0.3 0.3 0.035],'fontsize',9,...
            'string','number of syllables resulted: 0','backgroundcolor',main.textbackcolor,'foregroundcolor',main.textcolor,'horizontalalignment','left');
        
        
        main.text_04=uicontrol('style','text','units','normalized','position',[ tr top-0.39 0.3 0.035],'fontsize',9,...
            'string','syllables measured: no','backgroundcolor',main.textbackcolor,'foregroundcolor',main.textcolor,'horizontalalignment','left');
        
        main.text_05=uicontrol('style','text','units','normalized','position',[ tr top-0.49 0.3 0.035],'fontsize',9,...
            'string','number of recordings clustered: 0','backgroundcolor',main.textbackcolor,'foregroundcolor',main.textcolor,'horizontalalignment','left');
        
          
        main.but_refresh=uicontrol('style','pushbutton','units','normalized','position',[0.05 top 0.08 0.07],...
            'string','refresh','callback',{@loadparams});
        
    end

    function setup_callback(src,evnt)
        
        %folder_reclibrary
        folder_reclibrary=uigetdir('','Select folder contining the recordings');
        
        if ~(folder_reclibrary(end)=='\');folder_reclibrary=[folder_reclibrary '\'];end
        
        %folder_songlibrary
        folder_songlibrary=uigetdir('','Select folder for the songs (the cut out songs will be placed here)');
        if ~(folder_songlibrary(end)=='\');folder_songlibrary=[folder_songlibrary '\'];end
        
        %folder_data
        folder_data=uigetdir('','Select folder for the resulting data files');
        if ~(folder_data(end)=='\');folder_data=[folder_data '\'];end
        
        %saving data
        if folder_reclibrary
            lastpath=[folder_reclibrary];
            %save('01_songcut\lastpath_songcut.mat','lastpath')
            save('lastpath_songcut.mat','lastpath')
            
            set(main.text_00a,'string',['folder of recordings: ' lastpath]);
        end
        
        if folder_songlibrary
            lastpath=[folder_songlibrary];
            %save('03_segmentation\lastpath_segment.mat','lastpath')
            %save('05_clustering\lastpath_segment.mat','lastpath')
            save('lastpath_segment.mat','lastpath')
            set(main.text_00b,'string',['folder of songs: ' lastpath]);
        end
        
        if folder_data
            lastpath=[folder_data];
            save('lastpath_data.mat','lastpath')
            set(main.text_00c,'string',['folder of data: ' lastpath]);
        end
        
        
        
        
        
    end

    function songcut_callback(src,evnt)
        params=ficedula_loadparams;
        path_data=params.lastpath_data;
        
        songcut_v1_2(path_data)
        
    end

    function makesonglibrary_callback(src,evnt)
        params=ficedula_loadparams;
        
        path_recordings=params.lastpath_songcut;
        path_songs=params.lastpath_segment;
        path_data=params.lastpath_data;
        results_songcut=[path_data 'results_songcut.mat'];
        ficedula_make_songlibrary(path_recordings,path_songs,path_data,results_songcut)
        loadparams()
    end

    function segmentation_callback(src,evnt)
        params=ficedula_loadparams;
        path_data=params.lastpath_data;
        
        segmentation_v3(path_data)
    end

    function measuring_callback(src,evnt)
        
        %make syllable library
        params=ficedula_loadparams;
        path_songs=params.lastpath_segment;
        path_data=params.lastpath_data;
        resultsfilename=[path_data 'results_segmentation.mat'];
        ficedula_make_syllable_database(path_data,resultsfilename)
        
        %make measurments
        ficedula_make_measurements(path_songs,path_data)
          loadparams()
    end

    function clustering_callback(src,evnt)
        params=ficedula_loadparams;
        path_songs=params.lastpath_segment;
        path_data=params.lastpath_data;
        
        csoportositas5(path_songs,path_data,'individual')
    end

    function summary_callback(src,evnt)
        params=ficedula_loadparams;
        path_data=params.lastpath_data;
        
        ficedula_make_results_categorized(path_data)
        ficedula_make_summary_song(path_data)
        
    end

    function sonograms_byrec_callback(src,evnt)
        params=ficedula_loadparams;
        
        path_data=params.lastpath_data;
        path_songs=params.lastpath_segment;
        
        ficedula_sonograms_by_recording(path_songs,path_data)
    end

    function sonograms_bycat_callback(src,evnt)
        params=ficedula_loadparams;
        
        path_data=params.lastpath_data;
        path_songs=params.lastpath_segment;
        
        ficedula_sonograms_by_category(path_songs,path_data)
        
    end

    function univ_prep_callback(src,evnt)
        %make syllable library
        params=ficedula_loadparams;
        %path_songs=params.lastpath_segment;
        path_data=params.lastpath_data;
        %resultsfilename=[path_data 'results_segmentation.mat'];
        
        ficedula_univ_database_maker(path_data)
          loadparams()
    end


    function univ_cluster_callback(src,evnt)
        params=ficedula_loadparams;
        path_songs=params.lastpath_segment;
        path_data=params.lastpath_data;
        
        csoportositas5(path_songs,path_data,'universal')
    end



    function univ_res_callback(src,evnt)
        
        params=ficedula_loadparams;
        path_data=params.lastpath_data;
        
        ficedula_make_results_univ_categorized(path_data)
        %summary in table
        ficedula_make_summary_univ(path_data)
        
    end


%     function univ_resbyrec_callback(src,evnt)
%         %generate pics
%         params=ficedula_loadparams;
%         path_data=params.lastpath_data;
%         path_songs=params.lastpath_segment;
%
%         ficedula_sonograms_by_recording_univ(path_songs,path_data)
%
%
%     end


    function univ_resbycat_callback(src,evnt)
        %generate pics
        params=ficedula_loadparams;
        path_data=params.lastpath_data;
        path_songs=params.lastpath_segment;
        
        ficedula_sonograms_by_category_univ(path_songs,path_data)
        
    end


    function manual_callback(src,evnt)
        open('Manual.pdf')
    end
end