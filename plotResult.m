load('result.mat')
x=result(1,:);
y1=result(2,:);
y2=result(3,:);
plot(x,y1)
hold on
plot(x,y2)
legend('adaptive method','original method')
xlabel('initial error rate')
ylabel('discared bits(%)')