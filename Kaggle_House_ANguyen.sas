FILENAME REFFILE '/folders/myfolders/sasuser.v94/test.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=test;
	GETNAMES=YES;
RUN;

FILENAME REFFILE '/folders/myfolders/sasuser.v94/train.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=train;
	GETNAMES=YES;
RUN;

/*Filter only relevant Neighborhoods for Q1.  NAmes, Edwards, BrkSide*/
data neighborhoodSS;
	set train;
	where Neighborhood = 'NAmes' or Neighborhood = 'Edwards' or Neighborhood='BrkSide';
run;

/* Create GrLivAreaper100 variable, log Transform the SalesPrice and GrLivAreaper100 to re-run model */
data logneighborhoodSS;
	set neighborhoodSS;
	GrLivAreaper100 = GrLivArea/100;
	logSalePrice = log(SalePrice);
	logGrLivAreaper100 = log(GrLivArea/100);
run;

proc print data = logneighborhoodSS;
run;

/*Scatterplot the Saleprice to GrLivArea for the three requested neighborhoods*/
proc sgplot data=logneighborhoodSS;
scatter x=GrLivAreaper100 y=SalePrice / group=Neighborhood; 
run;

/* Model for Salesprice to GrLivArea*/
proc glm data = logneighborhoodSS plots=all;
class Neighborhood;
model SalePrice = GrLivAreaper100 | Neighborhood / cli clm clparm;
run;

/*Filter out all homes greater than 40 100 sq.ft.*/
data logneighborhoodSSsmall;
	set logneighborhoodSS;
	where GrLivAreaper100 <= 40;
run;

/* Model for Salesprice to GrLivArea*/
proc glm data = logneighborhoodSSsmall plots=all;
class Neighborhood;
model SalePrice = GrLivAreaper100 | Neighborhood / cli clm clparm;
run;

/*Filter out all homes that costs more than $300,000*/
data logneighborhoodSScheap;
	set logneighborhoodSS;
	where SalePrice <= 300000;
run;

/* Model for Salesprice to GrLivArea*/
proc glm data = logneighborhoodSScheap plots=all;
class Neighborhood;
model SalePrice = GrLivAreaper100 | Neighborhood / cli clm clparm;
run;

/*Filter out all homes that costs more than $300,000 and smaller than 40 100 sq. ft.*/
data logneighborhoodSScheapsmall;
	set logneighborhoodSS;
	where SalePrice <= 300000 and GrLivAreaper100 <= 40;
run;

/* Model for Salesprice to GrLivArea*/ 
proc glm data = logneighborhoodSScheapsmall plots=all;
class Neighborhood;
model SalePrice = GrLivAreaper100 | Neighborhood / cli clm clparm;
run;

/* Model with log transformed SalePrice*/
proc glm data = logneighborhoodSS plots=all;
class Neighborhood;
model logSalePrice = GrLivAreaper100 | Neighborhood / cli clm clparm;
run;

/* Model with log transformed GrLivAreaper100*/
proc glm data = logneighborhoodSS plots=all;
class Neighborhood;
model SalePrice = logGrLivAreaper100 | Neighborhood / cli clm clparm;
run;

/* Model with log-log transformed SalePrice-GrLivAreaper100*/
proc glm data = logneighborhoodSS plots=all;
class Neighborhood;
model logSalePrice = logGrLivAreaper100 | Neighborhood / cli clm clparm;
run;

