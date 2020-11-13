%%Generate 1/3 octave spectrum

flims = [10 1000];
bpo = 3;
opts = {'FrequencyLimits',flims,'BandsPerOctave',bpo};

poctave(x(:,1),fs,opts{:});