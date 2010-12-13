%==========================================================================
% Projeto - VRFT
% Tassiano Neuhaus
% tassianors@gmail.com
%==========================================================================
clear all; close all;

% Time sample [s]
Ts=5e-3;
% Final time [s]
Tf=8;

a=0.5;
b=-0.75;
c=-0.9;
d=-0.6;

% Plant's transfer function - unknown in a real word
G=tf([a],[1 b], Ts)
C=tf([1 c],[1 d], Ts)

% M is the desired transfer function in Closed Loop
M=C*G/(C*G+1)
% Time vector
t=[0:Ts:Tf];

beta=[ tf([1],[1 -1], Ts); tf([1 0],[1 -1], Ts)]
% input signal - Random
u1=rand(size(t,2),1);
m=mean(u1);
s=std(u1);
ul=(u1-m)/s;
% response of unknown plant to u input
 

% rl_t = (1/M) *yl
rl=filter([1 -(b+1) (b+a)], [1], yl);

% entrada do controlador
el=rl-yl;
% saida do contolador
yl;

% modelo do controlador
teta=[a; b];
% e entrada u saida do controlador
%phy=[e(t); -e(t-1); u(t-1)]
N=size(t,2);
n=size(teta, 1);
phy=zeros(N, n);
phy=lsim(beta, el, t);

% make sure, rank(phy) = n :)
teta_r=inv(phy'*phy)*phy'*ul

C=teta_r'*beta;

T=(G*C)/(1+C*G)
step(M, T)
