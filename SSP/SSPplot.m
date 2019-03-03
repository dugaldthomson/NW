plot(T000048.SoundVelocityms, T000048.Depthm)
set(gca,'YDir','reverse', 'YLim', [0 200])
hold on
plot(T000060.SoundVelocityms, T000060.Depthm)
plot(T000060.SoundVelocityms, T000060.Depthm)
plot(T000060.SoundVelocityms, T000060.Depthm)
plot(T000060.SoundVelocityms, T000060.Depthm)
plot(T000060.SoundVelocityms, T000060.Depthm)
plot(T000060.SoundVelocityms, T000060.Depthm)
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