-- Q1
use project;
create table Salespeople(
  	snum int,
    	sname varchar(50),
    	city varchar(50),
    	comm float
);

insert into Salespeople values(1001,"Peel","London",0.12),
							  (1002,"Serres","San Jose",0.13),
							  (1003,"Axelrod","New york",0.10),
                              (1004,"Motika","London",0.11),
							  (1007,"Rafkin","Barcelona",0.15);

Select * from Salespeople;
-- Q2

create table Customer(
  	cnum int,
    	cname varchar(50),
    	city varchar(50),
	rating int,
    	snum int
);

insert into Customer values(2001,"Hoffman","London",100,1001),
(2002,"Govanne","Rome","200",1003),
(2003,"Liu","San Jose",300,1002),
(2004,"Grass","Berlin",100,1002),
(2006,"Clemens","London",300,1007),
(2007,"Pereira","Rome",100,1004),
(2008,"James","London",200,1007);

Select	* from Customer;
-- Q3


CREATE TABLE orders (
    onum INT,
    amt FLOAT,
    odate DATE,
    cnum INT,
    snum INT
);

insert into orders values(3001,18.69,"1994-10-03",2008,1007),
(3002,1900.10,"1994-10-03",2007,1004),
(3003,767.19,"1994-10-03",2001,1001),
(3005,5160.45,"1994-10-03",2003,1002),
(3006,1098.45,"1994-10-03",2008,1007),
(3007,75.75,"1994-10-03",2004,1002),
(3008,4723.45,"1994-10-03",2006,1001),
(3009,18.69,"1994-10-03",2002,1003),
(3010,18.69,"1994-10-03",2004,1002),
(3011,9891.88,"1994-10-06",2006,1001);

Select * from orders;
-- Q4

select *
from Salespeople as s
join Customer as c
where s.city=c.city;


-- Q5

select cname,sname
from Salespeople as s
join Customer as c
where s.snum=c.snum;

-- Q6

SELECT o.onum, o.amt, o.odate, c.cname, c.city AS customer_city, s.sname, s.city AS salesperson_city
FROM orders o
JOIN Customer c ON o.cnum = c.cnum
JOIN Salespeople s ON o.snum = s.snum
WHERE c.city <> s.city;

-- Q7

SELECT o.onum, c.cname
FROM Orders as o
JOIN Customer as c
ON o.cnum = c.cnum;

-- Q8

SELECT t1.cname,t2.cname
FROM Customer as t1
JOIN Customer as t2
ON t1.rating = t2.rating
where t1.cname <>t2.cname;

-- Q9

select c1.cname as customer1, c2.cname as customer2, s.sname as salesperson
from Customer c1
join Customer c2 on c1.snum = c2.snum and c1.cnum < c2.cnum
join Salespeople s on c1.snum = s.snum
order by s.sname, c1.cname, c2.cname;


-- Q10
SELECT DISTINCT s1.sname AS salesperson1, s2.sname AS salesperson2, s1.city
FROM Salespeople s1
JOIN Salespeople s2 
ON s1.city = s2.city and s1.sname<>s2.sname
WHERE s1.snum < s2.snum;


-- Q11
select o.onum,o.amt,o.odate,o.cnum,s.sname
from Orders as o
join Salespeople as s
on o.cnum=2008 and o.snum=s.snum;

-- Q12
    
with AvgOrderAmount as (
    select avg(amt) as avg_amt
    from orders
    where odate = STR_TO_DATE('1994-10-03', '%Y-%m-%d')
)
select *
from orders
where amt > (select avg_amt FROM AvgOrderAmount);


-- Q13

select o.*
from Orders as o
join Salespeople as s
on o.snum=s.snum
where s.city="London";

-- Q14

select *
from Customer
where cnum = (
    select snum + 1000
    from Salespeople
    where sname = 'Serres'
);


-- Q15

select count(*)
from Customer
where rating > (
    select avg(rating)
    from Customer
    where city = "San Jose"
);

select avg(rating)
    from Customer
    where city = "San Jose";


-- Q16


select s.snum, s.sname, s.city, COUNT(*) as num_customers
from Salespeople s
join Customer c on s.snum = c.snum
group by s.snum, s.sname, s.city
having count(*) > 1;


