clear
m=3;%����m=3�ĺ�����?
[h,g,n,k]=hammgen(m);
msg=[0 0 0 1;
    0 0 0 1;
    0 0 0 1;
    0 0 1 1;
    0 0 1 1;
    0 1 0 1;
    0 1 1 0;
    0 1 1 1;
    1 0 0 0;
    1 0 0 1;
    1 0 1 0;
    1 0 1 1;
    1 1 0 0;
    1 1 0 1;
    1 1 1 0;
    1 1 1 1];
code=encode(msg,n,k,'hamming/binary')%����
C=mod(code*h',2);%�԰���ʽ��2ȡ����
newmsg=decode(code,n,k,'hamming/binary')%����
d_min=min(sum((code(2:2^k,:))'));%��С���