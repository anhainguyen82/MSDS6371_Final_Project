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

%*Custom model, use for obtaining Cook's D, Leverate, and Studentized residuals;
proc glm data=train plots=all;
	class KitchenQual GarageFinish BsmtQual ExterQual MasVnrType Neighborhood;
	model SalePrice=LotFrontage LotArea OverallQual OverallCond YearBuilt 
		BsmtFinSF1 TotalBsmtSF _1stFlrSF _2ndFlrSF GrLivArea FullBath TotRmsAbvGrd 
		GarageYrBlt GarageCars GarageArea WoodDeckSF OpenPorchSF KitchenQual 
		GarageFinish BsmtQual ExterQual MasVnrType Neighborhood / solution;
	output out=results student=res cookd = cookd h = lev;
run;

%*Display individuals with high Cook's D, large absolute studentized residuals or high leverage;
data results2;
	set results;
	where id <= 1460 and (cookd > 1 or res > 10 or res < -10 or lev > 1);
run;

proc print data = results2;
run;



