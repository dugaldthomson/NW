plot(T000048.SoundVelocityms, T000048.Depthm)
set(gca,'YDir','reverse', 'YLim', [0 200])
hold on
plot(T000049.SoundVelocityms, T000049.Depthm)
plot(T000050.SoundVelocityms, T000050.Depthm)
plot(T000051.SoundVelocityms, T000051.Depthm)
plot(T000053.SoundVelocityms, T000053.Depthm)
plot(T000054.SoundVelocityms, T000054.Depthm)
plot(T000057.SoundVelocityms, T000057.Depthm)
plot(T000058.SoundVelocityms, T000058.Depthm)
xlabel('Sound speed (m/s)')
ylabel('Depth (m)')

figure
imagesc(SSPs1)
yticklabels = 200:-50:0;
yticks = linspace(1, size(SSPs1, 1), numel(yticklabels));
set(gca, 'YTick', yticks, 'YTickLabel', flipud(yticklabels(:)))
xticklabels = {'50'; '49'; '48'; '51'; '60'; '53'; '55'; '59'; '57'; '58'};
xticks = linspace(1, size(SSPs1, 2), numel(xticklabels));
set(gca, 'XTick', xticks, 'XTickLabel', xticklabels, 'FontSize', 14)


%%
T000060.Properties.VariableNames{1} = 'd';
T000060.Properties.VariableNames{2} = 'temp';
T000060.Properties.VariableNames{3} = 'v';