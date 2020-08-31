***************************************;
*https://support.sas.com/kb/65/202.html;
%let xvar = WEIGHT;
%let yvar = HEIGHT;
%let dsin = ADSL;
%let filename = plot1; %*without extension;

/* Suppress procedure output */
ods exclude all; 

/* Use PROC REG to obtain the parameter estimates and descriptive 
   statistics for a simple linear regression model */
ods graphics on;
proc reg data = &dsin.;
    model &yvar. = &xvar.;
    ods output fitplot=fitplotex1 fitstatistics=gofex1 parameterestimates=peex1 nobs=nex1 anova=aovex1;
quit;
/* Include subsequent procedure output */
ods select all;

/* Create macro variables for the statistics to add to the plot */

proc sql noprint;
  select count(model) into :obs
     from fitplotex1;
     select count(model) into :parms
     from peex1;
quit;

data _null_;
    set aovex1;
    where source='Error';
    call symput('errdf',df);
    call symput('mse',put(ms,comma7.2));
run;

data _null_;
    set gofex1;
    /* English */
    *if label2='R-Square' then call symput('rsq',cvalue2);    
    *if label2='R-Square' then call symput('corr',sqrt(cvalue2));    
    *if label2='Adj R-Sq' then call symput('adjrsq',cvalue2);
    /* Japanese */
    if label2='R2 乗' then call symput('rsq',cvalue2);
    if label2='R2 乗' then call symput('corr', strip(put(sqrt(cvalue2),8.3)));
    if label2='調整済み R2 乗' then call symput('adjrsq',cvalue2);

run;

data _null_;
    set peex1 end=last;
    retain intercept ;
    if variable='Intercept' then Intercept=estimate;
    if upcase(variable)="%upcase(&xvar.)" then X=estimate;
    if last then  call symput('eqn',"Y = "|| strip(put(Intercept,8.5)) ||" + "|| strip(put(X, 8.5)) ||"* X");
run;

ods listing gpath='.';
ods graphics / imagename="&filename." imagefmt=png noborder;

proc sgplot data=&dsin.;
    reg y = &yvar. x =  &xvar./ nomarkers/*clm cli*/;
    scatter y = &yvar. x = &xvar./group=TRT01A;
    inset 
        ("Observations"="&obs" 
        "Parameters"= "&parms"
        "Error DF"="&errdf"
        "MSE"="&mse"
        "R-Square"="&rsq"
    	"Adj R-Square"="&adjrsq")/ border position=bottomright;
    inset "Regression Equation : &eqn" "Correlation coefficients : &corr" / position=topleft; 
    *refline 0 /axis=x lineattrs=(pattern=3);
    *refline 0 /axis=y lineattrs=(pattern=3);
    *yaxis values=(-35 to 35 by 5);
run;
