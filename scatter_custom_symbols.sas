ods graphics / attrpriority=none;

proc sgplot data = sashelp.class;
  styleattrs
    datacontrastcolors=(blue red)
    datasymbols=(circlefilled trianglefilled);
  scatter x=weight y=height /group=sex;
run;
