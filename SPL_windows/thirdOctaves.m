function RecInd = plotSpecOctaves(par, tog, TimeVector, S, SL, proc, fSpectra)

%%Generate 1/3 octave spectrum

flims = [10 1000];
bpo = 3;
opts = {'FrequencyLimits',flims,'BandsPerOctave',bpo};

poctave(x(:,1),fs,opts{:});

h(2) = figure;
colorarray = hsv(par.numRec);
for RecInd=1:par.numRec
    plot(fSpectra,10*log10(sum(S{RecInd})/proc.numSpec),...
        'Color',colorarray(RecInd,:));
    hold on
end
grid on
title(['Spectra time-averaged over '...
    num2str((TimeVector(end)-TimeVector(1))*24*60) 'min'],'FontSize',par.fontSize+2)
ylabel('RL [dB re 1\muPa//Hz]','FontSize',par.fontSize)
xlabel('f [Hz]','FontSize',par.fontSize)
%fontsize(gca,par.fontSize,'points')
set(h(2), 'Position', par.figPos2)
%ylim([100 170])
xlim([0 800])
ax = gca;
ax.FontSize = par.fontSize;
if proc.saveFigs
    saveas(h(2), fullfile(par.figPath,tog.VOI,'RLSprectra.tif'));
    savefig(h(2), fullfile(par.figPath,tog.VOI,'RLSpectra'));
end