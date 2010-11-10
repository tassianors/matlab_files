%==========================================================================
% Projeto - VRFT
% Tassiano Neuhaus
% tassianors@gmail.com
%==========================================================================
clear all; close all;

% Time sample [s]
Ts=10e-3;
% Final time [s]
Tf=6;

a=2;b=0.85;c=0.6;
% Plant's transfer function - unknown in a real word
G=zpk([],[b],a, Ts)
% M is the desired transfer function in Closed Loop
M=zpk([],[c],1-c, Ts)
% Time vector
t=[0:Ts:Tf];

beta=[ tf([1],[1 -1], Ts); tf([1 0],[1 -1], Ts)]
% input signal - Random
u1=rand(size(t,2),1);
m=mean(u1);
s=std(u1);
u=(u1-m)/s;
% response of unknown plant to u input
Y=lsim(G, u, t);

% L filter
L=M*(1-M);
% yl=L*Y
yl=lsim(L, Y, t);
% ul=L*u
ul=lsim(L, u, t);
%plot(T,ul,'-g',T,yl,'-r');figure;
% rl_t = (1/M) *yl
%rl=lsim(M,yl, t);
rl=filter([1 -c], [1-c], yl);
% entrada do controlador
el=rl-yl;
% saida do contolador
yl;
plot(t, el);figure;
% modelo do controlador
teta=[a; b];
% e entrada u saida do controlador
%phy=[e(t); -e(t-1); u(t-1)]
N=size(t,2);
n=size(teta, 1);
phy=zeros(N, n);
phy=lsim(beta, el, t);
% for t=2:N
%     phy(t, 1)=el(t);
%     phy(t, 2)=-el(t-1);
%     phy(t, 3)=yl(t-1);
% end

% make sure, rank(phy) = n :)
teta_r=inv(phy'*phy)*phy'*ul

C=teta_r'*beta;

T=C*G/(1+C*G)