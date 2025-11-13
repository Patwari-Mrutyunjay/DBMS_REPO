create database Supplier1;
Use Supplier1;

create table Supplier(
	sid int primary key,
    sname varchar(15),
    city varchar(12)
    );
    
create table parts (
	pid int primary key,
    pname varchar(20),
    color  varchar (10)
    );
    
create table Catalog(
	sid int ,
    pid int, 
    cost int ,
    Primary key(sid, pid),
    Foreign key (sid ) references Supplier (sid),
    Foreign key (pid) references Parts (pid) );
    
insert into Supplier 
Values 
(10001, 'Acme Widget' , 'Bangalore' ),
(10002, 'Johns' , 'Kolkata' ),
(10003, 'Vimal' , 'Mumbai' ),
(10004, 'Reliance' , 'Delhi' );

Insert Into Parts (pid, pname, color)
Values
(20001, 'Book', 'Red'),
(20002, 'Pen', 'Red'),
(20003, 'Pencil', 'Green'),
(20004, 'Mobile', 'Green'),
(20005, 'Charger', 'Black');

Insert Into Catalog (sid, pid, cost)
Values
(10001, 20001, 10),
(10001, 20002, 10),
(10001, 20003, 30),
(10001, 20004, 10),
(10001, 20005, 10),
(10002, 20001, 10),
(10002, 20002, 20),
(10003, 20003, 30),
(10004, 20003, 40);


-- QUERY 1: Find the pnames of parts for which there is some supplier

SELECT DISTINCT P.pname
FROM Parts P
JOIN Catalog C ON P.pid = C.pid;

SELECT s.sname
FROM Supplier s
JOIN Catalog c ON s.sid = c.sid
GROUP BY s.sname
HAVING COUNT(DISTINCT c.pid) = (SELECT COUNT(*) FROM Parts);

SELECT s.sname
FROM Supplier s
WHERE NOT EXISTS (
  SELECT * FROM Parts
  WHERE color='Red'
  AND pid NOT IN (SELECT pid FROM Catalog WHERE sid=s.sid)
);

SELECT P.pname
FROM Parts P
JOIN Catalog C ON P.pid = C.pid
where c.sid=10001
and p.pid not in (
	select pid 
    from catalog 
    where sid!= 10001);

SELECT DISTINCT C1.sid
FROM Catalog C1
JOIN (
    SELECT pid, AVG(cost) AS avg_cost
    FROM Catalog
    GROUP BY pid
) A ON C1.pid = A.pid
WHERE C1.cost > A.avg_cost;

SELECT p.pname, s.sname, c.cost
FROM Catalog c
JOIN Supplier s ON s.sid=c.sid
JOIN Parts p ON p.pid=c.pid
WHERE c.cost IN (
  SELECT MAX(cost) FROM Catalog c2 WHERE c2.pid=c.pid
);


