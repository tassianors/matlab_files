%==========================================================================
% Projeto - VRFT
% Tassiano Neuhaus
% tassianors@gmail.com
%==========================================================================
clear all; close all;

% Sample time
model.Ts=1e-4;
% Final time [s]
model.Tf=1;
model.dim=5;
model.regr = [0 1 2 1 2];
model.eul= [1 1 1 0 0];

% Time vector
t=[0:model.Ts:model.Tf];

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
G=zpk([a b],[c d e], 1, model.Ts)
% Controler TF
C=zpk([ca cb],[cc cd], 1, model.Ts)
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

theta=calc_mmq_theta(model, ul,el);
% to be used in graphic plotting
step(G);
figure;
step(M);
    