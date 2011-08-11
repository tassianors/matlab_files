%==========================================================================
% Projeto - VRFT
% Tassiano Neuhaus
% tassianors@gmail.com
%==========================================================================
clear all; close all;clc;

% Sample time
model.Ts=5e-3;
% Final time [s]
model.Tf=10;
model.dim=3;
model.regr = [0 1 1];
model.eul= [1 1 0];

% Time vector
t=[0:model.Ts:model.Tf];
% definitions
a=0.5; b=-0.75; c=-0.8; d=-0.6;

% Plant's transfer function - unknown in a real word
G=tf([1 a],[1 b], model.Ts);
% Controler TF
C=tf([1 c],[1 d], model.Ts);

% M is the desired transfer function in Closed Loop
M=C*G/(C*G+1);

% input signal
ul=square(t)';

% response of unknown plant to u input signal
% Controller output signal
yl=lsim(G, ul, t);
% get the signal rl whose generate the same yl, but considering M TF.
W=1/M;
rl=lsim(W, yl, t);

% Controller input signal
el=rl-yl;

teta=calc_mmq_teta(model, ul,el)
% to be used in graphic plotting
c=teta(2)
d=-teta(3)
    