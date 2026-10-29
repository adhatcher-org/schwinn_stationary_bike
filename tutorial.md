# SQL Join Types Tutorial

This tutorial demonstrates the differences between INNER JOIN, LEFT JOIN, RIGHT JOIN, and OUTER JOIN using two sample tables.

## Sample Tables

### Table A
| ID | Name     | Department |
|----|----------|------------|
| 1  | Alice    | HR         |
| 2  | Bob      | IT         |
| 3  | Charlie  | Finance    |
| 4  | David    | IT         |
| 5  | Eve      | HR         |
| 6  | Frank    | Marketing  |
| 7  | Grace    | Sales      |
| 8  | Henry    | Finance    |
| 9  | Irene    | Marketing  |
| 10 | Jack     | Sales      |

### Table B
| ID | Name     | Project |
|----|----------|---------|
| 1  | Alice    | Project A |
| 2  | Bob      | Project B |
| 3  | Charlie  | Project C |
| 4  | David    | Project D |
| 5  | Eve      | Project E |
| 6  | Kevin    | Project F |
| 7  | Laura    | Project G |
| 8  | Michael  | Project H |
| 9  | Nancy    | Project I |
| 10 | Olivia   | Project J |

## Join Results

### INNER JOIN
Returns only rows that exist in both tables based on the join condition.

```sql
SELECT *
FROM TableA A
INNER JOIN TableB B ON A.ID = B.ID;
```

| A.ID | A.Name   | A.Department | B.ID | B.Name   | B.Project |
|------|----------|--------------|------|----------|-----------|
| 1    | Alice    | HR           | 1    | Alice    | Project A |
| 2    | Bob      | IT           | 2    | Bob      | Project B |
| 3    | Charlie  | Finance      | 3    | Charlie  | Project C |
| 4    | David    | IT           | 4    | David    | Project D |
| 5    | Eve      | HR           | 5    | Eve      | Project E |

### LEFT JOIN
Returns all rows from the left table and matching rows from the right table.

```sql
SELECT *
FROM TableA A
LEFT JOIN TableB B ON A.ID = B.ID;
```

| A.ID | A.Name   | A.Department | B.ID | B.Name   | B.Project |
|------|----------|--------------|------|----------|-----------|
| 1    | Alice    | HR           | 1    | Alice    | Project A |
| 2    | Bob      | IT           | 2    | Bob      | Project B |
| 3    | Charlie  | Finance      | 3    | Charlie  | Project C |
| 4    | David    | IT           | 4    | David    | Project D |
| 5    | Eve      | HR           | 5    | Eve      | Project E |
| 6    | Frank    | Marketing    | NULL | NULL     | NULL      |
| 7    | Grace    | Sales        | NULL | NULL     | NULL      |
| 8    | Henry    | Finance      | NULL | NULL     | NULL      |
| 9    | Irene    | Marketing    | NULL | NULL     | NULL      |
| 10   | Jack     | Sales        | NULL | NULL     | NULL      |

### RIGHT JOIN
Returns all rows from the right table and matching rows from the left table.

```sql
SELECT *
FROM TableA A
RIGHT JOIN TableB B ON A.ID = B.ID;
```

| A.ID | A.Name   | A.Department | B.ID | B.Name   | B.Project |
|------|----------|--------------|------|----------|-----------|
| 1    | Alice    | HR           | 1    | Alice    | Project A |
| 2    | Bob      | IT           | 2    | Bob      | Project B |
| 3    | Charlie  | Finance      | 3    | Charlie  | Project C |
| 4    | David    | IT           | 4    | David    | Project D |
| 5    | Eve      | HR           | 5    | Eve      | Project E |
| NULL | NULL     | NULL         | 6    | Kevin    | Project F |
| NULL | NULL     | NULL         | 7    | Laura    | Project G |
| NULL | NULL     | NULL         | 8    | Michael  | Project H |
| NULL | NULL     | NULL         | 9    | Nancy    | Project I |
| NULL | NULL     | NULL         | 10   | Olivia   | Project J |

### FULL OUTER JOIN
Returns all rows from both tables, with matching rows combined.

```sql
SELECT *
FROM TableA A
FULL OUTER JOIN TableB B ON A.ID = B.ID;
```

| A.ID | A.Name   | A.Department | B.ID | B.Name   | B.Project |
|------|----------|--------------|------|----------|-----------|
| 1    | Alice    | HR           | 1    | Alice    | Project A |
| 2    | Bob      | IT           | 2    | Bob      | Project B |
| 3    | Charlie  | Finance      | 3    | Charlie  | Project C |
| 4    | David    | IT           | 4    | David    | Project D |
| 5    | Eve      | HR           | 5    | Eve      | Project E |
| 6    | Frank    | Marketing    | NULL | NULL     | NULL      |
| 7    | Grace    | Sales        | NULL | NULL     | NULL      |
| 8    | Henry    | Finance      | NULL | NULL     | NULL      |
| 9    | Irene    | Marketing    | NULL | NULL     | NULL      |
| 10   | Jack     | Sales        | NULL | NULL     | NULL      |
| NULL | NULL     | NULL         | 6    | Kevin    | Project F |
| NULL | NULL     | NULL         | 7    | Laura    | Project G |
| NULL | NULL     | NULL         | 8    | Michael  | Project H |
| NULL | NULL     | NULL         | 9    | Nancy    | Project I |
| NULL | NULL     | NULL         | 10   | Olivia   | Project J |

## Summary

- **INNER JOIN**: Returns only matching records from both tables
- **LEFT JOIN**: Returns all records from the left table and matching records from the right table
- **RIGHT JOIN**: Returns all records from the right table and matching records from the left table
- **FULL OUTER JOIN**: Returns all records from both tables, with matching records combined

The join types can be visualized using Venn diagrams where:
- INNER JOIN is the intersection of two circles
- LEFT JOIN includes the left circle and its intersection with the right circle
- RIGHT JOIN includes the right circle and its intersection with the left circle
- FULL OUTER JOIN includes both circles and their intersection