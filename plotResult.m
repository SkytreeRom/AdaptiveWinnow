load('result.mat')
x=result(1,:);
xx=x.*log2(1./x);
y1=result(2,:)./xx;
y2=result(3,:)./xx;
plot(x,y1)
hold on
plot(x,y2)
legend('adaptive method','original method')
xlabel('initial error rate')
ylabel('discared bits(%)')