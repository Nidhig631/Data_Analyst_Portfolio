/*Cleaning Data in SQL Queries*/

select * from  Housing_data;

--Standardize Date Format
select SaleDate,convert(date,SaleDate) from  Housing_data;

Update Housing_data
set SaleDate=convert(date,SaleDate);

alter table Housing_data alter column Saledate date;

--Populate Property Address data
select *
from  Housing_data
order by ParcelID
--where PropertyAddress is null;

select b.propertyaddress,a.ParcelID,b.ParcelID,a.uniqueid,b.uniqueid,
isnull(a.propertyaddress,b.propertyaddress)
from  Housing_data a join Housing_data  b on 
a.ParcelID=b.ParcelID
and a.uniqueid<>b.uniqueid
where a.propertyaddress is null;

update a
set propertyaddress=isnull(a.propertyaddress,b.propertyaddress)
from  Housing_data a join Housing_data  b on 
a.ParcelID=b.ParcelID
and a.uniqueid<>b.uniqueid
where a.propertyaddress is null;

--Breaking out address into individual columns(address,city,state)

select propertyAddress
from  Housing_data;

select propertyaddress,
substring(propertyaddress,1,CHARINDEX(',',propertyaddress)-1) as address,
substring(propertyaddress,
CHARINDEX(',',propertyaddress)+1,
len(propertyaddress)) as city from  Housing_data;


alter table Housing_data add 
propertysplitaddress nvarchar(255);

update Housing_data set propertysplitaddress=
substring(propertyaddress,1,CHARINDEX(',',propertyaddress)-1);

alter table Housing_data add 
propertysplitcity nvarchar(255);

update Housing_data set propertysplitcity=
substring(propertyaddress,
CHARINDEX(',',propertyaddress)+1,
len(propertyaddress));

select * from Housing_data;

select owneraddress from Housing_data;

select owneraddress, 
parsename(replace(owneraddress,',','.'),3),
parsename(replace(owneraddress,',','.'),2),
parsename(replace(owneraddress,',','.'),1)
from Housing_data

alter table Housing_data add 
ownersplitaddress nvarchar(255);

update Housing_data
set 
ownersplitaddress=parsename(replace(owneraddress,',','.'),3);

alter table Housing_data add 
ownersplitcity nvarchar(255);

update Housing_data
set 
ownersplitcity=parsename(replace(owneraddress,',','.'),2);


alter table Housing_data add 
ownersplitstate nvarchar(255);

update Housing_data
set 
ownersplitstate=parsename(replace(owneraddress,',','.'),1);

select *
from  Housing_data

--change Y and N to yes and no in "sold as vacant" field

select distinct  soldasvacant,
case when soldasvacant='N' then 0
when soldasvacant='No' then 0
when soldasvacant='Yes' then 1
when soldasvacant='Y' then 1
end as soldasvacant
from housing_data

update housing_data
set soldasvacant=
case when soldasvacant='N' then 0
when soldasvacant='No' then 0
when soldasvacant='Yes' then 1
when soldasvacant='Y' then 1
end ;

select * from housing_data;

--Remove duplicate
with rownumcte as(
select *,
row_number() over(partition by Parcelid,propertyaddress,saleprice,
legalreference order by uniqueid ) as row_num
from housing_data
)
delete from rownumcte where row_num>1


alter table 
housing_data
drop column owneraddress,taxdistrict,
propertyaddress;