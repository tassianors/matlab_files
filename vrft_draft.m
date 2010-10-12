% Projeto - 

clear all; close all;
%syms ki kp

Ts=10e-3
Tf=6% final time
%b=[ki kp]
b=[1; 1]
Gc=zpk([],[-1],1)
%Gc_wanted=zpk([],[-10],1)
Gc_wanted=tf([1 10],[1 1 11])
Gd=c2d(Gc, Ts, 'tustin');
% M is the desired transfer function
M=c2d(Gc_wanted, Ts, 'tustin');
% for this first approach I'm using a step instead of a more complex signal
% for the input signal.

T=[0:Ts:Tf];
u=rand(size(T,2),1, 'single');
%[Y, T]=step(Gd);
Y=lsim(Gd, u, T);
%siz=size(Y,1);
% this is in the wrong place, i should know this value before
%u=ones(siz, 1);
% L filter
L=M*(1-M);
% yl=L*Y
yl=lsim(L, Y, T);
% ul=L*u
ul=lsim(L, u, T);
plot(T,ul,'-g',T,yl,'-r');figure;
% rl_t = (1/M) *yl
rl=lsim(1/M,yl, T);

el=rl-yl
plot(T, el, T, rl);figure;

inv(el'*el)*el'*ul