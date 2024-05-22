--Cleaning Data in SQL Queries

SELECT *
FROM PortfolioProject2Cleaning..NashvilleHousing

--Standardize date format 

SELECT SaleDate
FROM PortfolioProject2Cleaning..NashvilleHousing

SELECT SaleDateConverted, CONVERT(date, SaleDate)
FROM PortfolioProject2Cleaning..NashvilleHousing

UPDATE PortfolioProject2Cleaning..NashvilleHousing
SET SaleDate=CONVERT(date, SaleDate)
--option 2

ALTER TABLE PortfolioProject2Cleaning..NashvilleHousing
ADD SaleDateConverted DATE;

UPDATE PortfolioProject2Cleaning..NashvilleHousing
SET SaleDateConverted =  CONVERT(date, SaleDate)

SELECT *
FROM PortfolioProject2Cleaning..NashvilleHousing
-----------------------------------------------------------------------------------------------------
--Populate Property Address data
--Check for NULL values

SELECT PropertyAddress
FROM PortfolioProject2Cleaning..NashvilleHousing
WHERE PropertyAddress is NULL

--Populating based on ParcelID

SELECT *
FROM PortfolioProject2Cleaning..NashvilleHousing
ORDER BY ParcelID

SELECT Nash.ParcelID, Nash.PropertyAddress, House.ParcelID,House.PropertyAddress, ISNULL(Nash.PropertyAddress,House.PropertyAddress)
FROM PortfolioProject2Cleaning..NashvilleHousing AS Nash
JOIN PortfolioProject2Cleaning..NashvilleHousing AS House
ON Nash.ParcelID=House.ParcelID
AND Nash.[UniqueID ]<>House.[UniqueID ]
WHERE Nash.PropertyAddress is  Null 

UPDATE Nash
SET PropertyAddress=
ISNULL(Nash.PropertyAddress,House.PropertyAddress)
FROM PortfolioProject2Cleaning..NashvilleHousing AS Nash
JOIN PortfolioProject2Cleaning..NashvilleHousing AS House
ON Nash.ParcelID=House.ParcelID
AND Nash.[UniqueID ]<>House.[UniqueID ]
WHERE Nash.PropertyAddress is  Null 

--check 
SELECT Nash.ParcelID, Nash.PropertyAddress, House.ParcelID,House.PropertyAddress, ISNULL(Nash.PropertyAddress,House.PropertyAddress)
FROM PortfolioProject2Cleaning..NashvilleHousing AS Nash
JOIN PortfolioProject2Cleaning..NashvilleHousing AS House
ON Nash.ParcelID=House.ParcelID
AND Nash.[UniqueID ]<>House.[UniqueID ]
--WHERE Nash.PropertyAddress is  Null 

------------------------------------------------------------------------------------
--Breaking down address into Individual Columns (address, city, state)

SELECT PropertyAddress
FROM PortfolioProject2Cleaning..NashvilleHousing

SELECT 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address
FROM PortfolioProject2Cleaning..NashvilleHousing

SELECT 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address
FROM PortfolioProject2Cleaning..NashvilleHousing

ALTER TABLE PortfolioProject2Cleaning..NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255);

UPDATE PortfolioProject2Cleaning..NashvilleHousing
SET PropertySplitAddress= SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE PortfolioProject2Cleaning..NashvilleHousing
ADD PropertySplitCity NVARCHAR(255);

UPDATE PortfolioProject2Cleaning..NashvilleHousing
SET PropertySplitCity=  SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))


SELECT *
FROM PortfolioProject2Cleaning..NashvilleHousing

--working with Owner Address column, splitting the address 

SELECT OwnerAddress
FROM PortfolioProject2Cleaning..NashvilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM PortfolioProject2Cleaning..NashvilleHousing


ALTER TABLE PortfolioProject2Cleaning..NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255);

UPDATE PortfolioProject2Cleaning..NashvilleHousing
SET OwnerSplitAddress= PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE PortfolioProject2Cleaning..NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255);

UPDATE PortfolioProject2Cleaning..NashvilleHousing
SET OwnerSplitCity=  PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE PortfolioProject2Cleaning..NashvilleHousing
ADD OwnerSplitState NVARCHAR(255);

UPDATE PortfolioProject2Cleaning..NashvilleHousing
SET OwnerSplitState= PARSENAME(REPLACE(OwnerAddress,',','.'),1)

SELECT *
FROM PortfolioProject2Cleaning..NashvilleHousing
----------------------------------------------------------------------------------------------
--Change Y and N to Yes and No in "Sold as Vacant" field


SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject2Cleaning..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant
,CASE WHEN SoldAsVacant='Y' THEN 'Yes'
      WHEN SoldAsVacant='N' THEN 'No'
	  ELSE SoldAsVacant
	  END
FROM PortfolioProject2Cleaning..NashvilleHousing

UPDATE PortfolioProject2Cleaning..NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant='Y' THEN 'Yes'
      WHEN SoldAsVacant='N' THEN 'No'
	  ELSE SoldAsVacant
	  END

-------------------------------------------------------------------------------------------
--Remove Duplicates

WITH RowNumCTE AS (
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY ParcelID,
             PropertyAddress,
			 SalePrice,
			 Saledate,
			 LegalReference
			 ORDER BY UniqueID) AS row_nummber
FROM PortfolioProject2Cleaning..NashvilleHousing
--ORDER BY ParcelID
)
SELECT *
FROM RowNumCTE
WHERE row_nummber >1

--deleting

WITH RowNumCTE AS (
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY ParcelID,
             PropertyAddress,
			 SalePrice,
			 Saledate,
			 LegalReference
			 ORDER BY UniqueID) AS row_nummber
FROM PortfolioProject2Cleaning..NashvilleHousing
--ORDER BY ParcelID
)
DELETE
FROM RowNumCTE
WHERE row_nummber >1

--Checking :


WITH RowNumCTE AS (
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY ParcelID,
             PropertyAddress,
			 SalePrice,
			 Saledate,
			 LegalReference
			 ORDER BY UniqueID) AS row_nummber
FROM PortfolioProject2Cleaning..NashvilleHousing
--ORDER BY ParcelID
)
SELECT *
FROM RowNumCTE
WHERE row_nummber >1

---------------------------------------------------------------------------------------
--Delete unused columns 

SELECT *
FROM PortfolioProject2Cleaning..NashvilleHousing

ALTER TABLE PortfolioProject2Cleaning..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, SaleDate, PropertyAddress