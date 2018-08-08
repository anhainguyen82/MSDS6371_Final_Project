FILENAME REFFILE '/home/atho0/Files/test.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=test;
	GETNAMES=YES;
RUN;

FILENAME REFFILE '/home/atho0/Files/train.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=train;
	GETNAMES=YES;
RUN;

/*Filter only relevant Neighborhoods for Q1.  NAmes, Edwards, BrkSide*/
data work.neighborhoodSS;
	set train;
	where Neighborhood = 'NAmes'or Neighborhood = 'Edwards' or Neighborhood='BrkSide';
run;

/* Log Transform the SalesPrice to re-run model
data logneighborhoodSS;
	set neighborhoodSS;
	logSalePrice = log(SalePrice);
	logGrLivArea = log(GrLivArea);
*/

/* Create GrLivAreaper100 variable, log Transform the SalesPrice and GrLivAreaper100 to re-run model */
data logneighborhoodSS;
	set neighborhoodSS;
	GrLivAreaper100 = GrLivArea/100;
	logSalePrice = log(SalePrice);
	logGrLivAreaper100 = log(GrLivArea/100);
run;

/*Filter out all homes greater than 40 100 sq.ft.*/
data logneighborhoodSSsmall;
	set logneighborhoodSS;
	where GrLivAreaper100 <= 40;
run;

/*Filter out all homes that costs more than $300,000*/
data logneighborhoodSScheap;
	set logneighborhoodSS;
	where SalePrice <= 300000;
run;

/*Filter out all homes that costs more than $300,000 and smaller than 40 100 sq. ft.*/
data logneighborhoodSScheapsmall;
	set logneighborhoodSS;
	where SalePrice <= 300000 and GrLivAreaper100 <= 40;
run;

proc print data = test;
run;

proc print data = neighborhoodSS;
run;

proc print data = logneighborhoodSS;
run;

proc print data = logneighborhoodSSsmall;
run;

proc print data = logneighborhoodSScheap;
run;

/*****************End of Data Code************************************/

/*Descriptive Statistics - Means for the three neighborhoods*/
proc means data=neighborhoodss;
*class Neighborhood;
run;

/*Scatterplot the Saleprice to GrLivArea for the three requested neighborhoods*/
proc sgplot data=neighborhoodSS;
scatter x=GrLivArea y=SalePrice / group=Neighborhood; 
run;

/* Addendum 1:Model for Salesprice to GrLivArea*/
proc glm data = neighborhoodSS plots=all;
class Neighborhood;
model SalePrice = GrLivArea | Neighborhood / cli solution;
run;

/* Addendum 2: Model with log transformed SalePrice*/
proc glm data = logneighborhoodSS plots=all;
class Neighborhood;
model logSalePrice = GrLivAreaper100 | Neighborhood / cli solution;
run;

/* Addendum 3: Model with log transformed GrLiveArea100*/
proc glm data = logneighborhoodSS plots=all;
class Neighborhood;
model SalePrice = logGrLivAreaper100 | Neighborhood / cli solution;
run;

/* Addendum 4: Model with log transformed GrLivArea100*/
proc glm data = logneighborhoodSS plots=all;
class Neighborhood;
model logSalePrice = logGrLivAreaper100 | Neighborhood / cli solution;
run;

/* Addendum 5: Model for Salesprice to GrLivArea100 with subset cheap and small*/ 
proc glm data = logneighborhoodSScheapsmall plots=all;
class Neighborhood;
model SalePrice = GrLivAreaper100 | Neighborhood / cli solution;
run;

/* Addendum 6: Model for log-linear for removing outliers*/
proc glm data = logneighborhoodSScheapsmall plots = all;
class Neighborhood;
model logSalePrice = GrLivAreaper100 | Neighborhood / cli solution;
run;

/* Addendum 7: Model for linear-log for removing outliers*/
proc glm data = logneighborhoodSScheapsmall plots = all;
class Neighborhood;
model SalePrice = logGrLivAreaper100 | Neighborhood / cli solution;
run;

/* Addendum 8: Model for log-log for removing outliers*/
proc glm data = logneighborhoodSScheapsmall plots = all;
class Neighborhood;
model logSalePrice = logGrLivAreaper100 | Neighborhood / cli solution;
run;