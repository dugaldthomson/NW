function [tonal1, int] = fTrackerTS(par, proc, tog, data, TimeVector)
ch=10;  %channel to read



%Parameters
dsensHz=1; %peak band resolution (smears peaks together over this width) - HZ, 
ftolHz=3; %peak meandering tolerance (allows this much change per step), Hz

f = single(par.fs/2*linspace(0,1,proc.segLengthSamples/2+1));
% fdi=find(f>=fd,1);
% fui=find(f>=fu,1);

%loop through and pick peaks
mm=1;

%%
switch tog.VOI
    case {'OcEnd-AAA1-30Aug','OcEnd-AAA2-30Aug'}
        int.tonal1 = 376:383;  % C52
        int.tonal2 = 503:510; % S185
        int.tonal3 = 543:550;  % C75
    case {'OcEnd-AAA1-31Aug','OcEnd-AAA2-31Aug'}
        int.tonal1 = 363:373;
        int.tonal2 = 504:514;
        int.tonal3 = 526:536;
    case 'HebSky-AAA2-26Aug'
        int.tonal1 = 230:238;
        int.tonal2 = 463:473;
        int.tonal3 = 596:605;
    case {'Lat-AAA1-02Sep','Lat-AAA2-02Sep','Lat-AAA1-03Sep','Lat-AAA2-03Sep'}
        int.tonal1 = 77:84;     %C24
        int.tonal2 = 120:126;   %C36
        int.tonal3 = 132:139;   %C40
    case {'DesGros-AAA1-25Aug19-A','DesGros-AAA2-25Aug19-A','DesGros-AAA1-25Aug19-B','DesGros-AAA2-25Aug19-B'...
            'DesGros-AAA1-18Aug19','DesGros-AAA2-18Aug19', 'DesGros-AAA1-29Aug19','DesGros-AAA2-29Aug19'}
        int.tonal1 = 165:175;   %C20
        int.tonal2 = 394:402;   %C47
        int.tonal3 = 704:714;   %C84
    case {'OcEnd-AAA1-05Aug19','OcEnd-AAA2-05Aug19','OcEnd-AAA1-27Aug19','OcEnd-AAA2-27Aug19'}
        int.tonal1 = 330:350;   %C52
        int.tonal2 = 480:505;   %C75
        int.tonal3 = 660:700;   %C104
        fd=330; %lower frequency
        fu=350; %upper frequency
    case {'Amundsen-AAA1-28Aug19-A','Amundsen-AAA2-28Aug19-A','Amundsen-AAA1-28Aug19-B',...         % slow speed contact (28A) does great on tonals 1/2, while high speed does well on 2/3
            'Amundsen-AAA2-28Aug19-B','Amundsen-AAA1-29Aug19','Amundsen-AAA2-29Aug19'}
        int.tonal1 = 171:180;   % 29 x CFR  
        int.tonal2 = 471:481;   % 79 x CFR (GMR)
        int.tonal3 = 560:630;   % 5 x DG CFR  (28B/29 only)    **no this is shaft-related
    case {'World-AAA1-27Aug19','World-AAA2-27Aug19','World-AAA1-28Aug19','World-AAA2-28Aug19'}
        int.tonal1 = 110:130;   % S75
        int.tonal2 = 250:300;   % 24 x CSR (MSR?)
        int.tonal3 = 570:660;   % 53 x CSR (GMR?)
end
%% 
tonal1.max = zeros(proc.numSpec,par.numRec);
tonal1.idx = zeros(proc.numSpec,par.numRec);

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
