%%
%产生两个序列，并加入错误，随机产生错误就可以先不需要scrambling
clear;
blockSize=32;
length=512000;
falseNum=round(length*0.03);
leakageNum=0;
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
        checkBits=hammingCode(seqbTema(i,1:b1-1),mNum);
        correctedSeq=hammingErrorCorrection(seqbTemb(i,1:b1-1),checkBits,mNum);
        tem=seqbTema(i,1:b1-1);
        m=log2(b1);
        for t=0:1:m-1
            tem(2^t)=[];
            correctedSeq(2^t)=[];
            leakageNum=leakageNum+1;
        end
        Kodda(j,:)=tem;
        Koddb(j,:)=correctedSeq;
        j=j+1;
    end
    if res(i)==1
        Kevena(k,:)=seqbTema(i,1:b1-1);
        Kevenb(k,:)=seqbTemb(i,1:b1-1);
        k=k+1;
        leakageNum=leakageNum+1;
    end
end
tea=mat2vec(Kevena,'row');
toa=mat2vec(Kodda,'row');
teb=mat2vec(Kevenb,'row');
tob=mat2vec(Koddb,'row');
tema=[tea;toa];
temb=[teb;tob];
% tema=mat2vec([Kevena;Kodda],'row');%测试ber的数据来源要想一想
% temb=mat2vec([Kevenb;Koddb],'row');
% tema=mat2vec(Kevena,'row');
% temb=mat2vec(Kevenb,'row');
nber=berEstimation(tema',temb',10);
firstber=nber;
sizeBound=floor(0.4/nber);
i=1;
while 2^i<=sizeBound
    i=i+1;
end
bneven=2^i;%第二轮及以后的块大小
bnodd=2*bneven;
%%
%下面分别对odd和even序列处理
%把even odd都都变成向量处理好一点
total=1;berlist=[];
while 1
    %对even处理部分
    tema=mat2vec(Kevena,'row');
    temb=mat2vec(Kevenb,'row');
    [tema,temb]=scrambling(tema',temb');
    res=checkParity(tema,temb,bneven);%res中0代表出错的位置
    seqbTema=vec2mat(tema,bneven);
    seqbTemb=vec2mat(temb,bneven);
    Knodda_1=[];Knoddb_1=[];Knevena_1=[];Knevenb_1=[];j=1;k=1;
    Knodda_2=[];Knoddb_2=[];Knevena_2=[];Knevenb_2=[];
    for i=1:1:size(res,1)
        if size(res,1)>1
            if res(i)==0
                checkBits=hammingCode(seqbTema(i,1:bneven-1),mNum);
                correctedSeq=hammingErrorCorrection(seqbTemb(i,1:bneven-1),checkBits,mNum);
                tem=seqbTema(i,1:bneven-1);
                m=log2(bneven);
                for t=0:1:m-1
                    tem(2^t)=[];
                    correctedSeq(2^t)=[];
                    leakageNum=leakageNum+1;
                end
                Knodda_1(j,:)=tem;
                Knoddb_1(j,:)=correctedSeq;
                j=j+1;
                leakageNum=leakageNum+1;
            end
            if res(i)==1
                Knevena_1(k,:)=seqbTema(i,1:bneven-1);
                Knevenb_1(k,:)=seqbTemb(i,1:bneven-1);
                k=k+1;
                leakageNum=leakageNum+1;
            end
        end
    end
    %运行完成后会产生，Knevena_1 Knodda_1和Knevenb_1 Knoddb_1
    %对odd处理部分
    j=1;k=1;
    tema=mat2vec(Kodda,'row');
    temb=mat2vec(Koddb,'row');
    [tema,temb]=scrambling(tema',temb');
    res=checkParity(tema,temb,bnodd);%res中0代表出错的位置
    seqbTema=vec2mat(tema,bnodd);
    seqbTemb=vec2mat(temb,bnodd);
    for i=1:1:size(res,1)
        if size(res,1)>1
            if res(i)==0
                checkBits=hammingCode(seqbTema(i,1:bnodd-1),mNum);
                correctedSeq=hammingErrorCorrection(seqbTemb(i,1:bnodd-1),checkBits,mNum);
                tem=seqbTema(i,1:bnodd-1);
                m=log2(bnodd);
                for t=0:1:m-1
                    tem(2^t)=[];
                    correctedSeq(2^t)=[];
                    leakageNum=leakageNum+1;
                end
                Knodda_2(j,:)=tem;
                Knoddb_2(j,:)=correctedSeq;
                j=j+1;
                leakageNum=leakageNum+1;
            end
            if res(i)==1
                Knevena_2(k,:)=seqbTema(i,1:bnodd-1);
                Knevenb_2(k,:)=seqbTemb(i,1:bnodd-1);
                k=k+1;
                leakageNum=leakageNum+1;
            end
        end
    end
    
    %运行完成后会产生，Knevena_2 Knodda_2和Knevenb_2 Knoddb_2
%     tema_1=mat2vec([Knevena_1;Knodda_1],'row');%测试ber的数据来源要想一想,原本就是even产生的even和odd
%     tema_2=mat2vec([Knevena_2;Knodda_2],'row');%原本就是odd产生的even和odd
%     tema=[tema_1',tema_2'];
%     temb_1=mat2vec([Knevenb_1;Knoddb_1],'row');
%     temb_2=mat2vec([Knevenb_2;Knoddb_2],'row');
%     temb=[temb_1',temb_2'];
    kea_1=mat2vec(Knevena_1,'row');
    koa_1=mat2vec(Knodda_1,'row');
    kea_2=mat2vec(Knevena_2,'row');
    koa_2=mat2vec(Knodda_2,'row');
    
    keb_1=mat2vec(Knevenb_1,'row');
    kob_1=mat2vec(Knoddb_1,'row');
    keb_2=mat2vec(Knevenb_2,'row');
    kob_2=mat2vec(Knoddb_2,'row');
%     tea=mat2vec(Knevena,'row');
%     toa=mat2vec(Knodda,'row');
%     teb=mat2vec(Knevenb,'row');
%     tob=mat2vec(Knoddb,'row');
    tema=[kea_1',koa_1',kea_2',koa_2'];
    temb=[keb_1',kob_1',keb_2',kob_2'];
    %对一轮纠正后的结果进行奇偶校验
    res=checkParity(tema,temb,b1);
    if size(res,1)==1
        break;
    end
    nber=berEstimation(tema,temb,10);
    sizeBound=floor(0.4/nber);
    i=1;
    while 2^i<=sizeBound
        i=i+1;
    end
    bneven=2^i;%第二轮及以后的块大小
    bnodd=2*bneven;
    %此处需要对even和odd进行组装
    temevena_1=mat2vec(Knevena_1,'row');
    temevena_2=mat2vec(Knevena_2,'row');
    temevenb_1=mat2vec(Knevenb_1,'row');
    temevenb_2=mat2vec(Knevenb_2,'row');
    temodda_1=mat2vec(Knodda_1,'row');
    temodda_2=mat2vec(Knodda_2,'row');
    temoddb_1=mat2vec(Knoddb_1,'row');
    temoddb_2=mat2vec(Knoddb_2,'row');
    Kevena=[temevena_1',temevena_2'];
    Kevenb=[temevenb_1',temevenb_2'];
    Kodda=[temodda_1',temodda_2'];
    Koddb=[temoddb_1',temoddb_2'];
    berlist(total)=nber;
    bneven
    bnodd
    nber
    total=total+1;
    total
end
addpath('./original');
berlist=[firstber,berlist];
plot(berlist);
xlabel('Round')
ylabel('BER')
%hold on;
% main_original;
