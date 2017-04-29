function correctedSeq=hammingErrorCorrection(seqTem,checkBits,mNum)

[h,g,n,k]=hammgen(mNum);
seqMat=vec2mat(seqTem,k);
code=[checkBits,seqMat];
newmsg=decode(code,n,k,'hamming/binary');
temSeq=mat2vec(newmsg,'row');
temSeq=temSeq';
correctedSeq=temSeq(1:size(seqTem,2));
end