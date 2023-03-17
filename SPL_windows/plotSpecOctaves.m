function RecInd = plotSpecOctaves(par, tog, TimeVector, S, SL, proc, fSpectra, timeCPA)

RecInd = 2;
%colorarray = hsv(par.numRec);
flims = [10 1000];

levels24 = SL.ALL{2,1}(timeCPA-150:timeCPA+150,:);            %%1116x1251 levels for hph24

h(1) = figure;

% %subplot octaves
% subplot(3,1,1)
% bpo = 1;
% opts = {'FrequencyLimits',flims,'BandsPerOctave',bpo};
% [~,cf0] = poctave(levels24,par.fs,opts{:}); %cf0 are bin centers not edges
% fOctaves = discretize(fSpectra,cf0);
% boxplot(levels24,fOctaves,'OutlierSize',1,'Symbol','.')
% xticks([1 4 7]), xticklabels({'10','100','1000'})
% % boxplot(levels24,fOctaves,'PlotStyle','compact')

%subplot 1/3-octaves
subplot(2,1,1)
bpo = 3;
opts = {'FrequencyLimits',flims,'BandsPerOctave',bpo};
[~,cf3] = poctave(levels24,par.fs,opts{:});
fOctaves = discretize(fSpectra,cf3);
boxplot(levels24,fOctaves,'OutlierSize',1,'Symbol','.')
xticks([1 11 20]), xticklabels({'10','100','1000'})

%subplot 1Hz bins
subplot(2,1,2)
semilogx(fSpectra(flims(1):flims(end)),mean(levels24(:,flims(1):flims(end)),1),'LineWidth',3)
xticks([10 100 1000]), xticklabels({'10','100','1000'})
xlabel('Frequency (Hz)')

set(findobj(gcf,'type','axes'),'FontSize',par.fontSize);

ylabel('Radiated Noise Level [dB re 1\muPa//Hz]')

%%Save figures
if proc.saveFigs
    exportgraphics(h(1), fullfile(par.figPath,tog.VOI,'RLOctaves.tif'));
    exportgraphics(h(1), fullfile(par.figPath,tog.VOI,'RLOctaves.eps'));
    savefig(h(1), fullfile(par.figPath,tog.VOI,'RLOctaves'));
end