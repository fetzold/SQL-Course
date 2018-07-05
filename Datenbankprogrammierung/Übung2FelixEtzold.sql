--Aufgabe 1.1
SELECT s.s_name 
FROM supplier s 
WHERE s.s_nationkey IN (SELECT n.n_nationkey 
						FROM nation n , region r 
						WHERE n.n_regionkey = r.r_regionkey AND r.r_name = 'AFRICA');

						
--Aufgabe 1.2
SELECT c1.c_name, c1.c_mktsegment, c1.c_acctbal 
FROM customer c1 
WHERE c1.c_acctbal > ALL (SELECT c2.c_acctbal 
						  FROM customer c2 
						  WHERE c1.c_mktsegment = c2.c_mktsegment AND c2.c_custkey <> c1.c_custkey);
						  
						  
--Aufgabe 1.3
SELECT o_orderkey, o_orderdate, o_orderstatus 
FROM orders, (SELECT c_custkey 
			  FROM customer, nation 
			  WHERE c_nationkey = n_nationkey AND n_name = 'FRANCE')  
WHERE o_custkey = c_custkey ORDER BY o_orderdate;


--Aufgabe 1.4
WITH SODELE AS (
	SELECT ps_suppkey, sum(ps_availqty) as verfügbar
	FROM part, partsupp
	WHERE ps_partkey = p_partkey AND p_type LIKE '%STEEL%'
	GROUP BY ps_suppkey
)
SELECT s_name, verfügbar
FROM supplier, SODELE
WHERE s_suppkey = ps_suppkey
ORDER BY verfügbar ASC;


--Aufgabe 1.5
SELECT p_name, (
        SELECT SUM(ps_availqty) 
        FROM partsupp 
        WHERE ps_partkey = p_partkey
    ) verfügbar
FROM part
ORDER BY verfügbar DESC;


--Aufgabe 2
CREATE VIEW REGION_TURNOVER AS 
SELECT r1.r_name AS SUPP_REGION, r2.r_name AS CUST_REGION, SUM(li.l_extendedprice*(1-li.l_discount)) AS TURNOVER 
FROM region r1, region r2, nation n1, nation n2, lineitem li, orders o, customer c, supplier s 
WHERE li.l_suppkey = s.s_suppkey AND s.s_nationkey = n1.n_nationkey AND n1.n_regionkey = r1.r_regionkey AND li.l_orderkey = o.o_orderkey AND o.o_custkey = c.c_custkey AND c.c_nationkey = n2.n_nationkey AND n2.n_regionkey = r2.r_regionkey 
GROUP BY r1.r_name, r2.r_name;


--Aufgabe 3.1
SELECT SUM(li.l_extendedprice*(1-li.l_discount)) AS GesamtUmsatz, r.r_name AS UmsatzRegion, n.n_name AS UmsatzLandRegion 
FROM lineitem li, nation n, region r, orders o, customer c 
WHERE li.l_orderkey = o.o_orderkey AND o.o_custkey = c.c_custkey AND c.c_nationkey = n.n_nationkey AND n.n_regionkey =r.r_regionkey 
GROUP BY GROUPING SETS ((),(r.r_name),(r.r_name, n.n_name));

--Aufgabe 3.2
SELECT SUM(l_extendedprice*(1-l_discount)*l_tax) AS GesamtSteuern, r.r_name AS SteuerRegion, n.n_name AS SteuerLandRegion 
FROM lineitem li, nation n, region r, orders o, customer c 
WHERE li.l_orderkey = o.o_orderkey AND o.o_custkey = c.c_custkey AND c.c_nationkey = n.n_nationkey AND n.n_regionkey =r.r_regionkey 
GROUP BY ROLLUP(r.r_name, n.n_name);


--Aufgabe 3.3
--In Aufgabe 3.2 Sieht das folgendermaßen aus:
--ROLLUP (r.r_name, n.n_name) = GROUPING SETS ((),(r.r_name),(r.r_name, n.n_name)) 
--Würde ich nun die Reihenfolge im ROLLUP ändern sieht das so aus:
--ROLLUP(n.n_name, r.r_name) = GROUPING SETS ((),(n.n_name),(n.n_name, r.r_name)) 
--Daran sieht man das andere grouping sets gebildet werden bzw. ganz anders gruppiert wird.


--Aufgabe 4.1 
SELECT SUM(o_totalprice) OVER(PARTITION BY o_orderdate) AS Umsatz , o_orderdate, COUNT(o_orderkey) OVER(PARTITION BY o_orderdate) AS Anzahlauftraege,o_orderkey AS Auftragsnummer, o_totalprice As Preis 
FROM orders 
WHERE o_orderdate like '%1998%';


--Aufgabe 4.2
SELECT SUM(o_totalprice) OVER(PARTITION BY o_orderdate ORDER BY o_orderkey) AS Umsatz , o_orderdate, COUNT(o_orderkey) OVER(PARTITION BY o_orderdate) AS Anzahlauftraege,o_orderkey AS Auftragsnummer, o_totalprice As Preis 
FROM orders 
WHERE o_orderdate like '%1998%';


--Aufgabe 4.3
SELECT o_orderkey, o_custkey, o_totalprice, AVG(o_totalprice) OVER(PARTITION BY o_custkey ORDER BY o_orderdate ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) 
FROM orders 
WHERE o_orderdate like '%1996%';


--Aufgabe 4.4
/*
Unterschiede:
OLTP: 
-Verarbeitung von Transaktionen finden sofort statt ohne nennenswerte Zeitverzögerung 
-zeilenorientierte Logik
-transaktionsorientiert

OLAP: 
-Sind Systeme die schnell wachsende Datenbestände multidimensional sichtbar machen
-multidimensionale datenpunktorientierte Logik
-Strukut: OLAP-Würfel
-analyse- und themenorientiert
-komplexe Abfragen


Anfragen:
OLTP:
- strukturiert, meist im Programmcode

OLAP:
-wird je nach Einsatz bestimmt

Einsatz:
OLTP: 
-große Anzahl von Nutzern, die kurze Transaktionen ausführen z.B. Finanztransaktionen
-operative Systeme (z.B. Administartionssysteme)
OLAP:
- z.B. Data Warehouse
*/
