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

proc print data = neighborhoodSS;
run;

/*Scatterplot the Saleprice to GrLivArea for the three requested neighborhoods*/
proc sgplot data=neighborhoodSS;
scatter x=GrLivArea y=SalePrice / group=Neighborhood; 
run;

/* Model for Salesprice to GrLivArea*/
proc glm data = neighborhoodSS plots=all;
class Neighborhood;
model SalePrice = GrLivArea | Neighborhood / cli solution;
run;

/* Log Transform the SalesPrice to re-run model */
data logneighborhoodSS;
	set neighborhoodSS;
	logSalePrice = log(SalePrice);
run;

/* Re-Run model with log transformed SalePrice*/
proc glm data = logneighborhoodSS plots=all;
class Neighborhood;
model logSalePrice = GrLivArea | Neighborhood / cli solution;
run;



