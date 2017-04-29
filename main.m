%%
%�����������У���������������������Ϳ����Ȳ���Ҫscrambling
clear;
blockSize=32;
length=512000;
falseNum=20000;
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
%Ѱ��b1
sizeBound=floor(0.4/ber);
i=1;
while 2^i<=sizeBound
    i=i+1;
end
b1=2^i;
res=checkParity(seqa,seqb,b1);%res��0����������λ��
seqbTema=vec2mat(seqa,b1);
seqbTemb=vec2mat(seqb,b1);
Kodda=[];Koddb=[];Kevena=[];Kevenb=[];j=1;k=1;%j,k���ڷֱ����ƥ��Ͳ�ƥ������
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
tema=mat2vec([Kevena;Kodda],'row');%����ber��������ԴҪ��һ��
temb=mat2vec([Kevenb;Koddb],'row');
% tema=mat2vec(Kevena,'row');
% temb=mat2vec(Kevenb,'row');
nber=berEstimation(tema',temb',10);
firstber=nber;
sizeBound=floor(0.4/nber);
i=1;
while 2^i<=sizeBound
    i=i+1;
end
bneven=2^i;%�ڶ��ּ��Ժ�Ŀ��С
bnodd=2*bneven;
%%
%����ֱ��odd��even���д���
%��even odd�����������������һ��
total=1;berlist=[];
while 1
    %��even��������
    tema=mat2vec(Kevena,'row');
    temb=mat2vec(Kevenb,'row');
    [tema,temb]=scrambling(tema',temb');
    res=checkParity(tema,temb,bneven);%res��0����������λ��
    seqbTema=vec2mat(tema,bneven);
    seqbTemb=vec2mat(temb,bneven);
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
    %������ɺ�������Knevena_1 Knodda_1��Knevenb_1 Knoddb_1
    %��odd��������
    j=1;k=1;
    tema=mat2vec(Kodda,'row');
    temb=mat2vec(Koddb,'row');
    [tema,temb]=scrambling(tema',temb');
    res=checkParity(tema,temb,bnodd);%res��0����������λ��
    seqbTema=vec2mat(tema,bnodd);
    seqbTemb=vec2mat(temb,bnodd);
    for i=1:1:size(res,1)
        if size(res,1)>1
            if res(i)==0
                checkBits=hammingCode(seqbTema(i,:),mNum);
                correctedSeq=hammingErrorCorrection(seqbTemb(i,:),checkBits,mNum);
                Knodda_2(j,:)=seqbTema(i,:);
                Knoddb_2(j,:)=correctedSeq;
                j=j+1;
            end
            if res(i)==1
                Knevena_2(k,:)=seqbTema(i,:);
                Knevenb_2(k,:)=seqbTemb(i,:);
                k=k+1;
            end
        end
    end
    
    %������ɺ�������Knevena_2 Knodda_2��Knevenb_2 Knoddb_2
    tema_1=mat2vec([Knevena_1;Knodda_1],'row');%����ber��������ԴҪ��һ��,ԭ������even������even��odd
    tema_2=mat2vec([Knevena_2;Knodda_2],'row');%ԭ������odd������even��odd
    tema=[tema_1',tema_2'];
    temb_1=mat2vec([Knevenb_1;Knoddb_1],'row');
    temb_2=mat2vec([Knevenb_2;Knoddb_2],'row');
    temb=[temb_1',temb_2'];
    %��һ�־�����Ľ��������żУ��
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
    bneven=2^i;%�ڶ��ּ��Ժ�Ŀ��С
    bnodd=2*bneven;
    %�˴���Ҫ��even��odd������װ
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
end
addpath('./original');
berlist=[firstber,berlist];
plot(berlist);
hold on;
main_original;