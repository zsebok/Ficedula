function data=csoportositas_meres_rajz3b(y,Fs,N1,N2)
%close all

window=512;%hann(512);
noverlap=400;
nfft=500;

extra=Fs*0.01; % 5 szazad sec el?tte és utána

flim_min=1000; %absolute limits
flim_max=15000; %absolute limits

if (N1-extra)<1;  N1=1; else  N1=N1-extra; end
if (N2+extra)>length(y);  N2=length(y); else N2=N2+extra; end

y2=y(N1:N2,1)';

[S,F,T,P]=spectrogram(y2,window,noverlap,nfft,Fs);

[flim_minv flim_mini]=min(abs(F-flim_min)); %megkeresi a frekihez tartozó indexet
[flim_maxv flim_maxi]=min(abs(F-flim_max));

%[flim_minv flim_mini2]=min(abs(F-minf)); %syllabusonként rogzített
%[flim_maxv flim_maxi2]=min(abs(F-maxf));


P1=P(1:flim_maxi,:); %csak a max frekiig szedi ki az infót
F1=F(1:flim_maxi);

P2=10*log(P1);

P2=P2-max(P2(:)); %normalizálás, de nem a NaN-ozás után kéne???

data.P=P2;
%data.P(1:flim_mini,:)=NaN; %az also freki alatt NaN-okat tesz bele.
data.P(1:flim_mini,:)=NaN;

data.F=F1;
data.T=T;


%data.y=y2;
% data.d=cell2mat(struct2cell(d)');

