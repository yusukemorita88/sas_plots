proc sgplot data = summary;
    scatter x = ATIME y = MEAN/group=TRTAN yerrorupper=UPPER name="TRT";
    series x=ATIME y=MEAN /group=TRTAN ;  
    label ATIME = "Time (h)" Mean = "Plasma Concentration";
    xaxis values = (0 to 72 by 24) ;
    yaxis logbase=10 type=log logstyle=linear logvtype=expanded values=(0.1 1 10 100 1000);
    keylegend "TRT" / position=topright;
run;
