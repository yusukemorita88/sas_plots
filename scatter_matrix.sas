title "Scatterplot Matrix for Iris Data";
proc sgscatter data=sashelp.iris;
     matrix sepallength petallength sepalwidth petalwidth /group=species ;
run;

title "Scatterplot Matrix for Iris Data";
proc sgscatter data=sashelp.iris;
     plot 
        ( sepallength petallength sepalwidth petalwidth ) * 
        ( sepallength petallength sepalwidth petalwidth )
     /reg=(nogroup) group=species ;
run;

title "Scatterplot Matrix for Iris Data";
proc sgscatter data=sashelp.iris;
     compare 
        x = ( sepallength petallength sepalwidth petalwidth )
        y = ( sepallength petallength sepalwidth petalwidth )
     /reg=(nogroup) group=species ;
run;

