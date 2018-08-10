FILENAME REFFILE '/folders/myfolders/sasuser.v94/masterAN.csv';

PROC IMPORT DATAFILE=REFFILE REPLACE
	DBMS=CSV
	OUT=train;
	GETNAMES=YES;
RUN;

proc glmselect data = train;
class MSZoning Street Alley LotShape LandContour Utilities LotConfig LandSlope Neighborhood 
Condition1 Condition2 BldgType HouseStyle RoofStyle RoofMatl Exterior1st Exterior2nd MasVnrType 
ExterQual ExterCond Foundation BsmtQual BsmtCond BsmtExposure BsmtFinType1 BsmtFinType2 Heating 
HeatingQC CentralAir Electrical KitchenQual Functional FireplaceQu GarageType GarageFinish 
GarageQual GarageCond PavedDrive Fence MiscFeature SaleType SaleCondition;
model SalePrice = MSSubClass--SaleCondition / selection = forward;
run;

proc glmselect data = train;
class MSZoning Street Alley LotShape LandContour Utilities LotConfig LandSlope Neighborhood 
Condition1 Condition2 BldgType HouseStyle RoofStyle RoofMatl Exterior1st Exterior2nd MasVnrType 
ExterQual ExterCond Foundation BsmtQual BsmtCond BsmtExposure BsmtFinType1 BsmtFinType2 Heating 
HeatingQC CentralAir Electrical KitchenQual Functional FireplaceQu GarageType GarageFinish 
GarageQual GarageCond PavedDrive Fence MiscFeature SaleType SaleCondition;
model SalePrice = MSSubClass--SaleCondition / selection = backward;
run;

proc glmselect data = train;
class MSZoning Street Alley LotShape LandContour Utilities LotConfig LandSlope Neighborhood 
Condition1 Condition2 BldgType HouseStyle RoofStyle RoofMatl Exterior1st Exterior2nd MasVnrType 
ExterQual ExterCond Foundation BsmtQual BsmtCond BsmtExposure BsmtFinType1 BsmtFinType2 Heating 
HeatingQC CentralAir Electrical KitchenQual Functional FireplaceQu GarageType GarageFinish 
GarageQual GarageCond PavedDrive Fence MiscFeature SaleType SaleCondition;
model SalePrice = MSSubClass--SaleCondition / selection = stepwise;
run;


proc glm data = train plots=all;      
class KitchenQual GarageFinish BsmtQual ExterQual MasVnrType Neighborhood;                                                                                                                   
model SalePrice = LotFrontage LotArea OverallQual OverallCond YearBuilt BsmtFinSF1 
TotalBsmtSF X1stFlrSF X2ndFlrSF GrLivArea FullBath TotRmsAbvGrd GarageYrBlt GarageCars 
GarageArea WoodDeckSF OpenPorchSF KitchenQual GarageFinish BsmtQual ExterQual MasVnrType 
Neighborhood/ cli solution;
output out = results p = Predict;
run;

data results2;
set results;
if Predict > 0 then SalePrice = Predict;
if Predict < 0 then SalePrice = 10000;
keep id SalePrice;
where id > 1460;
run;

proc export data=results2
   outfile='/folders/myfolders/sasuser.v94/submit.csv'
   dbms=csv
   replace;
run;

proc print data = results2; run;