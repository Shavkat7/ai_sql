DECLARE @json NVARCHAR(MAX);

SELECT 
    identifier_name AS [identifiers.name],
    identifier_value AS [identifiers.value],
    (
        SELECT * 
        FROM YourTable AS t2
        WHERE t1.identifier_name = t2.identifier_name
        AND t1.identifier_value = t2.identifier_value
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    ) AS properties
FROM YourTable AS t1
GROUP BY identifier_name, identifier_value
FOR JSON AUTO;
