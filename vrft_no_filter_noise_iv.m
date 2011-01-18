%==========================================================================
% Projeto - VRFT
% Tassiano Neuhaus
% tassianors@gmail.com
%==========================================================================
clear all; close all;
% Replace the default stream with a stream whose seed is based on CLOCK, so
% RAND will return different values in different MATLAB sessions
RandStream.setDefaultStream( RandStream('mt19937ar', 'seed', sum(100*clock)));

% Sample time
Ts=5e-3;
% Final time [s]
Tf=10;
% Time vector
t=[0:Ts:Tf];
N=size(t,2);
n=3;
m=300;
% definitions
a=0.5;
b=-0.75;
c=-0.8;
d=-0.6;

% Plant's transfer function - unknown in a real word
G=tf([1 a],[1 b], Ts)
% Controler TF
C=tf([1 c],[1 d], Ts)

% M is the desired transfer function in Closed Loop
M=C*G/(C*G+1);

% Controller output signal
% Plant input signal 
ul=square(t)';
zl=rand(N, 1);
% response of unknown plant to u input signal
yl=lsim(G, ul, t);

% get the signal rl whose generate the same yl, but considering M TF.
W=1/M;
rl=lsim(W, yl, t);
    
% numero de vezes que sera aplicado o metodo.
c=zeros(m,1);
d=zeros(m,1);

for j=1:m
% make a randon noise with std = 0.1
ran=rand(N, 1);
s=std(ran);
% now ran_s has std=1;
ran_s=ran/s;
m=mean(ran_s);
% make noise be zero mean
rh=(ran_s-m)*0.10;

% Controller input signal
el=rl-yl+rh;

% min square method 
phy=zeros(N, n);
z=zeros(N, n);
for k=3:N
    phy(k, 1)=el(k-1);
    phy(k, 2)=el(k-2);
    phy(k, 3)=ul(k-2);
end

for p =4:N
    % auxiliary instrument z
    z(p,3)=ul(p-1);
    z(p,2)=ul(p-2);
    z(p,1)=ul(p-3);
end

teta=inv(z'*phy)*z'*ul;

% to be used in graphic plotting
d(j)=teta(2);
c(j)=-teta(3);

end
PN=[c, d];
ma=mean(c)
sa=std(c);
mb=mean(d)
sb=std(d);
plot(c, d, 'bo');
hold;
plot(ma, mb, 'rx');
hold;
title('Simulacao do sistema utilizando o metodo das variaveis instrumentais')
xlabel('Valor da estimativa para a variavel d')
ylabel('Valor da estimativa para a variavel c')
legend('Estimativas', 'Media')

%valor da tabela chi-quadrado para 95% de confianca
chi = 5.991;
ang = linspace(0,2*pi,360)';
[avetor,SCR,avl] = princomp(PN);
Diagonal= diag(sqrt(chi*avl));
elipse=[cos(ang) sin(ang)] * Diagonal * avetor' + repmat(mean(PN), 360, 1);
line(elipse(:,1), elipse(:,2), 'linestyle', '-', 'color', 'k');



