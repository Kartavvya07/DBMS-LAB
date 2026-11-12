CREATE TABLE SUPPLIERS (
    SID INT PRIMARY KEY,
    SNAME VARCHAR(50),
    CITY VARCHAR(50)
);
CREATE TABLE PARTS (
    PID INT PRIMARY KEY,
    PNAME VARCHAR(50),
    COLOR VARCHAR(20)
);

CREATE TABLE CATALOG (
    SID INT,
    PID INT,
    COST INT,
    PRIMARY KEY (SID, PID),
    FOREIGN KEY (SID) REFERENCES SUPPLIERS(SID),
    FOREIGN KEY (PID) REFERENCES PARTS(PID)
);


INSERT INTO SUPPLIERS VALUES
(10001, 'Acme Widget', 'Bangalore'),
(10002, 'Johns', 'Kolkata'),
(10003, 'Vimal', 'Mumbai'),
(10004, 'Reliance', 'Delhi');

INSERT INTO PARTS VALUES
(20001, 'Book', 'Red'),
(20002, 'Pen', 'Red'),
(20003, 'Pencil', 'Green'),
(20004, 'Mobile', 'Green'),
(20005, 'Charger', 'Black');

INSERT INTO CATALOG VALUES
(10001, 20001, 10),
(10001, 20002, 10),
(10001, 20003, 30),
(10001, 20004, 10),
(10001, 20005, 10),
(10002, 20001, 10),
(10002, 20002, 20),
(10003, 20003, 30),
(10004, 20003, 40);


select pname from parts
where pid in (select pid from catalog);

select S.SNAME FROM SUPPLIERS S WHERE NOT EXISTS(
  SELECT P.PID FROM PARTS P WHERE P.PID NOT IN(
    SELECT C.PID FROM CATALOG C WHERE C.SID = S.SID
  )
);


SELECT SNAME FROM SUPPLIERS WHERE SID IN(
  SELECT SID FROM CATALOG WHERE PID IN (SELECT PID FROM PARTS WHERE COLOR = 'Red')
  GROUP BY SID HAVING COUNT(DISTINCT PID) = (SELECT COUNT(*) FROM PARTS WHERE COLOR = 'RED')
);


select pname, PID from parts
where pid in (
    select pid from catalog
    where sid = (select sid from suppliers where sname = 'Acme Widget')
)
and pid not in (
    select pid from catalog
    where sid IN (select sid from suppliers where sname = 'Acme Widget')
);

select distinct c1.sid from catalog c1
where c1.cost > (
    select avg(c2.cost) from catalog c2
    where c2.pid = c1.pid
);

select c.pid, s.sname from catalog c
join suppliers s on c.sid = s.sid
where c.cost = (
    select max(c2.cost) from catalog c2
    where c2.pid = c.pid
);

select sname,pname from suppliers,parts
where sid = (select sid from catalog where cost = ( select max(cost) from catalog ))
and
pid = (select pid from catalog where cost = ( select max(cost) from catalog ));


select sname from suppliers
where sid not in (select sid from catalog where pid in ( select pid from parts where color = 'Red'));


SELECT s.sname, SUM(c.cost)
FROM Suppliers s
JOIN Catalog c ON s.sid = c.sid
GROUP BY s.sname, s.sid;



select s.sid, s.sname from suppliers s
join catalog c on s.sid = c.sid
where c.cost < 20
group by s.sid, s.sname
having count(c.pid) >= 2;


select c.pid, p.pname, s.sname, c.cost from catalog c
join parts p on c.pid = p.pid
join suppliers s on c.sid = s.sid
where c.cost = (
    select min(c2.cost) from catalog c2
    where c2.pid = c.pid
);


create view most_expensive_supplier_per_part as
select c.pid, p.pname, s.sid, s.sname, c.cost from catalog c
join parts p on c.pid = p.pid
join suppliers s on c.sid = s.sid
where c.cost = (
    select max(c2.cost) from catalog c2
    where c2.pid = c.pid
);
