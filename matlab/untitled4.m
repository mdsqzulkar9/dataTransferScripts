
x = [65.45,74.37,86.45];
   bar(x,.3);
   ylim([60 100])
   Labels = {'Quadratic', 'Cubic', 'Cubic Spline'};
   set(gca, 'XTick', 1:4, 'XTickLabel', Labels);
    