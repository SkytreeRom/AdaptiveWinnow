%产生两个序列，并加入错误，随机产生错误就可以先不需要scrambling
clear;
m=5;
blockSize=32;%2^m=blockSize
length=512000;
leakage=0;
falseNum=round(length*0.01);
mNum=3;
seq=round(rand(1,length));
seqa=seq;
errorPosition=round(1+(length-1).*rand(1,falseNum));
for i=1:1:falseNum
    if(seq(errorPosition(i))==1)
        seq(errorPosition(i))=0;
    else
        seq(errorPosition(i))=1;
    end
end
seqb=seq;
ber=berEstimation(seqa,seqb,10);
nber=berEstimation(seqa,seqb,10);
res=checkParity(seqa,seqb,blockSize);%res中0代表出错的位置
seqbTema=vec2mat(seqa,blockSize);
seqbTemb=vec2mat(seqb,blockSize);
berlist=[];total=1;d=0;
while 1
    resultA=[];resultB=[];
    for i=1:1:size(res,1)
        if res(i)==0
            checkBits=hammingCode(seqbTema(i,1:blockSize-1),mNum);
            correctedSeq=hammingErrorCorrection(seqbTemb(i,1:blockSize-1),checkBits,mNum);
            tem=seqbTema(i,1:blockSize-1);
            for t=0:1:m-1
                tem(2^t)=[];
                correctedSeq(2^t)=[];
                leakage=leakage+1;
            end
            resultA=[resultA,tem];
            resultB=[resultB,correctedSeq];
        end
        if res(i)==1
            resultA=[resultA,seqbTema(i,1:blockSize-1)];
            resultB=[resultB,seqbTemb(i,1:blockSize-1)];
            leakage=leakage+1;
        end
    end
    
    podd=(1-(1-2*nber)^32)/2;
    dt=length/blockSize+length/blockSize*podd*log2(blockSize);
    d=d+dt;
    
    nber=berEstimation(resultA,resultB,10);
    berlist(total)=nber;
    [resultA,resultB]=scrambling(resultA,resultB);
    seqbTema=vec2mat(resultA,blockSize);
    seqbTemb=vec2mat(resultB,blockSize);
    %此处有新一轮的结果后应该重新确定res
    res=checkParity(resultA,resultB,blockSize);
    if size(find(res==0),1)<10
        break;
    end
    total=total+1;
    size(find(res==0))
end
berlist=[ber,berlist];
plot(berlist)