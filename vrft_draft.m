%==========================================================================
% Projeto - VRFT
% Tassiano Neuhaus
% tassianors@gmail.com
%==========================================================================
clear all; close all;
syms a b

% Time sample [s]
Ts=10e-3;
% Final time [s]
Tf=6;

% Plant's transfer function - unknown in a real word
Gc=zpk([],[-1],1);
%Gc_wanted=zpk([],[-10],1)
Gc_wanted=tf([1 10],[1 1 11]);
Gd=c2d(Gc, Ts, 'tustin');
% M is the desired transfer function
M=c2d(Gc_wanted, Ts, 'tustin')

% Time vector
t=[0:Ts:Tf];

% input signal - Random
u=rand(size(t,2),1, 'single');
%[Y, T]=step(Gd);
% response of unknown plant to u input
Y=lsim(Gd, u, t);

% L filter
L=M*(1-M);
% yl=L*Y
yl=lsim(L, Y, t);
% ul=L*u
ul=lsim(L, u, t);
%plot(T,ul,'-g',T,yl,'-r');figure;
% rl_t = (1/M) *yl
rl=lsim(1/M,yl, t);

% entrada do controlador
el=rl-yl;
% saida do contolador
yl;

% modelo do controlador
teta=[a; b; 1];
% e entrada u saida do controlador
%phy=[e(t); -e(t-1); u(t-1)]
N=size(t,2);
n=size(teta, 1);
phy=zeros(N, n);

for t=2:N
    phy(t, 1)=el(t);
    phy(t, 2)=-el(t-1);
    phy(t, 3)=yl(t-1);
end

% make sure, rank(phy) = n :)
teta_r=inv(phy'*phy)*phy'*yl
kc=teta_r(2);
Ti=(kc*Ts/teta_r(1))/(1-kc/teta_r(1));
z = TF('z',Ts);
Cr=kc*(1+Ts/(Ti*(1-z^(-1))))

