Create database Nova;

Use Nova;

SELECT * FROM nova.`clean branch`;
SELECT * FROM nova.`clean customer`;
SELECT * FROM nova.`clean product`;
SELECT * FROM nova.`clean transaction`;

-------------------------- BUSINESS QUESTION -----------------------------------------------

----- 1.	Which branch generates the highest revenue, and how does branch performance compare across the bank?

Select nova.`clean branch`.BranchID, nova.`clean branch`.BranchName, sum(TransactionAmount_NGN) as Total_Revenue
from nova.`clean branch`
inner join nova.`clean transaction`
on nova.`clean branch`.BranchID = nova.`clean transaction`.BranchID
Group by  nova.`clean branch`.BranchID, nova.`clean branch`.BranchName
Order by Total_Revenue Desc;

----- 2.	Which customer segment contributes the most revenue, and which segments contribute the least?

Select  nova.`clean customer`.CustomerID,  nova.`clean customer`.CustomerSegment, sum(TransactionAmount_NGN) as Total_Revenue
from  nova.`clean customer`
Inner Join nova.`clean transaction`
on  nova.`clean customer`.CustomerID = nova.`clean transaction`.CustomerID
Group by  nova.`clean customer`.CustomerID,  nova.`clean customer`.CustomerSegment
Order by Total_Revenue Desc;

----- 3.	Which banking product records the highest transaction volume?
Select  nova.`clean product`.ProductID,  nova.`clean product`.ProductName, sum(TransactionAmount_NGN) as Total_Revenue
from nova.`clean product`
Inner Join nova.`clean transaction`
on  nova.`clean product`.ProductID = nova.`clean transaction`.ProductID
Group by  nova.`clean product`.ProductID,  nova.`clean product`.ProductName
Order by Total_Revenue desc
Limit 1;

----- 4.	Is monthly revenue growing, stable, or declining over time?

Select `Month`, sum(TransactionAmount_NGN) as Total_Revenue, round(avg(TransactionAmount_NGN),0) as Total_Revenue_Avg
FROM nova.`clean transaction`
Group by  `Month`
Order by Total_Revenue desc;

----- 5.	How do fee waivers affect profitability
Select 
	FeeWaived, count(TransactionID) as Total_Transaction, sum(TransactionAmount_NGN) as Total_Revenue, sum(FeeCharged_NGN) as Total_Fees
    FROM nova.`clean transaction`
    Group by FeeWaived
	Order by Total_Revenue Desc;
    
    
    ----------- KPI VERIFICATIONS ----------------------
    ----- 1.  Total Customer 
    Select count(*) from  nova.`clean customer`;
    
    ----- 2.  Total Revenue
    Select sum(TransactionAmount_NGN) as Total_Revenue FROM nova.`clean transaction`;
    
    ----- 3. Transaction Success Rate
    Select 
    round(sum(case when TransactionStatus = 'Successful' then 1 else 0 end) * 100/ count(*), 2) as Transaction_Success_rate
	FROM nova.`clean transaction`;
    
    ----- 3b. Per Transaction Status Rate
    Select 
    TransactionStatus, count(*) as Total_Count, 
     Round(count(*) * 100 / (select count(*) from nova.`clean transaction`),2) as Pecentage
     From nova.`clean transaction`
     Group by TransactionStatus
     Order by  Pecentage Desc;
     
    ----- 4. Average Customer Satisfaction 
Select round(avg(CustomerSatisfactionScore), 2) as Avg_Customer_Satisfaction_Score
	From nova.`clean transaction`;

    
    
    
    
    
    
    
