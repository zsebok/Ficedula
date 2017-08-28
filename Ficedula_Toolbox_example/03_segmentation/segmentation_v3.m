function varargout = segmentation_v3(varargin)
% SEGMENTATION_V3 M-file for segmentation_v3.fig
%      SEGMENTATION_V3, by itself, creates a new SEGMENTATION_V3 or raises the existing
%      singleton*.
%
%      H = SEGMENTATION_V3 returns the handle to a new SEGMENTATION_V3 or the handle to
%      the existing singleton*.
%
%      SEGMENTATION_V3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEGMENTATION_V3.M with the given input arguments.
%
%      SEGMENTATION_V3('Property','Value',...) creates a new SEGMENTATION_V3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before szegmentalas1_OpeningFunction gets called.
%      An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to segmentation_v3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help segmentation_v3

% Last Modified by GUIDE v2.5 27-Aug-2016 17:11:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @segmentation_v3_OpeningFcn, ...
    'gui_OutputFcn',  @segmentation_v3_OutputFcn, ...
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


% --- Executes just before segmentation_v3 is made visible.
function segmentation_v3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to segmentation_v3 (see VARARGIN)
%gui_State.gui_Callback
varargin
nargin
handles.output = hObject;
if nargin>3
handles.path_data=varargin{1};

else
    handles.path_data='';
end

warning off
handles.mutato=0; %kezdo file sorszáma
handles.xj1=[];
handles.xj2=[];

handles.leptek=1;

handles.timewindow0=3; % starting maximum window length in sec
handles.ylim_min=1000; %minimum frequency on spectrogram in Hz
handles.ylim_max=12000; %maximum frequency on spectrogram in Hz

%specgram(adat002,512,handles.Fs,hann(512),450); %xlim([x1 x2])

handles.spec_fft=512;
handles.spec_window=hann(512);
handles.spec_overlap=450;

try
   load lastpath_segment
   set(handles.edit_path,'string',lastpath)
catch
    
end
% Update handles structure
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
function varargout = segmentation_v3_OutputFcn(hObject, eventdata, handles)
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
handles.xj1=[];
handles.xj2=[];
handles.yj1=[];
handles.yj2=[];

handles.label=[];
handles.mutato=0;

%%
try 
   delete(handles.subplot1) 
   delete(handles.subplot3) 
end



filenev=[handles.konyvtar handles.fajlok(handles.filemutato).name];
csakfilenev=handles.fajlok(handles.filemutato).name;


handles.filenev=filenev;

handles.csakfilenev=csakfilenev;

[adat,Fs]=wavread(filenev);

%% checking for stereo
if size(adat,2)>1
    adat=adat(:,1);
end






%% normailizing
adat=(adat/max(adat))*0.7;

handles.adat=adat;

%%

b=1:handles.leptek:length(handles.adat);
handles.adatrajz=adat(b);

%%

handles.Fs=Fs;
timewindow=handles.timewindow0;

if length(adat)/Fs<timewindow; timewindow=length(adat)/Fs; end;
handles.timewindow=timewindow;
x1=1;
x2=handles.Fs*timewindow;
handles.x1=x1;
handles.x2=x2;
guidata(hObject, handles);


try
    load([handles.path_data 'results_segmentation.mat'])
    eredmeny=results;
    
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

kezdorajz(hObject, eventdata, handles)

jelolesekfelvitele(hObject, eventdata, handles)


adat=handles.adat;
Fs=handles.Fs;
handles.player=audioplayer(adat(x1:x2),Fs);
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






% --- Executes on button press in playbutton.
function playbutton_Callback(hObject, eventdata, handles)
% hObject    handle to playbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


adat=handles.adat;
Fs=handles.Fs;
%handles.player=audioplayer(adat(x1:x2),Fs);
handles.player=audioplayer(handles.adat(handles.x1:handles.x2),handles.Fs);

setappdata(hObject, 'theAudioPlayer', handles.player);
setappdata(hObject, 'theAudioRecorder', []);
subplot(handles.subplot1)
cursor=line([0 0],[0 24000],'color','r','linewidth',4);
data1.cursor=cursor;
data1.Fs=Fs; data1.adjust=str2num(get(handles.edit_adjust,'String'));
set(handles.player, 'UserData', data1, 'TimerPeriod', 0.01, 'TimerFcn',@update_audio_position);
set(handles.player, 'UserData', data1, 'StopFcn',@stop_audio);
%set(handles.player, 'UserData', data1, ,@update_audio_position);

%StopFcn
%cursor=line([0 0],[-((max(s))*1.1),((max(s))*1.1)],'color','k');


play(handles.player);
guidata(hObject, handles);




% --- Executes on button press in elorebutton.
function elorebutton_Callback(hObject, eventdata, handles)
% hObject    handle to elorebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

x1=handles.x1+(handles.x2-handles.x1)*2/3;
x2=handles.x2+(handles.x2-handles.x1)*2/3;

if x2>length(handles.adat)
    x2=length(handles.adat);
    x1=length(handles.adat)-(handles.x2-handles.x1);
end

handles.x1=x1;
handles.x2=x2;


guidata(hObject, handles);

kezdorajz(hObject, eventdata, handles)


adat=handles.adat;
Fs=handles.Fs;
handles.player=audioplayer(adat(x1:x2),Fs);
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



% --- Executes on button press in jelolesbutton.
function jelolesbutton_Callback(hObject, eventdata, handles)
% hObject    handle to jelolesbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%bal gomb
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

x1=handles.x1-(handles.x2-handles.x1)*2/3;
x2=handles.x2-(handles.x2-handles.x1)*2/3;

if x1<1
    x2=(handles.x2-handles.x1);
    x1=1;
end

handles.x1=x1;
handles.x2=x2;


guidata(hObject, handles);

kezdorajz(hObject, eventdata, handles)

adat=handles.adat;
Fs=handles.Fs;
handles.player=audioplayer(adat(x1:x2),Fs);
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
 
 %set(data.cursor,'XData',[currentx currentx]*data.Fs);% only x values change
set(data.cursor,'XData',[currentx+data.adjust currentx+data.adjust]);% only x values change

 end
 

function jelolesekfelvitele(hObject, eventdata, handles)

pack


if length(handles.xj1)>0
   
subplot(handles.subplot1)
hold on
    for i=1:length(handles.xj1)
       
        if handles.xj1(i)>handles.x1 && handles.xj1(i)<handles.x2
            x1=(handles.xj1(i)-handles.x1)/handles.Fs;

            x2=(handles.xj2(i)-handles.x1)/handles.Fs;

        y1=handles.yj1(i);
        y2=handles.yj2(i);
        plot([x1 x1],[y1 y2],'k-','Linewidth',2)
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


% --- Executes on button press in auto1button.
function auto1button_Callback(hObject, eventdata, handles)
% hObject    handle to auto1button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
adat=handles.adat;
lepes=1000;
tic
for i=1:lepes:length(adat)-lepes
    
    c(i)=(sum(abs(adat(i:i+lepes-1))))^2;
    
end
figure;
plot(c)
toc





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
    load([handles.path_data 'results_segmentation.mat'])
    eredmeny=results;
    
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
results=eredmeny;
save([handles.path_data 'results_segmentation.mat'],'results')

[handles.csakfilenev ' data saved!']





% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject, handles);
jelolesbutton_Callback(hObject, eventdata, handles)



function kezdorajz(hObject, eventdata, handles)



x1=handles.x1;
x2=handles.x2;

subplot(handles.subplot1);

adat001=handles.adat(x1:x2);
[b,a]= butter(3,2000*2/handles.Fs,'high');
adat002=filter(b,a,adat001);

handles.spec_fft=1024;
handles.spec_window=hann(1024);
handles.spec_overlap=900;

%specgram(adat002,512,handles.Fs,hann(512),450); %xlim([x1 x2])
specgram(adat002,handles.spec_fft,handles.Fs,handles.spec_window,handles.spec_overlap); %xlim([x1 x2])

%S1=specgram(adat002,512,handles.Fs,hann(512),450); %xlim([x1 x2])

set(gca,'xtick',0.001:0.2:(x2-x1)/handles.Fs)
set(gca,'xticklabel',floor(x1/handles.Fs*100)/100:0.2:x2/handles.Fs)

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

plot([handles.x1/handles.leptek handles.x1/handles.leptek],[ylims(1)+6 ylims(2)-6],'r-','linewidth',3)
plot([handles.x2/handles.leptek handles.x2/handles.leptek],[ylims(1)+6 ylims(2)-6],'r-','linewidth',3)
plot([handles.x1/handles.leptek handles.x2/handles.leptek],[ylims(1)+6 ylims(1)+6],'r-','linewidth',3)
plot([handles.x1/handles.leptek handles.x2/handles.leptek],[ylims(2)-6 ylims(2)-6],'r-','linewidth',3)

ylabel('amplitude')
xlabel('time')

nl=11;
lepesertek=0.1*handles.Fs;
kezdoertek=0;
while nl>10
    kezdoertek=kezdoertek+lepesertek;
    probavektor=0:kezdoertek:length(handles.adat);
nl=length(probavektor);

end

xtick1=0:kezdoertek:length(handles.adat);
xticklabel1=0:kezdoertek/handles.Fs:length(handles.adat)/handles.Fs;

set(gca,'xtick',xtick1)
set(gca,'xticklabel',xticklabel1)



set(handles.text_number,'String',['Syllables: ' num2str(length(handles.xj1))])
guidata(hObject, handles);


% --- Executes on button press in zoomin_button.
function zoomin_button_Callback(hObject, eventdata, handles)
% hObject    handle to zoomin_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


handles.timewindow=handles.timewindow/3;
handles.x1=handles.x1+handles.timewindow*handles.Fs;
handles.x2=handles.x1+handles.timewindow*handles.Fs;

guidata(hObject, handles);
kezdorajz(hObject, eventdata, handles)
adat=handles.adat;
Fs=handles.Fs;
handles.player=audioplayer(adat(handles.x1:handles.x2),Fs);
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

handles.x1=handles.x1-handles.timewindow*handles.Fs;
handles.x2=handles.x2+handles.timewindow*handles.Fs;

if length(handles.adat)<=handles.x2; handles.x2=length(handles.adat); end;
if 1>=handles.x1; handles.x1=1; end;


handles.timewindow=(handles.x2-handles.x1)/handles.Fs;

x1=handles.x1;
x2=handles.x2;




guidata(hObject, handles);
kezdorajz(hObject, eventdata, handles)
adat=handles.adat;
Fs=handles.Fs;
handles.player=audioplayer(adat(handles.x1:handles.x2),Fs);
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



% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in zoom2_button.
function zoom2_button_Callback(hObject, eventdata, handles)
% hObject    handle to zoom2_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
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
        
        adat=handles.adat;
Fs=handles.Fs;
handles.player=audioplayer(adat(handles.x1:handles.x2),Fs);
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






function edit_path_Callback(hObject, eventdata, handles)
% hObject    handle to edit_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_path as text
%        str2double(get(hObject,'String')) returns contents of edit_path as a double


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
%'c:\_munka\enekek\'

%get(handles.edit_path,'string')
%handles.konyvtar=get(handles.edit_path,'string');
folders0=dir(get(handles.edit_path,'string'));
folders1=folders0(3:end);
folders2=folders1([folders1.isdir]);
handles.folders=folders2;
handles.folders_num=1;
%handles.folders(handles.folders_num).name
set(handles.text_dir,'string',handles.folders(handles.folders_num).name);
guidata(hObject, handles);


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

handles.x1=1; 
handles.x2=length(handles.adat);

handles.timewindow=(handles.x2-handles.x1)/handles.Fs;

x1=handles.x1;
x2=handles.x2;

guidata(hObject, handles);
kezdorajz(hObject, eventdata, handles)

adat=handles.adat;
Fs=handles.Fs;
handles.player=audioplayer(adat(x1:x2),Fs);
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


function edit_adjust_Callback(hObject, eventdata, handles)
% hObject    handle to edit_adjust (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_adjust as text
%        str2double(get(hObject,'String')) returns contents of edit_adjust as a double


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




% --- Executes on button press in delete_all.
function delete_all_Callback(hObject, eventdata, handles)
% hObject    handle to delete_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%[xi,yi,but] = ginput(1);

%xi0=xi*handles.Fs+handles.x1;
%mutato=0;
% for i=1:length(handles.xj1)
%     if handles.xj1(i)<xi0 && handles.xj2(i)>xi0
%         mutato=i;
%     end
% end
%if mutato~=0
    handles.xj1=[];
    handles.xj2=[];
    handles.yj1=[];
    handles.yj2=[];
    
    handles.label=[];
    handles.mutato=0;
    guidata(hObject, handles);
    
  
    kezdorajz(hObject, eventdata, handles)
%end
guidata(hObject, handles);
jelolesekfelvitele(hObject, eventdata, handles)


% --- Executes on button press in button_dir_forward.
function button_dir_forward_Callback(hObject, eventdata, handles)
% hObject    handle to button_dir_forward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.folders_num=handles.folders_num+1;
if handles.folders_num>length(handles.folders)
    handles.folders_num=length(handles.folders);
end

set(handles.text_dir,'string',handles.folders(handles.folders_num).name);
guidata(hObject, handles);


% --- Executes on button press in button_dir_backward.
function button_dir_backward_Callback(hObject, eventdata, handles)
% hObject    handle to button_dir_backward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.folders_num=handles.folders_num-1;
if handles.folders_num<1
    handles.folders_num=1;
end

set(handles.text_dir,'string',handles.folders(handles.folders_num).name);
guidata(hObject, handles);


% --- Executes on button press in button_loadfolder.
function button_loadfolder_Callback(hObject, eventdata, handles)
% hObject    handle to button_loadfolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get(handles.edit_path,'string')
handles.konyvtar=[get(handles.edit_path,'string') get(handles.text_dir,'string') '\'];

lastpath=get(handles.edit_path,'string');
save('lastpath_segment.mat', 'lastpath')

guidata(hObject, handles);
konyvtarbeolvasas(hObject, eventdata, handles)
