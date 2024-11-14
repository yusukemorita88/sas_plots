option nobyline;
ods graphics on/reset=all attrpriority=none imagename="vbox_series" noborder;
title1 "#byval3";

proc sgpanel data = adam_bds noautolegend;
    styleattrs datasymbols=(circle triangle square) datalinepatterns=(solid solid solid);
    by paramn paramcd param;
    panelby SubGroup/rows=2 columns=2 novarname uniscale=column;
    vbox aval/category=avisitn nofill nooutliers whiskerattrs=(thickness=2 color=black) lineattrs=(thickness=2) medianattrs=(thickness=2 color=black) meanattrs=(size=10);
    series x=avisitn y=aval/markers group=subjid groupmc=SubGroup groupms=SubGroup grouplc=SubGroup grouplp=SubGroup transparency=0.5;
    label AVISITN="Analysis Visit (N)" AVAL="Analysis Value";
run;

title;
