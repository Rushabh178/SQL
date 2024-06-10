create database	project;
use project;
CREATE TABLE Dept (
    deptno INT PRIMARY KEY,
    dname VARCHAR(30),
    loc VARCHAR(30)
);

CREATE TABLE Employee (
    empno INT PRIMARY KEY,
    ename VARCHAR(20) NOT NULL,
    job VARCHAR(30) DEFAULT 'Clerk',
    mgr INT,
    hiredate DATE,
    sal DOUBLE CHECK (sal > 0),
    comm DOUBLE,
    deptno INT,
    FOREIGN KEY (deptno) REFERENCES Dept(deptno)
);

desc Employee;

INSERT INTO Dept (deptno, dname, loc) VALUES 
(10, 'OPERATIONS', 'BOSTON'),
(20, 'RESEARCH', 'DALLAS'),
(30, 'SALES', 'CHICAGO'),
(40, 'ACCOUNTING', 'NEW YORK');


INSERT INTO Employee (empno, ename, job, mgr, hiredate, sal, comm, deptno) VALUES 
(7369, 'SMITH', 'CLERK', 7902, '1890-12-17', 800.00, NULL, 20),
(7499, 'ALLEN', 'SALESMAN', 7698, '1981-02-20', 1600.00, 300.00, 30),
(7521, 'WARD', 'SALESMAN', 7698, '1981-02-22', 1250.00, 500.00, 30),
(7566, 'JONES', 'MANAGER', 7839, '1981-04-02', 2975.00, NULL, 20),
(7654, 'MARTIN', 'SALESMAN', 7698, '1981-09-28', 1250.00, 1400.00, 30),
(7698, 'BLAKE', 'MANAGER', NULL, '1981-05-01', 2850.00, NULL, 30),
(7782, 'CLARK', 'MANAGER', 7839, '1981-06-09', 2450.00, NULL, 10),
(7788, 'SCOTT', 'ANALYST', 7566, '1987-04-19', 3000.00, NULL, 20),
(7839, 'KING', 'PRESIDENT', NULL, '1981-11-17', 5000.00, NULL, 10),
(7844, 'TURNER', 'SALESMAN', 7698, '1981-09-08', 1500.00, 0.00, 30),
(7876, 'ADAMS', 'CLERK', 7788, '1987-05-23', 1100.00, NULL, 20),
(7900, 'JAMES', 'CLERK', 7698, '1981-12-03', 950.00, NULL, 30),
(7902, 'FORD', 'ANALYST', 7566, '1981-12-03', 3000.00, NULL, 20),
(7934, 'MILLER', 'CLERK', 7782, '1982-01-23', 1300.00, NULL, 10);

-- Q3) 
SELECT ename, sal
FROM Employee
WHERE sal > 1000;

-- Q4)
SELECT *
FROM Employee
WHERE hiredate < '1981-10-01';

-- Q5)
SELECT ename
FROM Employee
WHERE ename LIKE '_I%';

-- Q6)
SELECT 
    ename AS "Employee Name",
    sal AS "Salary",
    sal * 0.4 AS "Allowances",
    sal * 0.1 AS "P.F.",
    sal + (sal * 0.5) AS "Net Salary"
FROM 
    Employee;


-- Q7)
SELECT 
    ename AS "Employee Name",
    job AS "Designation"
FROM 
    Employee
WHERE 
    mgr IS NULL;

-- Q8)
SELECT 
    empno AS "Empno",
    ename AS "Ename",
    sal AS "Salary"
FROM 
    Employee
ORDER BY 
    sal ASC;

-- Q9)
SELECT 
    COUNT(DISTINCT job) AS "Number of Jobs"
FROM 
    Employee;

-- Q10)
SELECT 
    SUM(sal + IFNULL(comm, 0)) AS "Total Payable Salary"
FROM 
    Employee
WHERE 
    job = 'Salesman';

-- Q10)
SELECT 
    d.deptno AS "Department Number",
    d.dname AS "Department Name",
    e.job AS "Job Title",
    AVG(e.sal + IFNULL(e.comm, 0)) AS "Average Monthly Salary"
FROM 
    Employee e
INNER JOIN 
    Dept d ON e.deptno = d.deptno
GROUP BY 
    d.deptno, d.dname, e.job;


-- Q12)
SELECT 
    e.ename AS "EMPNAME",
    e.sal AS "SALARY",
    d.dname AS "DEPTNAME"
FROM 
    EMPLOYEE e
JOIN 
    DEPT d ON e.deptno = d.deptno;
    
-- Q13)

CREATE TABLE JobGrades (
    grade CHAR(1),
    lowest_sal INT,
    highest_sal INT
);

INSERT INTO JobGrades
VALUES
    ('A', 0, 999),
    ('B', 1000, 1999),
    ('C', 2000, 2999),
    ('D', 3000, 3999),
    ('E', 4000, 5000);
    
SELECT * FROM JobGrades;

-- Q14)

SELECT 
    e.ename, 
    e.sal, 
    j.grade AS CorrespondingGrade
FROM 
    Employee e
JOIN 
    JobGrades j ON e.sal BETWEEN j.lowest_sal AND j.highest_sal;

-- Q15)
SELECT 
    e.ename AS Emp,
    m.ename AS Manager
FROM 
    Employee e
JOIN 
    Employee m ON e.mgr = m.empno;

-- Q16)

SELECT 
    ename AS Empname, 
    (sal + COALESCE(comm, 0)) AS TotalSal
FROM 
    Employee;


-- Q17)

SELECT 
    ename AS Empname, 
    sal AS Salary
FROM 
    Employee
WHERE 
    empno % 2 = 1;
    
-- Q18)

SELECT 
    ename AS Empname, 
    RANK() OVER (ORDER BY sal DESC) AS OrgSalaryRank,
    RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) AS DeptSalaryRank
FROM 
    Employee;

-- Q19)

SELECT 
    Empname,
    TotalSal
FROM (
    SELECT 
        Empname,
        TotalSal,
        SalaryRank
    FROM (
        SELECT 
            ename AS Empname,
            (sal + COALESCE(comm, 0)) AS TotalSal,
            ROW_NUMBER() OVER (ORDER BY (sal + COALESCE(comm, 0)) DESC) AS SalaryRank
        FROM 
            Employee
    ) AS RankedEmployees
) AS FilteredResults
WHERE SalaryRank <= 3;

-- Q20)

WITH MaxDeptSalaries AS (
    SELECT 
        deptno,
        MAX(sal + COALESCE(comm, 0)) AS MaxSal
    FROM 
        Employee
    GROUP BY 
        deptno
)
SELECT 
    e.ename AS Empname,
    e.deptno
FROM 
    Employee e
JOIN 
    MaxDeptSalaries m ON e.deptno = m.deptno AND (e.sal + COALESCE(e.comm, 0)) = m.MaxSal;








