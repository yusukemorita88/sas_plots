title 'Overlaying a boxplot and scatter plot with jittering effects';
proc sgplot data=adam_bds;
    vbox chg / category=avisitn group=trta fillattrs=(transparency=1) nooutliers nomean;
    scatter y=chg x=avisitn/group=trta groupdisplay=cluster jitter;
    xaxis label="Analysis Visit (week)";
    yaxis label="Change of XXXX (units)" max=40;
    keylegend / title="Treatment group";
run;

