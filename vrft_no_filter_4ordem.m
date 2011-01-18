%==========================================================================
% Projeto - VRFT
% Tassiano Neuhaus
% tassianors@gmail.com
%==========================================================================
clear all; close all;

% Sample time
Ts=1e-4;
% Final time [s]
Tf=1;
% Time vector
t=[0:Ts:Tf];

% definitions
a=0.6;
b=0.68;
c=0.85;
d=0.7;
e=0.8;

ca=0.75;
cb=0.5;
cc=1;
cd=0.8;

% Plant's transfer function - unknown in a real word
G=zpk([a b],[c d e], 1, Ts)
% Controler TF
C=zpk([ca cb],[cc cd], 1, Ts)
atraso=tf([1],[1 0],Ts);
% M is the desired transfer function in Closed Loop
M=C*G/(C*G+1);

% input signal
ul=square(2*pi*10*t)'+sin(10*t)'+sin(20*t)';

% response of unknown plant to u input signal
yl=lsim(G, ul, t);
% get the signal rl whose generate the same yl, but considering M TF.
W=1/M*atraso;
rl_=lsim(W, yl, t);
rl=rl_(2:size(rl_,1));
rl(size(rl_,1))=0;
% Controller input signal
yl(size(rl_,1))=0;
el=rl-yl;
% Controller output signal
yl;


ul_=ul(1:size(ul,1)-1);
% min square method 
N=size(t,2)-1;
n=5;
phy=zeros(N, n);
for k=3:N
    phy(k, 1)=el(k);
    phy(k, 2)=el(k-1);
    phy(k, 3)=el(k-2);
    phy(k, 4)=ul(k-1);
    phy(k, 5)=ul(k-2);
end
teta=inv(phy'*phy)*phy'*ul_

% to be used in graphic plotting
step(G);
figure;
step(M);
    