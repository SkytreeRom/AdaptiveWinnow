%%
%产生两个序列，并加入错误，随机产生错误就可以先不需要scrambling
blockSize=32;
length=512000;
falseNum=1000;
seq=round(rand(1,length));
seqa=seq;
mNum=3;
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

%%
%winnow
%寻找b1
sizeBound=floor(0.4/ber);
i=1;
while 2^i<=sizeBound
    i=i+1;
end
b1=2^i;
res=checkParity(seqa,seqb,b1);%res中0代表出错的位置
seqbTema=vec2mat(seqa,b1);
seqbTemb=vec2mat(seqb,b1);
Kodda=[];Koddb=[];Kevena=[];Kevenb=[];j=1;k=1;%j,k用于分别计数匹配和不匹配的情况
for i=1:1:size(res,1)
    if res(i)==0
        checkBits=hammingCode(seqbTema(i,:),mNum);
        correctedSeq=hammingErrorCorrection(seqbTemb(i,:),checkBits,mNum);
        Kodda(j,:)=seqbTema(i,:);
        Koddb(j,:)=correctedSeq;
        j=j+1;
    end
    if res(i)==1
        Kevena(k,:)=seqbTema(i,:);
        Kevenb(k,:)=seqbTemb(i,:);
        k=k+1;
    end
end
tema=mat2vec([Kevena;Kodda],'row');%测试ber的数据来源要想一想
temb=mat2vec([Kevenb;Koddb],'row');
% tema=mat2vec(Kevena,'row');
% temb=mat2vec(Kevenb,'row');
nber=berEstimation(tema',temb',10);
sizeBound=floor(0.4/ber);
i=1;
while 2^i<=sizeBound
    i=i+1;
end
bneven=2^i;%第二轮及以后的块大小
bnodd=2*bneven;
%%
%下面分别对odd和even序列处理
%把even odd都都变成向量处理好一点
while 1
    %对even处理部分
    tema=mat2vec(Kevena,'row');
    temb=mat2vec(Kevenb,'row');
    [tema,temb]=scrambling(tema',temb');
    res=checkParity(tema,temb,bneven);%res中0代表出错的位置
    seqbTema=vec2mat(Kevena,bneven);
    seqbTemb=vec2mat(Kevenb,bneven);
    Knodda_1=[];Knoddb_1=[];Knevena_1=[];Knevenb_1=[];j=1;k=1;
    Knodda_2=[];Knoddb_2=[];Knevena_2=[];Knevenb_2=[];
    for i=1:1:size(res,1)
        if size(res,1)>1
            if res(i)==0
                checkBits=hammingCode(seqbTema(i,:),mNum);
                correctedSeq=hammingErrorCorrection(seqbTemb(i,:),checkBits,mNum);
                Knodda_1(j,:)=seqbTema(i,:);
                Knoddb_1(j,:)=correctedSeq;
                j=j+1;
            end
            if res(i)==1
                Knevena_1(k,:)=seqbTema(i,:);
                Knevenb_1(k,:)=seqbTemb(i,:);
                k=k+1;
            end
        end
    end
    
    %对odd处理部分
    tema=mat2vec(Kodda,'row');
    temb=mat2vec(Koddb,'row');
    [tema,temb]=scrambling(tema',temb');
    res=checkParity(tema,temb,bnodd);%res中0代表出错的位置
    seqbTema=vec2mat(Kodda,bnodd);
    seqbTemb=vec2mat(Koddb,bnodd);
    for i=1:1:size(res,1)
        if size(res,1)>1
            if res(i)==0
                checkBits=hammingCode(seqbTema(i,:),mNum);
                correctedSeq=hammingErrorCorrection(seqbTemb(i,:),checkBits,mNum);
                Knodda(j,:)=seqbTema(i,:);
                Knoddb(j,:)=correctedSeq;
                j=j+1;
            end
            if res(i)==1
                Knevena(k,:)=seqbTema(i,:);
                Knevenb(k,:)=seqbTemb(i,:);
                k=k+1;
            end
        end
    end
    tema=mat2vec([Knevena;Knodda],'row');%测试ber的数据来源要想一想
    temb=mat2vec([Knevenb;Knoddb],'row');
    %对一轮纠正后的结果进行奇偶校验
    res=checkParity(tema,temb,b1);
    if size(find(res==0),1)==0
        break;
    end
    nber=berEstimation(tema',temb',10);
    sizeBound=floor(0.4/ber);
    i=1;
    while 2^i<=sizeBound
        i=i+1;
    end
    bneven=2^i;%第二轮及以后的块大小
    bnodd=2*bneven;
    Kevena=Knevena;
    Kevenb=Knevenb;
    Kodda=Knodda;
    Koddb=Knoddb;
    nber
end