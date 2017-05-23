function cubic_interpolation(param1,param1_name, param2, param2_name,th)
    
    sf1 = fit([param1, param2],th,'cubicinterp');
    plot(sf1,[param1,param2], th );
    xlabel(param1_name)
    ylabel(param2_name)
    zlabel('throughput')
    hold on;
end
