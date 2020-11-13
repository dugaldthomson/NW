%%removeDups
% Script to remove duplicates from timetable

load AIS15Comb.mat

dupTimes = sort(AIS.datetime);
TF = (diff(dupTimes) == 0);
dupTimes = dupTimes(TF);
dupTimes = unique(dupTimes);