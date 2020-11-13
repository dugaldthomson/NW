
%READING DUGALD FILES .hd5
clear all; close all; clc

ch=10;  %channel to read

%search over this band
fd=300; %lower frequency
fu=400; %upper frequency

%Parameters
dsensHz=1; %peak band resolution (smears peaks together over this width) - HZ, 
ftolHz=3; %peak meandering tolerance (allows this much change per step), Hz

nFiles=1;

filename = 'NW_2017_A2__20190805_041505_00_0035.h5';

for iFile = 1:nFiles
    data = h5read(filename,'/DATA_SAMPLES')';                   % Read in the acoustic data
    %if singleCh
    %    data = data(:,1); %#ok<UNRCH>
    %end
    gain = h5readatt(filename,'/DATA_SAMPLES','gain');
    %factor = (2/5)*10^-(double(gain)/20);   %from IDL: adjustment=5./65535./(10.^(array_info.gain/20.))
    factor = 10^-((double(gain))/20);
    data = data.*factor;
    time = h5read(filename,'/TIMESTAMP');
    time = datetime(time,'ConvertFrom','epochtime','Format','dd-MMM-yyyy HH:mm:ss.S');
    %arrData = vertcat(arrData, data);
    %timeVec = vertcat(timeVec, time);
    fprintf('Just finished iteration #%d\n', iFile);
end

fs=2500;
dt=1/fs;
t=[0:length(data(:,ch))-1]*dt;

%figure
%plot(t/60,data(:,ch));

x=data(:,ch);
clear data

nfft=2^16;
f=[0:nfft-1]*fs/(nfft-1);
df=f(2);
tspec=[0:length(x)/nfft*2]*nfft/fs/2; %50% overlap
An=fft(buffer(x,nfft,nfft/2));

An=An.*repmat(hann(nfft),1,size(An,2));
Pwr=An.*conj(An);

fdi=find(f>=fd,1);
fui=find(f>=fu,1);

figure
pcolor(tspec,f,10*log10(Pwr/(max(max(Pwr))))); shading flat
set(gca,'ylim',[fd fu])
%set(gca,'yscale','log')
colorbar
caxis([-100 0])
set(gca,'tickdir','out')
xlabel('Time [mins]'); ylabel('Frequency [Hz]'); colorbar
title('Unfiltered Spectrogram')

%Band pass data
bpFilt = designfilt('bandpassfir','FilterOrder',60, ...
         'CutoffFrequency1',fd,'CutoffFrequency2',fu, ...
         'SampleRate',fs);
%fvtool(bpFilt)
x = filter(bpFilt,x);

%implement LMS filter to reduce background noise
xp=x(2:end);
x=x(1:end-1);

L=8; %# of weights
a=0.001; %alpha 
delta=1; %delta
w0=zeros(1,L);
[y,error,W,lmsW,Q]=lmsNoMem(x,xp,L,a,delta);
y=y(:)';

An=fft(buffer(y,nfft,nfft/2));
An=An.*repmat(hann(nfft),1,size(An,2));
Pwr=An.*conj(An);
figure
pcolor(tspec,f,10*log10(Pwr/(max(max(Pwr))))); shading flat
set(gca,'ylim',[fd fu]); set(gca,'tickdir','out')
xlabel('Time [mins]'); ylabel('Frequency [Hz]'); colorbar
caxis([-100 0])
title('LMS filtered Spectrogram')

%loop through and pick peaks
mm=1;

for jj=1:size(Pwr,2)
    % noise threshold in window of interest
    nt=3*std(Pwr(fdi:fui,jj));
    pli=find(Pwr(fdi:fui,jj)>=nt)+fdi-1; %all above threshold
    %contiguous only
    dsens=round(dsensHz/df);
    ngrps=length(find(diff(pli)>dsens))+1;
    grpsi=[0; find(diff(pli)>dsens)];
    
    pli_out=[];
    if(jj==1)
        for(ii=1:ngrps)
            if(ii==ngrps)
                gpli=pli(grpsi(ii)+1:end);
                [nothing, maxi]=max(Pwr(gpli));
                pli_out(ii)=gpli(maxi);
            else
                gpli=pli(grpsi(ii)+1:grpsi(ii+1));
                [nothing, maxi]=max(Pwr(gpli));
                pli_out(ii)=gpli(maxi);
            end
        end
    elseif(jj>1)
        for(ii=1:ngrps)
            if(ii==ngrps)
                gpli=pli(grpsi(ii)+1:end);
                [nothing, maxi]=max(Pwr(gpli));
                if(sum(abs(f(gpli(maxi))-peakfreqs{mm-1})<ftolHz))
                    pli_out(ii)=gpli(maxi);
                end
            else
                gpli=pli(grpsi(ii)+1:grpsi(ii+1));
                [nothing, maxi]=max(Pwr(gpli));
                if(sum(abs(f(gpli(maxi))-peakfreqs{mm-1})<ftolHz))
                    pli_out(ii)=gpli(maxi);
                end
            end
        end
    end

    if(isempty(pli_out))
    else
    peakfreqs{mm}=f(pli_out(pli_out~=0));
    
    figure(11)
    scatter3(tspec(jj)*ones(1,size(peakfreqs{mm},2))/60,peakfreqs{mm},10*log10(Pwr(pli_out(pli_out~=0))),'k')
    hold on
    mm=mm+1;
    end
    
    clear pli_out
end

grid on; view(0,+90)
xlabel('Time [mins]'); ylabel('Frequency [Hz]'); zlabel('Power [dB ref max]')
