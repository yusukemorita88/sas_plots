ods graphics on/reset noborder imagename = "<filename>" imagefmt = png;
ods listing gpath = "<outpath>";

proc sort data = adam_bds out = adam_bds;
  by paramcd param;
run;

proc univariate data = adam_bds noprint;
  by paramcd param;
  class trtp;
  cdfplot CHG/overlay  odstitle ="#BYVAL2" VAXISLABEL='Cumulative Percent (%)';
run;
