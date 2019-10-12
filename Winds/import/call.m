%% import all the met files in BIRDSEYE
%init
Winds = winds;
windFiles = dir('*.dat'); 
numfiles = length(windFiles);
for k = 1:numfiles 
    filename = windFiles(k).name;
    import_tws
    Winds = vertcat(Winds,winds);
    %Winds=join(Winds,winds);
    %Winds{end+1,:}=import_tws(name);
    %eval(['load ' windFiles(k).name]);
    %winds{end+1,:} = [winds];
end


%filling of the main table
%     filler = nan(1, numel(codes));
%     [~, destcol] = ismember(looptable.codes, codes);
%     filler(destcol) = looptable.values;
%     maintable{step, :} = [step, filler];