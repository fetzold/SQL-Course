--Aufgabe 1.1
SELECT lastname, firstnme, 
	CASE WHEN sex = 'M' THEN 'maennl' 
		ELSE 'weibl' END Geschlecht, birthdate 
FROM employee 
ORDER BY lastname, firstnme;


--Aufgabe 1.2
SELECT DISTINCT job
FROM employee
ORDER BY job;


--Aufgabe 1.3
SELECT e.lastname, e.firstnme 
FROM employee e, department d 
WHERE e.workdept = d.deptno AND d.deptname = 'ADMINISTRATION SYSTEMS' 
ORDER BY e.lastname;


--Aufgabe 1.4
SELECT d.deptname AS Department, e.lastname AS Manager 
FROM department d 
LEFT OUTER JOIN employee e 
ON d.mgrno = e.empno 
ORDER BY admrdept;


--Aufgabe 1.5
SELECT COUNT(*) 
FROM department d, project p 
WHERE d.deptno = p.deptno AND d.deptname = 'DEVELOPMENT CENTER';


--Aufgabe 1.6
SELECT COUNT(*) AS NoEmployeeOp, SUM(e.Salary) AS TotalIncOp, AVG(e.Salary) AS AverageIncOp 
FROM Employee e, department d 
WHERE e.workdept = d.deptno AND d.deptname ='OPERATIONS';


--Aufgabe 1.7
SELECT e1.lastname, e1.firstnme, Count(e1.empno) AS NumberProj 
FROM employee e1, EMP_ACT e2 
WHERE e1.empno = e2.empno 
GROUP BY e1.lastname, e1.firstnme 
HAVING COUNT(e1.empno) > 2 
ORDER BY NumberProj DESC;


--Aufgabe 1.8
SELECT e1.lastname AS LastEmpl, e1.firstnme AS FirstEmpl, e1.bonus AS BonEmpl, e2.lastname AS LastMana, e2.firstnme AS FirstMana, e2.bonus AS BonMana 
FROM employee e1, employee e2, department d 
WHERE e2.empno = d.mgrno AND e1.workdept = d.deptno AND e1.bonus > e2.bonus;


--Aufgabe 2.1
SELECT p_name, p_type, 
	CASE WHEN p_type like '%COPPER%' THEN 'YES' 
		 ELSE 'NO' END 
FROM part;


--Aufgabe 2.2
SELECT p.p_name, 
	CASE WHEN SUM(li.l_quantity) IS NULL THEN 0 
		 ELSE SUM(li.l_quantity) END AS Numb 
FROM part p 
LEFT OUTER JOIN lineitem li 
ON p.p_partkey = li.l_partkey 
GROUP BY p.p_name, p.p_partkey 
ORDER BY Numb DESC, p.p_name;
-- Falls man kein Outer Join verwendet werden alle Teile die nicht bestellt worden sind entfernt


--Aufgabe 2.3 
SELECT * 
FROM (SELECT s.s_name 
	  FROM supplier s, nation n, region r 
	  WHERE s.s_nationkey = n.n_nationkey AND n.n_regionkey = r.r_regionkey AND r.r_name ='AFRICA' 
	  UNION SELECT c.c_name 
			FROM customer c , nation n, region r 
			WHERE c.c_nationkey = n.n_nationkey AND n.n_regionkey = r.r_regionkey AND r.r_name ='AFRICA') 
ORDER BY s_name;


--Aufgabe 2.4
SELECT COUNT(DISTINCT l.l_partkey) 
FROM supplier s, lineitem l, nation n1, nation n2, customer c, orders o 
WHERE l.l_suppkey = s.s_suppkey AND s.s_nationkey = n1.n_nationkey AND n1.n_name = 'RUSSIA' AND l.l_orderkey = o.o_orderkey AND o.o_custkey = c.c_custkey AND c.c_nationkey = n2.n_nationkey AND n2.n_name = 'MOROCCO' AND c.c_acctbal <= 1000;


--Aufgabe 2.5
SELECT p.p_name, p.p_size 
FROM part p ORDER BY p.p_size 
DESC fetch first 6 rows only;


--Aufgabe 3

--Type
CREATE DISTINCT TYPE T_EUR AS DECIMAL(6,2) WITH COMPARISONS;
CREATE DISTINCT TYPE T_USD AS DECIMAL(6,2) WITH COMPARISONS;

--CreateTable
CREATE TABLE COLLECTION(
ITEM VARCHAR(20),
PRICE T_EUR
);

--InsertTable
INSERT INTO COLLECTION VALUES ('NIKON COOPLIX S9',158.00),('ACER TravelMate 2428',648.00),('SAMSUNG R40-T2300',1020.00),('CANON CanoScan 4200',78.60),('BROTHER HL 2030',113.50);

--Query
SELECT item, T_USD(DECIMAL(price) * 1.3) AS T_USD 
FROM collection;


--Aufgabe 4.1
CONNECT TO SAMPLE
CREATE TABLE MYEMPLOYEE LIKE EMPLOYEE;


--Aufgabe 4.2
INSERT INTO myemployee (SELECT * FROM employee WHERE job ='MANAGER');


--Aufgabe 4.3

--SPENSER
UPDATE myemployee 
SET salary = '95000.00' 
WHERE empno = '000100';

--GEYER
UPDATE myemployee 
SET salary = '78000.00' 
WHERE empno = '000050';

--THOMPSON
UPDATE myemployee 
SET salary = '82000.00' 
WHERE empno = '000020';

--STERN
UPDATE myemployee 
SET salary = '84000.00' 
WHERE empno = '000060';


--Aufgabe 4.4

-- Mit Merge
MERGE INTO myemployee e1 
USING employee e2 ON e1.empno = e2.empno 
WHEN MATCHED THEN UPDATE SET 
e1.salary = MAX(e1.salary, e2.salary) 
WHEN NOT MATCHED THEN 
INSERT (empno, firstnme ,midinit, lastname, workdept, phoneno, hiredate, job, edlevel, sex, birthdate, salary, bonus, comm)
VALUES (e2.empno, e2.firstnme, e2.midinit, e2.lastname, e2.workdept, e2.phoneno, e2.hiredate, e2.job, e2.edlevel, e2.sex, e2.birthdate, e2.salary, e2.bonus, e2.comm);


--Mit Insert/Update
INSERT INTO myemployee 
SELECT * 
FROM employee 
WHERE empno NOT IN (SELECT empno FROM myemployee);
	
UPDATE myemployee e1 
SET e1.salary = (SELECT e2.salary 
				FROM employee e2 
				WHERE e1.empno = e2.empno) 
WHERE e1.salary < (SELECT e2.salary 
				   FROM employee e2 
				   WHERE e1.empno = e2.empno);
