function [y error W lmsW Q]=lmsNoMem(x,xp,L,a,delta)

r0=mean((x.^2)/2);
mu=a/r0/L;

% [y error W]=lmsHW5(x,xp,w0,L,alpha,delta)
% OUTPUT
% y - filter output
% error - error of filter
% W - weight values
% INPUT
% x - signal to be filtered
% xp - comparison signal
% L - number of weights
% a - value of alpha

w0=zeros(1,L);
w0=w0(:);
w=w0;

x=x(:);

W=zeros(length(x),L);
y=zeros(length(x),1);
error=zeros(size(y));

for(ii=1:length(x)-L-delta)
    y(ii)=sum(w.*x(ii:L+ii-1));
    %error(ii)=xp(ii+L-1)-y(ii);
    error(ii)=xp(ii+L-2+delta)-y(ii);
    w=w+2*mu*error(ii)*x(ii:L+ii-1);
    W(ii,:)=flipdim(w,1);
end
lmsW='';
Q='';