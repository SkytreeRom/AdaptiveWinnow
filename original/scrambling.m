function [resa,resb]=scrambling(seqa,seqb)
length=size(seqa,2);%序列总长度
switchNum=round(0.9*length);
% if mod(switchNum,2)~=0
%     switchNum=switchNum+1;
% end
switchPosition=round(1+(length-1).*rand(1,switchNum));
for i=1:1:size(switchPosition,2)
    tem=seqa(switchPosition(i));
    seqa(switchPosition(i))=seqa(length-switchPosition(i)+1);
    seqa(length-switchPosition(i)+1)=tem;
    
    tem=seqb(switchPosition(i));
    seqb(switchPosition(i))=seqb(length-switchPosition(i)+1);
    seqb(length-switchPosition(i)+1)=tem;
end
resa=seqa;
resb=seqb;
end