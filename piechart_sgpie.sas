*SAS9.4TS1M6later;
data my_data; 
    set sashelp.class;
    length gender $10;
    if sex='M' then gender='Males';
    if sex='F' then gender='Females';
run;

ods graphics / imagefmt=png imagename="pie_sgpie" width=500px height=400px noborder noscale;

title1 c=gray33 h=18pt "SGpie - Pie Chart";

proc sgpie data=my_data;
    styleattrs datacolors=(dodgerblue pink);
    pie gender / startpos=edge
        startangle=90 direction=clockwise sliceorder=respdesc
        datalabeldisplay=all datalabelattrs=(size=10pt weight=bold);
run;
