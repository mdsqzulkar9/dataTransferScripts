function regression_plot(f, param1,param1_name, param2, param2_name,th)
   
    plot(f,[param1,param2], th );
    xlabel(param1_name)
    ylabel(param2_name)
    zlabel('throughput')
    hold on;
end