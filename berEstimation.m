function ber=berEstimation(seqa,seqb,blockSize)
seqaMat=vec2mat(seqa,blockSize);
seqbMat=vec2mat(seqb,blockSize);
suma=sum(seqaMat,2);
sumb=sum(seqbMat,2);
moda=mod(suma,2);
modb=mod(sumb,2);
num=length(find((moda-modb)~=0));
total=ceil(size(seqa,2)/blockSize);%…œ»°’˚
%syms berBlock e
berBlock=num/total;
%ber=solve(berBlock==0.5*(1-(1-2*e)^total),e);
%ber=(1-(1-2*berBlock)^(1/total))/2;
ber=(1-(1-2*berBlock)^(1/blockSize))/2;
end