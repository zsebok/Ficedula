function data=measurements1(y,Fs,N1,N2,flim_min, flim_max)


window=512;%hann(512);
noverlap=400;
nfft=500;

extra=Fs*0.01; % 5 szazad sec el?tte és utána


if (N1-extra)<1;N1=1;else; N1=N1-extra; end

if (N2+extra)>length(y); N2=length(y);else; N2=N2+extra; end

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


N=N2-N1+1;
n1=max(floor(size(P2,2)*0.1),1);
n2=floor(size(P2,2)*0.9);

[maxe f]=max(P2(flim_mini:end,n1:n2));


fr=F1(flim_mini:end);

fmax=fr(f);

%iqrv=iqr(P2(flim_mini:end,n1:n2),1);


clear d;
%d.iqrv=[iqrv(1) iqrv(floor(length(iqrv)/2)) iqrv(end)];

d.t=N/Fs;
%[d.fmax fmaxt]=max(fmax);
%d.fmaxt=fmaxt/length(fmax);

%[maxe_ maxet]=max(maxe);
% d.maxet=maxet/length(maxe);

 d.fmean=mean(fmax);
% d.fmedian=median(fmax);

 d.f=[fmax(1) fmax(floor(length(fmax)/2)) fmax(end)];


data.d=cell2mat(struct2cell(d)');

