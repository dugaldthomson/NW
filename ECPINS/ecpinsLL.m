function [latd, lond]= ecpinsLL(ctxt,startcol)
% Function ecpinsLL converts columns of ECPINS csv data into decimal
% degrees latitude and longitude.
% todo check & conversion for different input types

nr=size(ctxt,1);
%t1=ctxt{:,startcol: startcol+3};
t1=double(char(ctxt(:,startcol))-48);
%t2=t1(1:10, 1:10);
%dat=double(ctxt{:,startcol: startcol+3})-48;
isneg=( char(ctxt(:,startcol+1))>78 );% 78 is N
latd=double(char(ctxt(:,startcol))-48)*[     10; 1; 1/6; 1/60; 0; 1/600; 1/6000; 1/60000; 1/600000];
latd(isneg)=-1*latd(isneg);
%li=dat(:,2)
% somethimes E|W is combined with checksum e.g. GEO messages)
tmp=char(ctxt(:,startcol+3));
isneg=(tmp(:,1)==87 );%87 is W
lond=double(char(ctxt(:,startcol+2))-48)*[100; 10; 1; 1/6; 1/60; 0; 1/600; 1/6000; 1/60000; 1/600000];
lond(isneg)=-1*lond(isneg);
end

