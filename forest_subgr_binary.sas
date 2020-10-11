*https://blogs.sas.com/content/graphicallyspeaking/files/2016/05/Subgrouped_Forest_Plot_SG_94.txt;
%let gpath='.';
%let dpi=200;
ods html close;
ods listing gpath=&gpath image_dpi=&dpi;

/*--Add "Id" to identify subgroup headings from values--*/
data forest_subgroup;
  label PCIGroup='PCI Group' Group='Therapy Group';
  input Id Subgroup $3-27 Count Percent Mean  Low  High  PCIGroup Group PValue;
  label countpct='No. (%) of Patients';
  indentWt=1;
  ObsId=_n_; 
  if count ne . then CountPct=put(count, 4.0) || "(" || put(percent, 3.0) || ")";
  datalines;
1 Overall                  2166  100  1.3   0.9   1.5  17.2  15.6  .
1 Age                      .     .    .     .     .    .     .     0.05
2   <= 65 Yr               1534   71  1.5   1.05  1.9  17.0  13.2   .
2   > 65 Yr                 632   29  0.8   0.6   1.25 17.8  21.3   .
1 Sex                      .     .    .     .     .    .     .     0.13
2   Male                   1690   78  1.5   1.05  1.9  16.8  13.5   .
2   Female                  476   22  0.8   0.6   1.3  18.3  22.9   . 
1 Race or ethnic group     .     .    .     .     .    .     .     0.52
2   Nonwhite                428   20  1.05  0.6   1.8  18.8  17.8   .
2   White                  1738   80  1.2   0.85  1.6  16.7  15.0   . 
1 From MI to Randomization .     .    .     .     .    .     .     0.81
2   <= 7 days               963   44  1.2   0.8   1.5  18.9  18.6   .
2   > 7 days               1203   56  1.15  0.75  1.5  15.9  12.9   .
1 Diabetes                 .     .    .     .     .    .     .     0.41
2   Yes                     446   21  1.4   0.9   2.0  29.3  23.3   .
2   No                      720   79  1.1   0.8   1.5  14.4  13.5   . 
;
run;

/*ods html;*/
/*proc print;run;*/
/*ods html close;*/

/*--Set indent weight, add insets and horizontal bands--*/
data forest_subgroup_2;
    set forest_subgroup nobs=n end=last;
    length text $20;
    val=mod(_N_-1, 6);
    if val eq 1 or val eq 2 or val eq 3 then ref=obsid;

    /*--Separate Subgroup headers and obs into separate columns--*/
    indentwt=1;
    if id=1 then indentWt=0;

    output;
    if last then do;
        call missing (subgroup, count, percent, mean, low, high, 
                      pcigroup, group, countpct, indentwt, val, ref);
        obsid=n+1; 
        xl=0.4; 
        yl=n+1;
        text='P'; 
        output;;
        xl=1.7; 
        yl=n+1;
        text='T';
        output;
  end;
  run;

/*--Define Format with Unicode for the left and right arrows--*/
proc format;;
    value $txt
    "T" = "Therapy Better (*ESC*){Unicode '2192'x}"
    "P" = "(*ESC*){Unicode '2190'x} PCI Better";
run;

/*--Attribute maps for Subgroup Test attributes--*/
data attrmap;
    length textweight $10;
    id='text'; value='1'; textcolor='Black'; textsize=7; textweight='bold'; output;
    id='text'; value='2'; textcolor='Black'; textsize=5; textweight='normal'; output;
run;

/*--Forest Plot--*/
options missing=' ';
ods listing style=htmlBlue;
title j=r h=7pt '4-Yr Cumulative Event Rate';
ods graphics / reset width=5in height=3in imagename='Subgroup_Forest_SG_94';
proc sgplot data=forest_subgroup_2 nowall noborder nocycleattrs dattrmap=attrmap noautolegend;
    format text $txt.;
    styleattrs axisextent=data;
    refline ref / lineattrs=(thickness=13 color=cxf0f0f7);
    highlow y=obsid low=low high=high; 
    scatter y=obsid x=mean / markerattrs=(symbol=squarefilled);
    scatter y=obsid x=mean / markerattrs=(size=0) x2axis;
    refline 1 / axis=x;
    text x=xl y=obsid text=text / position=bottom contributeoffsets=none strip;
    yaxistable subgroup  / location=inside position=left textgroup=id labelattrs=(size=7) 
             textgroupid=text indentweight=indentWt;
    yaxistable countpct / location=inside position=left labelattrs=(size=7) valueattrs=(size=7);
    yaxistable PCIGroup group pvalue / location=inside position=right pad=(right=15px) 
             labelattrs=(size=7) valueattrs=(size=7);
    yaxis reverse display=none colorbands=odd colorbandsattrs=(transparency=1) offsetmin=0.0;
    xaxis display=(nolabel) values=(0.0 0.5 1.0 1.5 2.0 2.5);
    x2axis label='Hazard Ratio' display=(noline noticks novalues) labelattrs=(size=8);
run;
