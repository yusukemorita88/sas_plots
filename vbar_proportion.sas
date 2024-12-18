ods graphics on /reset=all imagename = "VBAR_PLOT_&SYSDATE9." noborder;
proc sgplot data = adam_bds pctlevel=group;
    vbar AVISITN/stat=percent group=AVAL seglabel;
    xaxis values=(0 to 10 by 2);
    label AVAL = "Analysis Value" AVISITN = "Analysis Visit";
    keylegend /title = "title" sortorder=ascending;
run;
