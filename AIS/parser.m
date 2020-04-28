%%% Parser.m
%% For AIS parsed data, extract a kml file

%load('AIS18'); 
AIS=AIS15comb;
summary(AIS);

%% find each unique mmsi
[~,contacts] = findgroups(AIS.mmsi); %count the number of unique AIS contacts by mmsi

for i = 1:length(contacts)
    rows = AIS.mmsi==contacts(i);
    vars = {'datetime','lat','long'};
    T = AIS(rows,vars);
    send = [juliandate(T.datetime),T.lat,T.long];
    pwr_kml_tll(num2str(contacts(i)),send)
end



%% JUNK
%datetime(send(1,1),'convertfrom','juliandate')

% rows = AIS18.mmsi==316024641;
% vars = {'datetime','lat','long'};
% WAVE = AIS18(rows,vars);
% 
%  pwr_kml_tll('allch1-3',send)
% 
% send = [juliandate(AIS.datetime),AIS.lat,AIS.long];
% 
% 
% open
% %d = datetime(AIS.datetime,'InputFormat','yyyy-MM-dd''T''HH:mm:ss.SSSSSS');
% %d = datetime(d1,'InputFormat','yyyy-MM-dd''T''HH:mm:ss.SSSSSS');
% 
% %stats = grpstats(AIS18,'mmsi');
% 
% [g,contacts] = findgroups(AIS18.mmsi);  %count the number of unique AIS contacts by mmsi
% %[g,contacts] = findgroups(AIS.mmsi);
% 
% 
% %% create a table to send to pwr_kml_tll
% % mmsi of wave [316024641]
% rows = AIS18.mmsi==316024641;
% vars = {'datetime','lat','long'};
% WAVE = AIS18(rows,vars);
% %splitapply(@(x) {x}, WAVE{:,:}, findgroups(WAVE{:, 1}))
% 
% %% create a table with correct ('T') formatting to send to pwr_kml_tll_mine
% % mmsi of wave [316024641]
% rows = AIS18.mmsi==316024641;
% vars = {'tdate','lat','long'};
% WAVE = AIS18(rows,vars);
% T=WAVE.tdate;
% LL=WAVE(:,2:3);
% LL=table2array(LL);
% pwr_kml_tll_mine('WAVEkml',T,LL)
% 
% %splitapply(@(x) {x}, WAVE{:,:}, findgroups(WAVE{:, 1}))
% 
% WAVE.datetime = juliandate(WAVE.datetime);
% back = datetime(WAVE.datetime,'convertfrom','juliandate');
% WAVE = table2array(WAVE); 
% pwr_kml_tll('WAVEkml',WAVE)
% 
% %%split the contacts apart by date (manually) and now try again
% % the issue is with datestr in pwr_  datestr(WAVEarr(1,1),'yy-mm-dd')
% % KML wants yyyy-mm-ddThh:mm:sszzzzzz   --> the original format!!!
% WAVE1.datetime = juliandate(WAVE1.datetime);
% back = datetime(WAVE1.datetime,'convertfrom','juliandate');
% WAVE1 = table2array(WAVE1); 
% pwr_kml_tll('WAVE1',WAVE1)