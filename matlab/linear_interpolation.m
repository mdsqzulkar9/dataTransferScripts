
function linear_interpolation(cc1,cc2,cc3,p1,p2,p3,th1,th2,th3)
      figure
    sf1 = fit([cc1, p1],th1,'linearinterp')
    plot(sf1,[cc1,p1],th1 )
    xlabel('cc')
    ylabel('p')
    zlabel('throughput')
    hold on
    sf2 = fit([cc2, p2],th2,'linearinterp')
    plot(sf2,[cc2,p2],th2)
    
    hold on
    sf3 = fit([cc3, p3],th3,'linearinterp')
    plot(sf3,[cc3,p3],th3)

end