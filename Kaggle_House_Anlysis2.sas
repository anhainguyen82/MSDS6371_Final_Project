FILENAME REFFILE '/folders/myfolders/sasuser.v94/test.csv';

PROC IMPORT DATAFILE=REFFILE REPLACE
	DBMS=CSV
	OUT=test;
	GETNAMES=YES;
RUN;

FILENAME REFFILE '/folders/myfolders/sasuser.v94/trainCleanWithZero.csv';

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


proc glm data = train;      
class KitchenQual GarageFinish BsmtQual ExterQual MasVnrType Neighborhood;                                                                                                                   
model SalePrice = LotFrontage LotArea OverallQual OverallCond YearBuilt BsmtFinSF1 
TotalBsmtSF _1stFlrSF _2ndFlrSF GrLivArea FullBath TotRmsAbvGrd GarageYrBlt GarageCars 
GarageArea WoodDeckSF OpenPorchSF KitchenQual GarageFinish BsmtQual ExterQual MasVnrType 
Neighborhood/ solution;
run;