*https://proceedings.wuss.org/2019/167_Final_Paper_PDF.pdf;

proc format;
    invalue bmtnum 'ALL'=1 'AML-Low Risk'=2 'AML-High Risk'=3;
    value bmtfmt 1='ALL' 2='AML-Low Risk' 3='AML-High Risk';
run;

data bmt(drop=g label="Bone Marrow Transplant Patients");
    set sashelp.bmt(rename=(group=g));
    Group = input(g, bmtnum.);
    format group bmtfmt.;
run;

ods output SurvivalPlot=sp1 HomTests=pval1;
proc lifetest data=bmt plots=survival(test cl atrisk(atrisktickonly outside maxlen=13) = 0 to 2500 by 500);
    time t*status(0);
    strata group / order=internal;
run; 
quit;

data _null_;
    set pval1(where=(lowcase(test) in ("log-rank", "ログランク")));
    call symputx("LRPV",put(ProbChiSq,6.4),"G");
run;

ods select all;
ods graphics  /reset=index noborder imagename="filename" imagefmt=png width=16 cm height=9 cm;
title "Product-Limit Survival Estimates";
title2 height=0.8 "With Number of Subjects at Risk";
proc sgplot data=sp1;
    styleattrs
      datacolors = (blue maroon green)
      datacontrastcolors = (blue maroon green)
      datalinepatterns = (1 1 1)
    ;
    step x=time y=survival / group=stratum name='km'; *kaplan-meier plot;
    band x=time upper=sdf_ucl lower=sdf_lcl /group=stratum  modelname='km' transparency=.8;*CI band;
    keylegend 'km' / location=outside title="Group";
    scatter x=time y=censored / markerattrs=(symbol=plus) name='censor';
    scatter x=time y=censored / markerattrs=(symbol=plus) group=stratum;
    keylegend 'censor' / location=inside position=topright type=markersymbol;
    yaxis values=(0.0 0.2 0.4 0.6 0.8 1.0) labelattrs=(size=12) valueattrs=(size=12);
    inset "Log-Rank p = &LRPV." / position=top border;
    xaxistable atrisk / x=tatrisk class=stratum colorgroup=stratum location=outside  valueattrs=(size=10) labelattrs=(size=10);
run;
