%%Winds
%Extract wind speeds from table and plot
%27 Oct 18
%figure
%gscatter(Aug31.Time,Aug31.WS1,Aug31.WD1);

figure
gscatter(WT1.DTG,WT1.ms,WT1.WD)
ylabel('Winds (m/s)')
xlim([min(WT1.DTG) max(WT1.DTG)])
ylim([0 15])
set(gca,'FontSize',14)

WindRose(WT1.WD, WT1.ms, 'legendtype', 1, 'anglenorth', 0, 'angleeast', 90)
set(gca,'FontSize',14)




%find NaN
[row, col] = find(isnan(Aug31_u));
%clean for NaN
Aug31_us = fillmissing(Aug31_us,'previous');
%Clean Winds
Winds.MPH = filloutliers(Winds.MPH,'linear');
WindsT = table2timetable(Winds);
%WindsT = timetable(datetime('01/Jan/2000 00:00:00'), NaN, NaN, NaN);
t = datetime(W.DTG,'InputFormat','yy/MM/dd HH:mm:ss');
WindT.DTG=t;
%Average frequencies

%pxy = cpsd(x,y)
Wcorr = zeros(length(pwr1(1,:)),2);
%for i = 1:length(pwr1(1,:))
for i = 1:2
    Wcorr(i) = corrgram(pwr1(:,i),Aug31.WS1);
end 
    
Aug31_u = resample(Aug31.WS1, length(pwr1), length(Aug31.WS1));  %resize the vectors
y = xcorr(Aug31_us, pwr1(:,600));
W_Aug31_os=resample(W_Aug31.ms, length(pwr1), length(W_Aug31.ms);


%%% correlation
Aug31_u = resample(Aug31.WS1, length(pwr1), length(Aug31.WS1));

R = zeros(2*length(pwr1(:,1))-1,length(pwr1(1,:))); 
for i = 1:length(pwr1(1,:))
    R(:,i) = xcorr(W_Aug31_os,pwr1(:,i));
end
contour(R,[12e5 12e5])


%Plotting two copies
a = (1:10)';
b = rand(10, 1);
c = rand(10, 1);
figure
h1 = axes
bar(a, c)
set(h1, 'Ydir', 'reverse')
set(h1, 'YAxisLocation', 'Right')
h2 = axes
plot(a,b)
set(h2, 'XLim', get(h1, 'XLim'))
set(h2, 'Color', 'None')
set(h2, 'Xtick', [])


%Frigging with loading winds
% Winds.Properties.VariableNames{3} = 'MPH';
% Winds.Properties.VariableNames{1} = 'DTG';
% Winds.ms = 0.44707*Winds.MPH;
% Winds = table2timetable(Winds);
% WTT = vertcat(WT,Winds);
% WTT1 = WTT(42842:end,1:3);
% WTT(42842:end,:) = 
% 
%  Winds.Properties.VariableNames{3} = 'VarName4';
% call
% Winds.Properties.VariableNames{3} = 'MPH';
% Winds.ms = 0.44707*Winds.MPH;
% Winds = table2timetable(Winds);
% WTT = vertcat(WT,Winds);
% load('first.mat')
% Winds = winds[];

