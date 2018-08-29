function varargout = songcut_v1_2(varargin)
% SONGCUT_V1_2 M-file for songcut_v1_2.fig
%      SONGCUT_V1_2, by itself, creates a new SONGCUT_V1_2 or raises the existing
%      singleton*.
%
%      H = SONGCUT_V1_2 returns the handle to a new SONGCUT_V1_2 or the handle to
%      the existing singleton*.
%
%      SONGCUT_V1_2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SONGCUT_V1_2.M with the given input arguments.
%
%      SONGCUT_V1_2('Property','Value',...) creates a new SONGCUT_V1_2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before szegmentalas1_OpeningFunction gets called.
%      An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to songcut_v1_2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help songcut_v1_2

% Last Modified by GUIDE v2.5 10-Aug-2017 14:26:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @songcut_v1_2_OpeningFcn, ...
    'gui_OutputFcn',  @songcut_v1_2_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
    
 end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

%main
% --- Executes just before songcut_v1_2 is made visible.
function songcut_v1_2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to songcut_v1_2 (see VARARGIN)
%gui_State.gui_Callback
%path1
%main

% Choose default command line output for songcut_v1_2
handles.output = hObject;
nargin
if nargin>3
handles.path_data=varargin{1};
else
    handles.path_data='';
end
warning off
handles.mutato=0; 
handles.xj1=[];
handles.xj2=[];

handles.leptek=100;
handles.timewindow0=10; %starting window length in sec

handles.ylim_min=0; % the minumum frequency on the spectrogram in Hz
handles.ylim_max=12000; % the maximum frequency on the spectrogram in Hz

handles.spec_fft=1024;
handles.spec_window=hann(1024);
handles.spec_overlap=900;

try
    load lastpath_songcut
    set(handles.edit_path,'string',lastpath)
catch
    
end

set(handles.figure1,'CloseRequestFcn',@myclosefcn)


guidata(hObject, handles);

 function myclosefcn(src,evnt)
        
        choice=questdlg('What do you want?', 'Warning', 'Go back to the program', 'Close the program' ,'Go back to the program');
        
        switch choice
            case 'Go back to the program'
                return
            case 'Close the program'
                delete(gcf)
               
        end
    


% --- Outputs from this function are returned to the command line.
function varargout = songcut_v1_2_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure

varargout{1} = handles.output;


% --- Executes on button press in proba.
function proba_Callback(hObject, eventdata, handles)
% hObject    handle to proba (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
'recording is loading'
handles.timewindow=handles.timewindow0;
handles.xj1=[];
handles.xj2=[];
handles.yj1=[];
handles.yj2=[];

handles.label=[];
handles.mutato=0;


try
    delete(handles.subplot1)
    delete(handles.subplot3)
end

filenev=[handles.konyvtar handles.fajlok(handles.filemutato).name];
csakfilenev=handles.fajlok(handles.filemutato).name;


handles.filenev=filenev;

handles.csakfilenev=csakfilenev;

info1=audioinfo(filenev);
siz=info1.TotalSamples;

handles.adatsize=siz(1);
n1=floor(linspace(1,siz(1),1000));
n1l=n1(2)-n1(1);
y=[];

for i=n1(1:end-1)
    [y1,Fs]=audioread(filenev,[i i+n1l]);
    y=[y;max(y1);min(y1)];
end

handles.adatrajz=y;


%% checking for stereo - for stereo recordings it should be edited
%if size(handles.adat,2)>1
%    handles.adat=handles.adat(:,1);
%end
handles.leptek=(n1(2)-n1(1))/2;
%% normalizing

%handles.adat=adat;
%b=1:handles.leptek:length(handles.adat);
%handles.adatrajz=handles.adat(b);

%%


handles.Fs=Fs;
handles.adat=0;


timewindow=handles.timewindow;
if siz/Fs<timewindow; timewindow=siz/Fs; end;

x1=1;
x2=handles.Fs*timewindow;
handles.x1=x1;
handles.x2=x2;
guidata(hObject, handles);



%% if it is in the database load it

try
    load([handles.path_data 'results_songcut.mat'])
    eredmeny=results_songcut;
    meret=length(eredmeny);
    pozicio=0;
    for i=1:meret
        k = strcmp(handles.csakfilenev, eredmeny(i).filenev);
        if k==1
            pozicio=i;
            handles.Fs=eredmeny(pozicio).Fs;
            handles.xj1=eredmeny(pozicio).x1;
            handles.xj2=eredmeny(pozicio).x2;
            handles.yj1=eredmeny(pozicio).y1;
            handles.yj2=eredmeny(pozicio).y2;
            
            handles.label=eredmeny(pozicio).label;
            handles.mutato=length(handles.xj1);
        end
    end
end

handles.subplot1=subplot('position',[0.070 0.300 0.820 0.500]);
handles.subplot3=subplot('position',[0.070 0.07 0.820 0.15]);



kezdorajz(hObject,eventdata,handles)
handles = guidata(hObject);

jelolesekfelvitele(hObject, eventdata, handles)
handles = guidata(hObject);

'recording is loaded'

Fs=handles.Fs;
handles.player=audioplayer(handles.adat,Fs);
setappdata(hObject, 'theAudioPlayer', handles.player);
setappdata(hObject, 'theAudioRecorder', []);
subplot(handles.subplot1)
cursor=line([0 0],[0 24000],'color','r','linewidth',4);
data1.cursor=cursor;
data1.Fs=Fs; data1.adjust=str2num(get(handles.edit_adjust,'String'));
set(handles.player, 'UserData', data1, 'TimerPeriod', 0.01, 'TimerFcn',@update_audio_position);
set(handles.player, 'UserData', data1, 'StopFcn',@stop_audio);

uicontrol(handles.jelolesbutton)
guidata(hObject, handles);





function playbutton_Callback(hObject, eventdata, handles)
% hObject    handle to playbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


Fs=handles.Fs;

handles.player=audioplayer(handles.adat,handles.Fs);

setappdata(hObject, 'theAudioPlayer', handles.player);
setappdata(hObject, 'theAudioRecorder', []);
subplot(handles.subplot1)
cursor=line([0 0],[0 24000],'color','r','linewidth',4);
data1.cursor=cursor;
data1.Fs=Fs; data1.adjust=str2num(get(handles.edit_adjust,'String'));
set(handles.player, 'UserData', data1, 'TimerPeriod', 0.01, 'TimerFcn',@update_audio_position);
set(handles.player, 'UserData', data1, 'StopFcn',@stop_audio);

longplay=1;


play(handles.player,longplay);

guidata(hObject, handles);



% --- Executes on button press in elorebutton.
function elorebutton_Callback(hObject, eventdata, handles)
% hObject    handle to elorebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

x1=handles.x1+(handles.x2-handles.x1);
x2=handles.x2+(handles.x2-handles.x1);

if x2>(handles.adatsize)
    x2=handles.adatsize;
    x1=handles.adatsize-(handles.x2-handles.x1);
end

handles.x1=x1;
handles.x2=x2;


guidata(hObject, handles);

stop(handles.player);

kezdorajz(hObject, eventdata, handles)
handles = guidata(hObject);



Fs=handles.Fs;
handles.player=audioplayer(handles.adat,Fs);
setappdata(hObject, 'theAudioPlayer', handles.player);
setappdata(hObject, 'theAudioRecorder', []);
subplot(handles.subplot1)
cursor=line([0 0],[0 24000],'color','r','linewidth',4);
data1.cursor=cursor;
data1.Fs=Fs;
data1.adjust=str2num(get(handles.edit_adjust,'String'));
set(handles.player, 'UserData', data1, 'TimerPeriod', 0.01, 'TimerFcn',@update_audio_position);
set(handles.player, 'UserData', data1, 'StopFcn',@stop_audio);

jelolesekfelvitele(hObject, eventdata, handles)

if get(handles.checkbox_autoplay,'value')
    play(handles.player);
end

guidata(hObject, handles);



% --- Executes on button press in jelolesbutton.
function jelolesbutton_Callback(hObject, eventdata, handles)
% hObject    handle to jelolesbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


mehet=0;
while mehet==0
    [xi,yi,but] = ginput(1);
    if but==1;
        mehet=1;
        x1=xi;
        y1=yi;
        subplot(handles.subplot1);
    end
end

mehet=0;
while mehet==0
    [xi,yi,but] = ginput(1);
    
    if but==3
        
        mehet=1;
        x2=xi;
        y2=yi;
    end
    
end
hold on
plot([x1 x1],[y1 y2],'k-','Linewidth',2)
plot([x2 x2],[y1 y2],'k-','Linewidth',2)
plot([x1 x2],[y1 y1],'k-','Linewidth',2)
plot([x2 x1],[y2 y2],'k-','Linewidth',2)

hold off

handles.mutato=handles.mutato+1;
handles.xj1(handles.mutato)=x1*handles.Fs+handles.x1;
handles.xj2(handles.mutato)=x2*handles.Fs+handles.x1;
handles.yj1(handles.mutato)=y1;
handles.yj2(handles.mutato)=y2;

set(handles.text_number,'String',num2str(length(handles.xj1)))
guidata(hObject, handles);


% --- Executes on button press in hatrabutton.
function hatrabutton_Callback(hObject, eventdata, handles)
% hObject    handle to hatrabutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

x1=handles.x1-(handles.x2-handles.x1);
x2=handles.x2-(handles.x2-handles.x1);

if x1<1
    x2=(handles.x2-handles.x1);
    x1=1;
end

handles.x1=x1;
handles.x2=x2;

guidata(hObject, handles);
stop(handles.player);
kezdorajz(hObject, eventdata, handles)
handles = guidata(hObject);


Fs=handles.Fs;
handles.player=audioplayer(handles.adat,Fs);
setappdata(hObject, 'theAudioPlayer', handles.player);
setappdata(hObject, 'theAudioRecorder', []);
subplot(handles.subplot1)
cursor=line([0 0],[0 24000],'color','r','linewidth',4);
data1.cursor=cursor;
data1.Fs=Fs;
data1.adjust=str2num(get(handles.edit_adjust,'String'));
set(handles.player, 'UserData', data1, 'TimerPeriod', 0.01, 'TimerFcn',@update_audio_position);
set(handles.player, 'UserData', data1, 'StopFcn',@stop_audio);

jelolesekfelvitele(hObject, eventdata, handles)


guidata(hObject, handles);

function stop_audio(hObject,UserData)
%if hObject.isplaying, % only do this if playback is in progress
%currentx=(get(hObject, 'CurrentSample') / get(hObject,'SampleRate'));
%hObject
data = get(hObject,'UserData');

delete (data.cursor)




function update_audio_position(hObject,UserData)


if hObject.isplaying, % only do this if playback is in progress
    
    currentx=(get(hObject, 'CurrentSample') / get(hObject,'SampleRate'));
    data = get(hObject,'UserData');
    
    
    set(data.cursor,'XData',[currentx+data.adjust currentx+data.adjust]);% only x values change
    
end


function jelolesekfelvitele(hObject, eventdata, handles)

pack


if length(handles.xj1)>0
    
    subplot(handles.subplot1)
    hold on
    for i=1:length(handles.xj1)
        
        if handles.xj1(i)>=handles.x1 && handles.xj2(i)<handles.x2
            x1=(handles.xj1(i)-handles.x1)/handles.Fs;
            x2=(handles.xj2(i)-handles.x1)/handles.Fs;
            
            y1=handles.yj1(i);
            y2=handles.yj2(i);
            plot([x1 x1],[y1 y2],'k-','Linewidth',2)
            plot([x2 x2],[y1 y2],'k-','Linewidth',2)
            plot([x1 x2],[y1 y1],'k-','Linewidth',2)
            plot([x2 x1],[y2 y2],'k-','Linewidth',2)
        end
        
         if handles.xj1(i)>=handles.x1 && handles.xj2(i)>=handles.x2
            x1=(handles.xj1(i)-handles.x1)/handles.Fs;
            x2=(handles.x2-handles.x1)/handles.Fs;
            
            y1=handles.yj1(i);
            y2=handles.yj2(i);
            plot([x1 x1],[y1 y2],'k-','Linewidth',2)
           
            plot([x1 x2],[y1 y1],'k-','Linewidth',2)
            plot([x2 x1],[y2 y2],'k-','Linewidth',2)
         end
        
         if handles.xj1(i)<handles.x1 && handles.xj2(i)<handles.x2
            x1=0;
            x2=(handles.xj2(i)-handles.x1)/handles.Fs;
            
            y1=handles.yj1(i);
            y2=handles.yj2(i);
           
            plot([x2 x2],[y1 y2],'k-','Linewidth',2)
            plot([x1 x2],[y1 y1],'k-','Linewidth',2)
            plot([x2 x1],[y2 y2],'k-','Linewidth',2)
        end
         
    end
    
    hold off
    
end
guidata(hObject, handles);


% --- Executes on button press in torlesbutton.
function torlesbutton_Callback(hObject, eventdata, handles)
% hObject    handle to torlesbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[xi,yi,but] = ginput(1);

xi0=xi*handles.Fs+handles.x1;
mutato=0;
for i=1:length(handles.xj1)
    if handles.xj1(i)<xi0 && handles.xj2(i)>xi0
        mutato=i;
    end
end
if mutato~=0
    handles.xj1(mutato)=[];
    handles.xj2(mutato)=[];
    handles.yj1(mutato)=[];
    handles.yj2(mutato)=[];
    
    handles.label(mutato)=0;
    handles.mutato=handles.mutato-1;
    guidata(hObject, handles);
    
    
    kezdorajz(hObject, eventdata, handles)
    handles = guidata(hObject);
end
guidata(hObject, handles);
jelolesekfelvitele(hObject, eventdata, handles)


function konyvtarbeolvasas(hObject, eventdata, handles)

handles.fajlok=dir([handles.konyvtar '*.wav']);
handles.filemutato=1;
set(handles.text1,'String',[num2str(handles.filemutato) '.  ' handles.fajlok(handles.filemutato).name])

guidata(hObject, handles);

% --- Executes on button press in fileelore.
function fileelore_Callback(hObject, eventdata, handles)
% hObject    handle to fileelore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.filemutato=handles.filemutato+1;

if handles.filemutato>length(handles.fajlok)
    handles.filemutato=handles.filemutato-1;
end
set(handles.text1,'String',[num2str(handles.filemutato) '.  ' handles.fajlok(handles.filemutato).name])

guidata(hObject, handles);

function fileelore2_Callback(hObject, eventdata, handles)
% hObject    handle to fileelore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.filemutato=handles.filemutato+20;

if handles.filemutato>length(handles.fajlok)
    handles.filemutato=length(handles.fajlok);
end
set(handles.text1,'String',[num2str(handles.filemutato) '.  ' handles.fajlok(handles.filemutato).name])

guidata(hObject, handles);

% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in filehatra.
function filehatra_Callback(hObject, eventdata, handles)
% hObject    handle to filehatra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.filemutato=handles.filemutato-1;

if handles.filemutato<1
    handles.filemutato=1;
end
set(handles.text1,'String',[num2str(handles.filemutato) '.  ' handles.fajlok(handles.filemutato).name])

guidata(hObject, handles);

function filehatra2_Callback(hObject, eventdata, handles)
% hObject    handle to filehatra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.filemutato=handles.filemutato-20;

if handles.filemutato<1
    handles.filemutato=1;
end
set(handles.text1,'String',[num2str(handles.filemutato) '.  ' handles.fajlok(handles.filemutato).name])

guidata(hObject, handles);


% --- Executes on button press in mentesbutton.
function mentesbutton_Callback(hObject, eventdata, handles)
% hObject    handle to mentesbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
    load([handles.path_data 'results_songcut.mat'])
    eredmeny=results_songcut;
    meret=length(eredmeny);
    pozicio=0;
    for i=1:meret
        k = strcmp(handles.csakfilenev, eredmeny(i).filenev);
        if k==1
            pozicio=i;
        end
    end
    if pozicio==0
        pozicio=meret+1;
    end
    
catch
    pozicio=1;
    
end
eredmeny(pozicio)=struct('filenev',handles.csakfilenev,'Fs',handles.Fs,'x1',handles.xj1,'x2',handles.xj2,...
    'y1',handles.yj1,'y2',handles.yj2,'label',handles.label);

results_songcut=eredmeny;
save([handles.path_data 'results_songcut.mat'], 'results_songcut')

[handles.csakfilenev ' data saved!']





% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
jelolesbutton_Callback(hObject, eventdata, handles)

guidata(hObject, handles);

function kezdorajz(hObject,eventdata,handles)


x1=floor(handles.x1);
x2=floor(handles.x2);

handles.adat=audioread(handles.filenev,[x1 x2]);

handles.adat=(handles.adat/max(handles.adat))*0.7;



subplot(handles.subplot1);


%% spectrogram

adat002=handles.adat;

specgram(adat002,handles.spec_fft,handles.Fs,handles.spec_window,handles.spec_overlap); %xlim([x1 x2])


%%%%%%
nl=11;
lepesertek=0.1;
kezdoertek=0;
while nl>10
    kezdoertek=kezdoertek+lepesertek;
    probavektor=0:kezdoertek:(x2-x1)/handles.Fs;
    nl=length(probavektor);
end

 xtick1=0:kezdoertek:(x2-x1)/handles.Fs;
 xticklabel1=floor(x1/handles.Fs*100)/100+(0:kezdoertek:(x2-x1)/handles.Fs);

set(gca,'xtick',xtick1)
set(gca,'xticklabel',xticklabel1)


set(gca,'ytick',0:1000:13000)
set(gca,'yticklabel',(0:1000:13000))

ylabel('frequency (Hz)')
xlabel('')
ylim([handles.ylim_min handles.ylim_max])


subplot(handles.subplot3)
cla

plot(handles.adatrajz,'g'); xlim([1 length(handles.adatrajz)])

ylims=get(gca,'ylim');
hold on

plot([handles.x1/handles.leptek handles.x1/handles.leptek],[ylims(1) ylims(2)],'k-','linewidth',3)
plot([handles.x2/handles.leptek handles.x2/handles.leptek],[ylims(1) ylims(2)],'r-','linewidth',3)

ylabel('amplitude')
xlabel('time (s)')

nl=11;
lepesertek=0.1*handles.Fs;
kezdoertek=0;
while nl>10
    kezdoertek=kezdoertek+lepesertek;
    probavektor=0:kezdoertek:handles.adatsize;
    nl=length(probavektor);
    
end

 xtick1=(0:kezdoertek/handles.leptek:handles.adatsize);
 xticklabel1=(0:kezdoertek/handles.Fs:handles.adatsize/handles.Fs);


set(gca,'xtick',xtick1)
set(gca,'xticklabel',xticklabel1)
 


set(handles.text_number,'String',['Songs: ' num2str(length(handles.xj1))])
guidata(hObject, handles);


% --- Executes on button press in zoomin_button.
function zoomin_button_Callback(hObject, eventdata, handles)
% hObject    handle to zoomin_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stop(handles.player);


handles.timewindow=handles.timewindow/3;
handles.x1=handles.x1+handles.timewindow*handles.Fs;
handles.x2=handles.x1+handles.timewindow*handles.Fs;

guidata(hObject, handles);
kezdorajz(hObject, eventdata, handles)
handles = guidata(hObject);

Fs=handles.Fs;
handles.player=audioplayer(handles.adat,Fs);
setappdata(hObject, 'theAudioPlayer', handles.player);
setappdata(hObject, 'theAudioRecorder', []);
subplot(handles.subplot1)
cursor=line([0 0],[0 20000],'color','r','linewidth',4);
data1.cursor=cursor;
data1.Fs=Fs; data1.adjust=str2num(get(handles.edit_adjust,'String'));
set(handles.player, 'UserData', data1, 'TimerPeriod', 0.01, 'TimerFcn',@update_audio_position);
set(handles.player, 'UserData', data1, 'StopFcn',@stop_audio);



play(handles.player);
jelolesekfelvitele(hObject, eventdata, handles)
guidata(hObject, handles);

% --- Executes on button press in zoomout_button.
function zoomout_button_Callback(hObject, eventdata, handles)
% hObject    handle to zoomout_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stop(handles.player);
handles.x1=handles.x1-handles.timewindow*handles.Fs;
handles.x2=handles.x2+handles.timewindow*handles.Fs;

if handles.adatsize<=handles.x2; handles.x2=handles.adatsize; end;
if 1>=handles.x1; handles.x1=1; end;


handles.timewindow=(handles.x2-handles.x1)/handles.Fs;

x1=handles.x1;
x2=handles.x2;



guidata(hObject, handles);
kezdorajz(hObject, eventdata, handles)
handles = guidata(hObject);

Fs=handles.Fs;
handles.player=audioplayer(handles.adat,Fs);
setappdata(hObject, 'theAudioPlayer', handles.player);
setappdata(hObject, 'theAudioRecorder', []);
subplot(handles.subplot1)
cursor=line([0 0],[0 20000],'color','r','linewidth',4);
data1.cursor=cursor;
data1.Fs=Fs; data1.adjust=str2num(get(handles.edit_adjust,'String'));
set(handles.player, 'UserData', data1, 'TimerPeriod', 0.01, 'TimerFcn',@update_audio_position);
set(handles.player, 'UserData', data1, 'StopFcn',@stop_audio);


play(handles.player);
jelolesekfelvitele(hObject, eventdata, handles)
guidata(hObject, handles);



% --- Executes on button press in zoom2_button.
function zoom2_button_Callback(hObject, eventdata, handles)
% hObject    handle to zoom2_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stop(handles.player);
but=1;
while but==1
    [xi,yi,but] = ginput(1);
    if but==1
        xi1=xi;
        x1=xi1*handles.Fs;
        
        
    else
        xi2=xi;
        x2=xi2*handles.Fs;
        
        handles.x2=handles.x1+x2;
        x2uj=handles.x2;
        
        
        handles.x1=handles.x1+x1;
        x1uj=handles.x1;
        
        
        handles.timewindow=(handles.x2-handles.x1)/handles.Fs;
        guidata(hObject, handles);
        
        kezdorajz(hObject, eventdata, handles)
        handles = guidata(hObject);
  
        Fs=handles.Fs;
        handles.player=audioplayer(handles.adat,Fs);
        setappdata(hObject, 'theAudioPlayer', handles.player);
        setappdata(hObject, 'theAudioRecorder', []);
        subplot(handles.subplot1)
        cursor=line([0 0],[0 20000],'color','r','linewidth',4);
        data1.cursor=cursor;
        data1.Fs=Fs; data1.adjust=str2num(get(handles.edit_adjust,'String'));
        set(handles.player, 'UserData', data1, 'TimerPeriod', 0.01, 'TimerFcn',@update_audio_position);
        set(handles.player, 'UserData', data1, 'StopFcn',@stop_audio);
        
        
        play(handles.player);
        
    end
    
end
guidata(hObject, handles);
jelolesekfelvitele(hObject, eventdata, handles)






% --- Executes during object creation, after setting all properties.
function edit_path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in button_path.
function button_path_Callback(hObject, eventdata, handles)
% hObject    handle to button_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



handles.konyvtar=get(handles.edit_path,'string');
if ~(handles.konyvtar(end)=='\')
    handles.konyvtar=[handles.konyvtar '\'];
end
set(handles.edit_path,'string',handles.konyvtar);

lastpath=handles.konyvtar;
save('lastpath_songcut.mat', 'lastpath')
guidata(hObject, handles);
konyvtarbeolvasas(hObject, eventdata, handles)


% --- Executes on button press in hey.
function hey_Callback(hObject, eventdata, handles)
% hObject    handle to hey (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.subplot1
delete(handles.subplot1)


% --- Executes on button press in zoom_full_button.
function zoom_full_button_Callback(hObject, eventdata, handles)
% hObject    handle to zoom_full_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stop(handles.player);
handles.x1=1;
handles.x2=handles.adatsize;

handles.timewindow=(handles.x2-handles.x1)/handles.Fs;

x1=handles.x1;
x2=handles.x2;

guidata(hObject, handles);
kezdorajz(hObject, eventdata, handles)
handles = guidata(hObject);

Fs=handles.Fs;
handles.player=audioplayer(handles.adat,Fs);
setappdata(hObject, 'theAudioPlayer', handles.player);
setappdata(hObject, 'theAudioRecorder', []);
subplot(handles.subplot1)
cursor=line([0 0],[0 20000],'color','r','linewidth',4);
data1.cursor=cursor;
data1.Fs=Fs;
data1.adjust=str2num(get(handles.edit_adjust,'String'));
set(handles.player, 'UserData', data1, 'TimerPeriod', 0.01, 'TimerFcn',@update_audio_position);
set(handles.player, 'UserData', data1, 'StopFcn',@stop_audio);



jelolesekfelvitele(hObject, eventdata, handles)
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function edit_adjust_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_adjust (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in stopbutton.
function stopbutton_Callback(hObject, eventdata, handles)
% hObject    handle to stopbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stop(handles.player);


% --- Executes on button press in hatrabutton2.
function hatrabutton2_Callback(hObject, eventdata, handles)
% hObject    handle to hatrabutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

x1=handles.x1-(handles.x2-handles.x1)*5;
x2=handles.x2-(handles.x2-handles.x1)*5;

if x1<1
    x2=(handles.x2-handles.x1);
    x1=1;
end

handles.x1=x1;
handles.x2=x2;

guidata(hObject, handles);
stop(handles.player);
kezdorajz(hObject, eventdata, handles)
handles = guidata(hObject);

Fs=handles.Fs;
handles.player=audioplayer(handles.adat,Fs);
setappdata(hObject, 'theAudioPlayer', handles.player);
setappdata(hObject, 'theAudioRecorder', []);
subplot(handles.subplot1)
cursor=line([0 0],[0 24000],'color','r','linewidth',4);
data1.cursor=cursor;
data1.Fs=Fs;
data1.adjust=str2num(get(handles.edit_adjust,'String'));
set(handles.player, 'UserData', data1, 'TimerPeriod', 0.01, 'TimerFcn',@update_audio_position);
set(handles.player, 'UserData', data1, 'StopFcn',@stop_audio);

jelolesekfelvitele(hObject, eventdata, handles)


guidata(hObject, handles);

% --- Executes on button press in elorebutton2.
function elorebutton2_Callback(hObject, eventdata, handles)
% hObject    handle to elorebutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

x1=handles.x1+(handles.x2-handles.x1)*5;
x2=handles.x2+(handles.x2-handles.x1)*5;

if x2>handles.adatsize
    x2=handles.adatsize;
    x1=handles.adatsize-(handles.x2-handles.x1);
end

handles.x1=x1;
handles.x2=x2;


guidata(hObject, handles);

stop(handles.player);

kezdorajz(hObject, eventdata, handles)
handles = guidata(hObject);


Fs=handles.Fs;
handles.player=audioplayer(handles.adat,Fs);
setappdata(hObject, 'theAudioPlayer', handles.player);
setappdata(hObject, 'theAudioRecorder', []);
subplot(handles.subplot1)
cursor=line([0 0],[0 24000],'color','r','linewidth',4);
data1.cursor=cursor;
data1.Fs=Fs;
data1.adjust=str2num(get(handles.edit_adjust,'String'));
set(handles.player, 'UserData', data1, 'TimerPeriod', 0.01, 'TimerFcn',@update_audio_position);
set(handles.player, 'UserData', data1, 'StopFcn',@stop_audio);

jelolesekfelvitele(hObject, eventdata, handles)

if get(handles.checkbox_autoplay,'value')
    play(handles.player);
end

guidata(hObject, handles);

% --- Executes on button press in hatrabutton3.
function hatrabutton3_Callback(hObject, eventdata, handles)
% hObject    handle to hatrabutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

x1=handles.x1-(handles.x2-handles.x1)*1/5;
x2=handles.x2-(handles.x2-handles.x1)*1/5;

if x1<1
    x2=(handles.x2-handles.x1);
    x1=1;
end

handles.x1=x1;
handles.x2=x2;

guidata(hObject, handles);
stop(handles.player);
kezdorajz(hObject, eventdata, handles)
handles = guidata(hObject);


Fs=handles.Fs;
handles.player=audioplayer(handles.adat,Fs);
setappdata(hObject, 'theAudioPlayer', handles.player);
setappdata(hObject, 'theAudioRecorder', []);
subplot(handles.subplot1)
cursor=line([0 0],[0 24000],'color','r','linewidth',4);
data1.cursor=cursor;
data1.Fs=Fs;
data1.adjust=str2num(get(handles.edit_adjust,'String'));
set(handles.player, 'UserData', data1, 'TimerPeriod', 0.01, 'TimerFcn',@update_audio_position);
set(handles.player, 'UserData', data1, 'StopFcn',@stop_audio);

jelolesekfelvitele(hObject, eventdata, handles)


guidata(hObject, handles);

% --- Executes on button press in elorebutton3.
function elorebutton3_Callback(hObject, eventdata, handles)
% hObject    handle to elorebutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

x1=handles.x1+(handles.x2-handles.x1)*1/5;
x2=handles.x2+(handles.x2-handles.x1)*1/5;

if x2>handles.adatsize
    x2=handles.adatsize;
    x1=handles.adatsize-(handles.x2-handles.x1);
end

handles.x1=x1;
handles.x2=x2;


guidata(hObject, handles);

stop(handles.player);

kezdorajz(hObject, eventdata, handles)
handles = guidata(hObject);


Fs=handles.Fs;
handles.player=audioplayer(handles.adat,Fs);
setappdata(hObject, 'theAudioPlayer', handles.player);
setappdata(hObject, 'theAudioRecorder', []);
subplot(handles.subplot1)
cursor=line([0 0],[0 24000],'color','r','linewidth',4);
data1.cursor=cursor;
data1.Fs=Fs;
data1.adjust=str2num(get(handles.edit_adjust,'String'));
set(handles.player, 'UserData', data1, 'TimerPeriod', 0.01, 'TimerFcn',@update_audio_position);
set(handles.player, 'UserData', data1, 'StopFcn',@stop_audio);

jelolesekfelvitele(hObject, eventdata, handles)

if get(handles.checkbox_autoplay,'value')
    play(handles.player);
end

guidata(hObject, handles);



% --- Executes on button press in checkbox_autoplay.
function checkbox_autoplay_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_autoplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


