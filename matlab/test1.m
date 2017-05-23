x = -1000:.1:1000;

y1 = x.^2 + x + 1;
y2 = 40*(x-3).^2 + (500*(x+6)) + 5;
y3 = (.3*y1) + .7*y2;
plot(x,y1,'r')
hold on
plot(x,y2,'g')
hold on
plot(x,y3,'b')
