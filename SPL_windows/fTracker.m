function [tonal, int] = fTracker(par, proc, tog, Sz, TimeVector,F)

i=1;
for iEvent = 500 %1:proc.numSpec
    for iRec=1:par.numRec
        [pks,locs,w,p] = findpeaks(Sz{iRec}(iEvent,:),F,...
            'Annotate','extents','WidthReference','halfprom','MinPeakProminence',10);
        findpeaks(10*log10(Sz{1}(550,:)),F,...
            'Annotate','extents','WidthReference','halfprom','MinPeakProminence',10);
        findpeaks(Sz{iRec,1}(iEvent,:),F,'Annotate','extents','WidthReference','halfprom','MinPeakProminence',10)
        
    end
end

end

     
