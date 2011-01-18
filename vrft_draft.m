%==========================================================================
% Projeto - VRFT
% Tassiano Neuhaus
% tassianors@gmail.com
%==========================================================================
clear all; close all;

% Sample time
Ts=5e-3;
% Final time [s]
Tf=8;
% Time vector
t=[0:Ts:Tf];

% definitions
a=0.5;
b=-0.75;
c=-0.8;
d=-0.6;

% Plant's transfer function - unknown in a real word
G=tf([1 a],[1 b], Ts);
% Controler TF
C=tf([1 c],[1 d], Ts);

% M is the desired transfer function in Closed Loop
M=C*G/(C*G+1);

% input signal
u=square(t)';

% response of unknown plant to u input signal
y=lsim(G, u, t);
% get the signal rl whose generate the same yl, but considering M TF.
W=1/M;
r=lsim(W, y, t);
% filter data to reduce polarization e variance error
% L filter
L=tf([1],[1], Ts)%M*(1-M);
% yl=L*Y
yl=lsim(L, y, t);
% ul=L*u
ul=lsim(L, u, t);

% Controller input signal
el=r-yl;
% Controller output signal
yl;

% min square method 
N=size(t,2);
n=3;
phy=zeros(N, n);
for k=2:N
    phy(k, 1)=el(k);
    phy(k, 2)=el(k-1);
    phy(k, 3)=ul(k-1);
end
teta=inv(phy'*phy)*phy'*ul;

% to be used in graphic plotting
c=teta(2)
d=-teta(3)