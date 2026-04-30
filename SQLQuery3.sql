SELECT * FROM retail_store_sales
where Transaction_Date is null

update retail_store_sales
set Item = 'DESCONOCIDO'
where Item is null

update retail_store_sales
set Price_Per_Unit = Total_Spent/Quantity
where Price_Per_Unit is null

delete from retail_store_sales
where Quantity is null

update retail_store_sales 
set Discount_Applied = N/A
where Discount_Applied is null

select Transaction_ID,
Customer_ID,
Category, case
when Item = 'DESCONOCIDO' THEN 'DESCONOCIDO'
else substring(Item, charindex('_',Item)+1,10)
end as Item_format,
Price_Per_Unit,
Quantity,
Total_Spent,
Payment_Method,
Location,
Transaction_Date, CASE
WHEN Discount_Applied is null then 'N/A'
else cast(Discount_Applied as Char) end Discount_Applied_cleaned
INTO SALES_CLEANED
from retail_store_sales

SELECT * FROM SALES_CLEANED
