USE PROJECT;
-- Opportunities with no recent activity (last 14 days) and which sales rep last contacted 
WITH last_touch AS (
    SELECT
        CustomerID,
        MAX(InteractionDate) AS LastInteractionDate
    FROM FACT_INTERACTION
    GROUP BY CustomerID
)
SELECT 
    o.OpportunityID, 
    o.Stage, 
    o.Amount, 
    o.CreatedDate, 
    s.SalesRepID, -- Added from DIM_SALES_REP
    lt.LastInteractionDate,
    -- Calculates days since contact or days since created if never contacted
    COALESCE(DATEDIFF(CURDATE(), lt.LastInteractionDate), DATEDIFF(CURDATE(), o.CreatedDate)) AS DaysSinceLastContact
FROM FACT_OPPORTUNITY o
LEFT JOIN last_touch lt ON o.CustomerID = lt.CustomerID
JOIN DIM_SALESREP s ON o.SalesRepID = s.SalesRepID -- Join to get the Rep's name
  AND (
       lt.LastInteractionDate IS NULL 
       OR DATEDIFF(CURDATE(), lt.LastInteractionDate) > 14
      )
ORDER BY o.Amount DESC;


-- Rolling 90-day revenue per customer
SELECT
    fo.CustomerID,
    fo.OrderDate,
    -- Wrap the whole window function in a ROUND
    ROUND(SUM(fo.NetAmount) OVER (
        PARTITION BY fo.CustomerID
        ORDER BY fo.OrderDate
        ROWS BETWEEN 89 PRECEDING AND CURRENT ROW
    ), 2) AS Rev_90d_Rolling
FROM FACT_ORDER fo;


-- win rate view
SELECT
  Stage,
  COUNT(*) AS TotalOpps,
  SUM(CASE WHEN IsWon = 1 THEN 1 ELSE 0 END) AS WonOpps
FROM FACT_OPPORTUNITY
GROUP BY Stage;

