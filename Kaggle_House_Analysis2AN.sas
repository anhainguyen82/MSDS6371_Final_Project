data train;
	infile '/folders/myfolders/sasuser.v94/masterAN.csv' dlm=',' firstobs=2;
	input Id MSSubClass MSZoning $ LotFrontage LotArea Street $ Alley $ LotShape $ LandContour $ 
		Utilities $ LotConfig $ LandSlope $ Neighborhood $ Condition1 $ Condition2 $ BldgType $ 
		HouseStyle $ OverallQual OverallCond YearBuilt YearRemodAdd RoofStyle $ RoofMatl $ 
		Exterior1st $ Exterior2nd $ MasVnrType $ MasVnrArea ExterQual $ ExterCond $ Foundation $ 
		BsmtQual $ BsmtCond $ BsmtExposure $ BsmtFinType1 $ BsmtFinSF1 BsmtFinType2 $ BsmtFinSF2 
		BsmtUnfSF TotalBsmtSF Heating $ HeatingQC $ CentralAir $ Electrical $ _1stFlrSF _2ndFlrSF 
		LowQualFinSF GrLivArea BsmtFullBath BsmtHalfBath FullBath HalfBath BedroomAbvGr KitchenAbvGr 
		KitchenQual $ TotRmsAbvGrd Functional $ Fireplaces FireplaceQu $ GarageType $ GarageYrBlt 
		GarageFinish $ GarageCars GarageArea GarageQual $ GarageCond $ PavedDrive $ WoodDeckSF 
		OpenPorchSF EnclosedPorch _3SsnPorch ScreenPorch PoolArea PoolQC $ Fence $ MiscFeature $ 
		MiscVal MoSold YrSold SaleType $ SaleCondition $ SalePrice;

/*Forward selection*/
proc glmselect data=train seed=1;
	class MSZoning Street Alley LotShape LandContour Utilities LotConfig LandSlope 
		Neighborhood Condition1 Condition2 BldgType HouseStyle RoofStyle RoofMatl 
		Exterior1st Exterior2nd MasVnrType ExterQual ExterCond Foundation BsmtQual 
		BsmtCond BsmtExposure BsmtFinType1 BsmtFinType2 Heating HeatingQC CentralAir 
		Electrical KitchenQual Functional FireplaceQu GarageType GarageFinish 
		GarageQual GarageCond PavedDrive Fence MiscFeature SaleType SaleCondition PoolQC;
	model SalePrice=MSSubClass--SaleCondition / selection=forward (choose=CV 
		stop=CV) cvmethod=split(10) CVdetails;
	output out=forward_results p=Predict;
run;

data forward_results2;
	set forward_results;

	if Predict > 0 then
		SalePrice=Predict;

	if Predict < 0 then
		SalePrice=10000;
	keep id SalePrice;
	where id > 1460;
run;

proc export data=forward_results2 
		outfile='/folders/myfolders/sasuser.v94/submitForward1.csv' dbms=csv replace;
run;

proc print data=forward_results2;
run;

/*Backward elimination*/
proc glmselect data=train seed=1;
	class MSZoning Street Alley LotShape LandContour Utilities LotConfig LandSlope 
		Neighborhood Condition1 Condition2 BldgType HouseStyle RoofStyle RoofMatl 
		Exterior1st Exterior2nd MasVnrType ExterQual ExterCond Foundation BsmtQual 
		BsmtCond BsmtExposure BsmtFinType1 BsmtFinType2 Heating HeatingQC CentralAir 
		Electrical KitchenQual Functional FireplaceQu GarageType GarageFinish 
		GarageQual GarageCond PavedDrive Fence MiscFeature SaleType SaleCondition PoolQC;
	model SalePrice=MSSubClass--SaleCondition / selection=backward(choose=CV 
		stop=CV) cvmethod=split(10) CVdetails;
	output out=backward_results p=Predict;
run;

data backward_results2;
	set backward_results;

	if Predict > 0 then
		SalePrice=Predict;

	if Predict < 0 then
		SalePrice=10000;
	keep id SalePrice;
	where id > 1460;
run;

proc export data=backward_results2 
		outfile='/folders/myfolders/sasuser.v94/submitBackward1.csv' dbms=csv replace;
run;

proc print data=backward_results2;
run;

/*Stepwise selection*/
proc glmselect data=train seed=1;
	class MSZoning Street Alley LotShape LandContour Utilities LotConfig LandSlope 
		Neighborhood Condition1 Condition2 BldgType HouseStyle RoofStyle RoofMatl 
		Exterior1st Exterior2nd MasVnrType ExterQual ExterCond Foundation BsmtQual 
		BsmtCond BsmtExposure BsmtFinType1 BsmtFinType2 Heating HeatingQC CentralAir 
		Electrical KitchenQual Functional FireplaceQu GarageType GarageFinish 
		GarageQual GarageCond PavedDrive Fence MiscFeature SaleType SaleCondition PoolQC;
	model SalePrice=MSSubClass--SaleCondition / selection=stepwise(choose=CV 
		stop=CV) cvmethod=split(10) CVdetails;
	output out=stepwise_results p=Predict;
run;

data stepwise_results2;
	set stepwise_results;

	if Predict > 0 then
		SalePrice=Predict;

	if Predict < 0 then
		SalePrice=10000;
	keep id SalePrice;
	where id > 1460;
run;

proc export data=stepwise_results2
		outfile='/folders/myfolders/sasuser.v94/submitStepwise1.csv' dbms=csv replace;
run;

proc print data=stepwise_results2;
run;


/*Custom model*/	
proc glmselect data=train2 plots=all;
	class KitchenQual GarageFinish BsmtQual ExterQual MasVnrType Neighborhood;
	model SalePrice=LotFrontage LotArea OverallQual OverallCond YearBuilt 
		BsmtFinSF1 TotalBsmtSF _1stFlrSF _2ndFlrSF GrLivArea FullBath TotRmsAbvGrd 
		GarageYrBlt GarageCars GarageArea WoodDeckSF OpenPorchSF KitchenQual 
		GarageFinish BsmtQual ExterQual MasVnrType Neighborhood / selection=none;
	output out=results p=Predict;
run;

data results3;
	set results;

	if Predict > 0 then
		SalePrice=Predict;

	if Predict < 0 then
		SalePrice=10000;
	keep id SalePrice;
	where id > 1460;
run;

proc export data=results3 outfile='/folders/myfolders/sasuser.v94/submitCustom2.csv' 
		dbms=csv replace;
run;

