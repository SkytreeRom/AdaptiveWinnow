function res=hammingCode(seqTem,mNum)
num=size(seqTem,2);
[h,g,n,k]=hammgen(mNum);
seqMat=vec2mat(seqTem,k);
code=encode(seqMat,n,k,'hamming/binary');%±àÂë
res=code(:,1:mNum);
end
