function theta = calc_mmq_theta(m, ul, el)
N=(m.Tf)/(m.Ts)+1;
phy=zeros(N, m.dim);

for k=abs(max(m.regr))+1:N
	for j=1:m.dim
		if m.eul(j) == 1
			phy(k, j)=el(k-abs(m.regr(j)));
		else
			phy(k, j)=ul(k-abs(m.regr(j)));
		end
	end
end
theta=inv(phy'*phy)*phy'*ul;
end