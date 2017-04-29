clear
m=3;%给定m=3的汉明码?
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
code=encode(msg,n,k,'hamming/binary')%编码
C=mod(code*h',2);%对伴随式除2取余数
newmsg=decode(code,n,k,'hamming/binary')%解码
d_min=min(sum((code(2:2^k,:))'));%最小码距