title1 j = center height=14pt "figure title";

proc freq data = adam_bds;
    by AVISITN AVISIT;
    tables AVAL/out=out1 binomial(exact);
    ods output binomialcls = out2 ;
run;

data proc_freq_out;
    merge out1 out2;
    by AVISITN;

    lower = lowercl * 100;
    upper = uppercl * 100;
run;

proc sgplot data = proc_freq_out;
    hbarparm response = PERCENT category = AVISIT /limitlower = lower limitupper = upper barwidth=0.3 fillattrs=(color=lightgray) limitattrs=(color=gray);
    xaxis values = (0 to 100 by 20) label = " " grid valueattrs=(size=12);
    yaxis label = " "  valueattrs=(size=12);
run;
