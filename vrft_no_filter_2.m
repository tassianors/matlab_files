%==========================================================================
% Projeto - VRFT
% Tassiano Neuhaus
% tassianors@gmail.com
%==========================================================================
clear all; close all;clc;

% Sample time
model.Ts=5e-3;
% Final time [s]
model.Tf=1;
model.dim=5;
model.regr = [0 1 2 1 2];
model.eul= [1 1 1 0 0];

% Time vector
t=[0:model.Ts:model.Tf];

% definitions
kk=980*1.126*1.051;
ca=0.5274;
cb=0.8605;
cc=-0.2901;
cd=0.955;

% Plant's transfer function - unknown in a real word
Gc=zpk([],[0 -36 -100], 100);
G=c2d(Gc, model.Ts);
% Controler TF
C=zpk([ca cb],[cc cd], kk, model.Ts);
atraso=tf([1],[1 0],model.Ts);
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

-theta(2)/kk
ca+cb
theta(3)/kk
ca*cb
theta(4)
cc+cd
-theta(5)
cc*cd