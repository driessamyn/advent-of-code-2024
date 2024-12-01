# Day 1

Solving puzzle in SQL

## Start postgresql container

```shell
docker run --rm --name pg -e POSTGRES_PASSWORD=password -p 5432:5432 postgres
```

## load in test data

> Test data excluded from repo


## Solution

### Part 1

I decided to use SQL ¯\_(ツ)_/¯

```sql
SELECT SUM(ABS(b-a)) as diff FROM (
    SELECT row_number() over (order by a) RowNum, a
    FROM locations
) AS a
INNER JOIN (
    SELECT row_number() over (order by b) RowNum, b
    FROM locations
) as b on a.RowNum = b.RowNum;
```