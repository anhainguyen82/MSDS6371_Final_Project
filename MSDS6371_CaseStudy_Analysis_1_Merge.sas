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

/* Merges the train and test datasets*/
data train2;
	set train test;
run;

/*Filter only relevant Neighborhoods for Q1.  NAmes, Edwards, BrkSide*/
data neighborhoodSS2;
	set train2;
	where Neighborhood = 'NAmes'or Neighborhood = 'Edwards' or Neighborhood='BrkSide';
run;

/* Create GrLivAreaper100 variable, log Transform the SalesPrice and GrLivAreaper100 to re-run model */
data logneighborhoodSS2;
	set neighborhoodSS2;
	GrLivAreaper100 = GrLivArea/100;
	logSalePrice = log(SalePrice);
	logGrLivAreaper100 = log(GrLivArea/100);
run;

/*Filter out all homes greater than 40 100 sq.ft.*/
data logneighborhoodSSsmall2;
	set logneighborhoodSS2;
	where GrLivAreaper100 <= 40;
run;

/*Filter out all homes that costs more than $300,000*/
data logneighborhoodSScheap2;
	set logneighborhoodSS2;
	where SalePrice <= 300000;
run;

/*Filter out all homes that costs more than $300,000 and smaller than 40 100 sq. ft.*/
data logneighborhoodSScheapsmall2;
	set logneighborhoodSS2;
	where SalePrice <= 300000 and GrLivAreaper100 <= 40;
run;

/************************************************************/

/*Descriptive Statistics - Means for the three neighborhoods*/
proc means data=neighborhoodSS2;
*class Neighborhood;
run;

/*Scatterplot the Saleprice to GrLivArea for the three requested neighborhoods*/
proc sgplot data=neighborhoodSS2;
scatter x=GrLivArea y=SalePrice / group=Neighborhood; 
run;

/* Addendum 1:Model for Salesprice to GrLivArea*/
proc glm data = neighborhoodSS2 plots=all;
class Neighborhood;
model SalePrice = GrLivArea | Neighborhood / cli solution;
run;

/* Addendum 2: Model with log transformed SalePrice*/
proc glm data = logneighborhoodSS2 plots=all;
class Neighborhood;
model logSalePrice = GrLivAreaper100 | Neighborhood / cli solution;
run;

/* Addendum 3: Model with log transformed GrLiveArea100*/
proc glm data = logneighborhoodSS2 plots=all;
class Neighborhood;
model SalePrice = logGrLivAreaper100 | Neighborhood / cli solution;
run;

/* Addendum 4: Model with log transformed GrLivArea100*/
proc glm data = logneighborhoodSS2 plots=all;
class Neighborhood;
model logSalePrice = logGrLivAreaper100 | Neighborhood / cli solution;
run;

/* Addendum 5: Model for Salesprice to GrLivArea100 with subset cheap and small*/ 
proc glm data = logneighborhoodSScheapsmall2 plots=all;
class Neighborhood;
model SalePrice = GrLivAreaper100 | Neighborhood / cli solution;
run;

/* Addendum 6: Model for log-linear for removing outliers*/
proc glm data = logneighborhoodSScheapsmall2 plots = all;
class Neighborhood;
model logSalePrice = GrLivAreaper100 | Neighborhood / cli solution;
run;

/* Addendum 7: Model for linear-log for removing outliers*/
proc glm data = logneighborhoodSScheapsmall2 plots = all;
class Neighborhood;
model SalePrice = logGrLivAreaper100 | Neighborhood / cli solution;
run;

/* Addendum 8: Model for log-log for removing outliers*/
proc glm data = logneighborhoodSScheapsmall2 plots = all;
class Neighborhood;
model logSalePrice = logGrLivAreaper100 | Neighborhood / cli solution;
run;
