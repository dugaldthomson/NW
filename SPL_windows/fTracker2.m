function [tonal, int] = fTracker2(par, proc, tog, SL, TimeVector,f)
%using findpeaks to track frequency
% "findpeaks" function returns a "width" output which you can then use to sort/group your peaks 
% An alternative could be to first smoothen your FFT amplitude output and then find the peaks. 
% As long as your filter/averaging length is long enough to lump all nearby peaks, it should work. 
% Another one is to use the "envelope" Matlab function that has an "np" (number of points) input argument to perform the smoothing.
% 
% %Parameters
dsensHz=2; %peak band resolution (smears peaks together over this width), Hz 
ftolHz=1; %peak meandering tolerance (allows this much change per step), Hz


%% toggle tonal frequency band switches
switch tog.VOI
    case {'OcEnd-AAA1-30Aug','OcEnd-AAA2-30Aug'}
        int{1}.tonal = 376:383;  % C52
        int{2}.tonal = 503:510; % S185
        int{3}.tonal = 543:550;  % C75
    case {'OcEnd-AAA1-31Aug','OcEnd-AAA2-31Aug'}
        int{1}.tonal = 363:373;
        int{2}.tonal = 504:514;
        int{3}.tonal = 526:536;
    case 'HebSky-AAA2-26Aug'
        int{1}.tonal = 230:238;
        int{2}.tonal = 463:473;
        int{3}.tonal = 596:605;
    case {'Lat-AAA1-02Sep','Lat-AAA2-02Sep','Lat-AAA1-03Sep','Lat-AAA2-03Sep'}
        int{1}.tonal = 77:84;     %C24
        int{2}.tonal = 120:126;   %C36
        int{3}.tonal = 132:139;   %C40
    case {'DesGros-AAA1-25Aug19-A','DesGros-AAA2-25Aug19-A','DesGros-AAA1-25Aug19-B','DesGros-AAA2-25Aug19-B'...
            'DesGros-AAA1-18Aug19','DesGros-AAA2-18Aug19', 'DesGros-AAA1-29Aug19','DesGros-AAA2-29Aug19'}
        int{1}.tonal = 165:175;   %C20
        int{2}.tonal = 394:402;   %C47
        int{3}.tonal = 704:714;   %C84
    case {'OcEnd-AAA1-05Aug19','OcEnd-AAA2-05Aug19','OcEnd-AAA1-27Aug19','OcEnd-AAA2-27Aug19'}
        int{1}.tonal = 330:350;   %C52
        int{2}.tonal = 480:505;   %C75
        int{3}.tonal = 660:700;   %C104
    case {'Amundsen-AAA1-28Aug19-A','Amundsen-AAA2-28Aug19-A','Amundsen-AAA1-28Aug19-B',...         % slow speed contact (28A) does great on tonals 1/2, while high speed does well on 2/3
            'Amundsen-AAA2-28Aug19-B','Amundsen-AAA1-29Aug19','Amundsen-AAA2-29Aug19'}
        int{1}.tonal = 171:180;   % 29 x CFR  
        int{2}.tonal = 471:481;   % 79 x CFR (GMR)
        int{3}.tonal = 560:630;   % 5 x DG CFR  (28B/29 only)    **no this is shaft-related
    case {'World-AAA1-27Aug19','World-AAA2-27Aug19','World-AAA1-28Aug19','World-AAA2-28Aug19'}
        int{1}.tonal = 110:130;   % S75
        int{2}.tonal = 250:300;   % 24 x CSR (MSR?)
        int{3}.tonal = 570:660;   % 53 x CSR (GMR?)
end
%% 
tonal = cell(length(int),1);
for i = 1:length(int)
    tonal{i}.max = zeros(proc.numSpec,par.numRec);
    tonal{i}.bw = zeros(proc.numSpec,par.numRec);
    tonal{i}.idx = zeros(proc.numSpec,par.numRec);
end

for iTone = 1%:length(tonal)     

for iRec = 1:par.numRec
    data = SL.ALL{iRec,1}(:,int{1}.tonal/par.binWidth)';
      data = SL.ALL{iRec,1}';
%     peakfreqs = cell(length(proc.numSpec),1);
%     Pwr(:,iSpec)
for iSpec=1:size(data,2)   %loop through each FFT segment and look at all freqs in int
    [pks,locs,widths,proms] = findpeaks(data);
    findpeaks(data(:,iSpec),int{1}.tonal','Annotate','extents','WidthReference','halfprom','MinPeakProminence',4)
    findpeaks(data(:,iSpec),int{1}.tonal/par.binWidth','Annotate','extents')
    findpeaks(data(:,iSpec),'Annotate','extents')
        findpeaks(data(:,iSpec),'Annotate','extents','WidthReference','halfprom','MinPeakProminence',10)


    tonal{iTone}.idx(iSpec,iRec) = median(peakfreqs);   
    tonal{iTone}.bw(iSpec,iRec) = range(peakfreqs)+1; 
    tonal{iTone}.max(iSpec,iRec) = SL.ALL{iRec}(tonal{iTone}.idx(iSpec,iRec));  
end
end
end
figure(iTone)
    %scatter3(TimeVector',peakfreqs{mm},tonal1.max(:,1),'k')
    scatter3(TimeVector',tonal{iTone}.idx(:,par.refArray),tonal{iTone}.max(:,par.refArray))
    hold on
grid on; view(45,30)
xlabel('Time [mins]'); ylabel('Frequency [Hz]'); zlabel('Power [dB ref max]')
end


     
