function res=checkParity(siftedA,siftedB,blockSize)
seqaMat=vec2mat(siftedA,blockSize);
seqbMat=vec2mat(siftedB,blockSize);
suma=sum(seqaMat,2);
sumb=sum(seqbMat,2);
moda=mod(suma,2);
modb=mod(sumb,2);
num=length(find((moda-modb)~=0));
if num==0
    res=0;
else
    res=(moda==modb);
end
end
