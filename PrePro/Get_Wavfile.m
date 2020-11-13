%% Get and concatenate a w single channel wave file
function [a b]=Get_Wavfile(n,m);

switch n
  if m ==1
    [a b] = wavread('C:/Users/510PAS/PhD/Data/NW/west_aaa2_20150830_094520_00_0010.wav',[1 36000]);
  elseif m==2
    [a b] = wavread('F:\Samples\009.wav',[1 36000]);
  else
    [a b] = wavread('F:\Samples\007.wav',[1 36000]);
  end
end
%------------------------------------------
x = [1 1 1];
y = [1 2 4];
d = [];
for i=1:3,
[a b]=Get_Wavfile(x(i),y(i));
[d]=[d;a];
end
sound(d,b)
%-------------------------------------------