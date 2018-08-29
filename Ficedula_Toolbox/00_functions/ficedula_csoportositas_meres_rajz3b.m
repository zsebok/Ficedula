function data=csoportositas_meres_rajz3b(y,Fs,N1,N2)

window=512;% hann(512);
noverlap=500;
nfft=512;

extra=Fs*0.01; % extra space before/after syllable

flim_min=1000; % absolute limits in Hz
flim_max=15000; % absolute limits in Hz

if (N1-extra)<1;  N1=1; else  N1=N1-extra; end
if (N2+extra)>length(y);  N2=length(y); else N2=N2+extra; end

y2=y(N1:N2,1)';

[S,F,T,P]=spectrogram(y2,window,noverlap,nfft,Fs);

[flim_minv flim_mini]=min(abs(F-flim_min)); 
[flim_maxv flim_maxi]=min(abs(F-flim_max));


P1=P(1:flim_maxi,:); 
F1=F(1:flim_maxi);

P2=10*log(P1);

P2=P2-max(P2(:)); 

data.P=P2;

data.P(1:flim_mini,:)=NaN;

data.F=F1;
data.T=T;


