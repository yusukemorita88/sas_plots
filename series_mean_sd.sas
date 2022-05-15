proc format;
    value avis
     0 = "Baseline"
    12= "Week 12"
    24= "Week 24"
    36= "Week 36"
    48= "Week 48"
    ;
    value trt
    1 = "Active"
    2 = "Placebo"
    ;
run;

ods graphics/reset=all imagename = "<filename(without extension)>" width=16 in height = 9 in  noborder;
ods listing gpath = ".";

proc sgplot data = adam_bds;
    where PARAMCD = "<your parameter>";
    vline AVISITN /response = AVAL group = TRTPN groupdisplay = cluster
                         clusterwidth=0.2 stat = mean limitstat = stddev limits = both markers ;
    xaxis values= (0 to 48 by 12);
    format AVISITN avis. TRTPN trt.;
    label AVISITN = "Analysis Visit" AVAL = "Analysis Value (unit)" SUBJID = "Subject ID" TRTPN = "Treatment";
run;
