SELECT SUM(ABS(b-a)) as diff FROM (
    SELECT row_number() over (order by a) RowNum, a
    FROM locations
) AS a
INNER JOIN (
    SELECT row_number() over (order by b) RowNum, b
    FROM locations
) as b on a.RowNum = b.RowNum;