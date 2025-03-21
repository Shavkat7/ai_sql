WITH ItemAge AS (
    SELECT 
        ID,
        ChangeType,
        QuantityChange,
        DATEDIFF(DAY, MIN(Change_datetime) OVER (), Change_datetime) AS ItemAgeInDays
    FROM items
)
SELECT 
    CONCAT(GroupStart, '-', GroupEnd, ' days old') AS AgeGroup,
    SUM(CASE WHEN ItemAgeInDays BETWEEN GroupStart AND GroupEnd THEN QuantityChange ELSE 0 END) AS ItemCount
FROM (
    SELECT DISTINCT 
        (n-1)*90+1 AS GroupStart,
        n*90 AS GroupEnd
    FROM (SELECT TOP 10 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n FROM items) AS Numbers
) AS TimeGroups
CROSS JOIN ItemAge
WHERE ChangeType = 'in'
GROUP BY GroupStart, GroupEnd
ORDER BY GroupStart;
