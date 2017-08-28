function data=measurements1(y,Fs,N1,N2,flim_min, flim_max)
%close all

window=512;%hann(512);
noverlap=400;
nfft=500;

extra=Fs*0.01; % 5 szazad sec el?tte és utána

% flim_min=100; %absolute limits
% flim_max=20000; %absolute limits

if (N1-extra)<1;N1=1;else; N1=N1-extra; end

if (N2+extra)>length(y); N2=length(y);else; N2=N2+extra; end

y2=y(N1:N2,1)';

% if maxf<flim_max; flim_max=maxf; end
% if minf>flim_min; flim_min=minf; end
    
%figure

[S,F,T,P]=spectrogram(y2,window,noverlap,nfft,Fs);

[flim_minv flim_mini]=min(abs(F-flim_min)); %megkeresi a frekihez tartozó indexet
[flim_maxv flim_maxi]=min(abs(F-flim_max));

%[flim_minv flim_mini2]=min(abs(F-minf)); %syllabusonként rogzített
%[flim_maxv flim_maxi2]=min(abs(F-maxf));


P1=P(1:flim_maxi,:); %csak a max frekiig szedi ki az infót
F1=F(1:flim_maxi);

P2=10*log(P1);

%normalize

P2=P2-max(P2(:)); %normalizálás, de nem a NaN-ozás után kéne???

data.P=P2;
%data.P(1:flim_mini,:)=NaN; %az also freki alatt NaN-okat tesz bele.
data.P(1:flim_mini,:)=NaN;

data.F=F1;
data.T=T;


N=N2-N1+1;
n1=max(floor(size(P2,2)*0.1),1);
n2=floor(size(P2,2)*0.9);

[maxe f]=max(P2(flim_mini:end,n1:n2));
%[maxe f]=max(P2(flim_mini2:flim_maxi2,n1:n2));

fr=F1(flim_mini:end);
%fr=F1(flim_mini2:flim_maxi2);
fmax=fr(f);

%iqrv=iqr(P2(flim_mini:end,n1:n2),1);
%iqrv=iqr(P2(flim_mini2:flim_maxi2,n1:n2),1);

clear d;
%d.iqrv=[iqrv(1) iqrv(floor(length(iqrv)/2)) iqrv(end)];

d.t=N/Fs;
%[d.fmax fmaxt]=max(fmax);
%d.fmaxt=fmaxt/length(fmax);

%[maxe_ maxet]=max(maxe);
% d.maxet=maxet/length(maxe);
% 
 d.fmean=mean(fmax);
% d.fmedian=median(fmax);
% 
 d.f=[fmax(1) fmax(floor(length(fmax)/2)) fmax(end)];
% data.flim_min2=flim_min;
% data.flim_max2=flim_max;
% d.fmin_manual=minf;
% d.fmax_manual=maxf;


%data.y=y2;
 data.d=cell2mat(struct2cell(d)');

