--Aufgabe 1.1
CREATE DATABASE XMLDB;

--Aufgabe 1.2
CREATE TABLE CUSTOMER (cid INT, status VARCHAR(10), info XML);

--Aufgabe 1.3
REGISTER XMLSCHEMA http://xmlsampledb.org FROM '/home/dbprog/data/xmldb/customer.xsd' AS CUSTOMER;
COMPLETE XMLSCHEMA CUSTOMER;

--Aufgabe 1.4a)
--Implizites Parsen
INSERT INTO CUSTOMER (cid, status, info) VALUES (5, 'silver',
'<customerinfo xmlns="http://xmlsampledb.org" cid="5">
	<name>
		<firstname>Larry</firstname>
		<lastname>Smith</lastname>
	</name>
	<addr country="Canada">
		<street>5 Rosewood</street>
		<city>Toronto</city>
		<prov-state>Ontario</prov-state>
		<pcode-zip>M6W 1E6</pcode-zip>
	</addr>
	<phone type="work">416-555-1358</phone>
</customerinfo>'
)@

--Explizits Parsen
INSERT INTO CUSTOMER (cid, status, info) VALUES 
(5, 'silver',XMLPARSE														--Wohlgeformtheit, Regeln XML eingehalten
	(DOCUMENT
		'<customerinfo xmlns="http://xmlsampledb.org" cid="5">
			<name>
				<firstname>Larry</firstname>
				<lastname>Smith</lastname>
			</name>
			<addr country="Canada">
				<street>5 Rosewood</street>
				<city>Toronto</city>
				<prov-state>Ontario</prov-state>
				<pcode-zip>M6W 1E6</pcode-zip>
			</addr>
			<phone type="work">416-555-1358</phone>
		</customerinfo>'
	)
)@

DELETE FROM CUSTOMER WHERE cid=5;

--Aufgabe 1.4b)
INSERT INTO CUSTOMER (cid, status, info) VALUES 
(5,'silver',XMLVALIDATE												--valide zum Schema
	(XMLPARSE														--Wohlgeformtheit, Regeln XML eingehalten
		(
			DOCUMENT
			'<customerinfo xmlns="http://xmlsampledb.org" cid="5">
				<name>
					<firstname>Larry</firstname>
					<lastname>Smith</lastname>
				</name>
				<addr country="Canada">
					<street>5 Rosewood</street>
					<city>Toronto</city>
					<prov-state>Ontario</prov-state>
					<pcode-zip>M6W 1E6</pcode-zip>
				</addr>
				<phone type="work">416-555-1358</phone>
			</customerinfo>'
		)ACCORDING TO XMLSCHEMA ID CUSTOMER							-- hier wird schema angegeben
	)
)@
--Problem bei Name

--SQL16196N  XML document contains an element "name" that is not correctly specified. Reason code = "19"

--Aufgabe 2.1
xquery
declare default element namespace "http://xmlsampledb.org";
for $cust_name in db2-fn:xmlcolumn('CUSTOMER.INFO')/customerinfo
where $cust_name/addr/city = 'Toronto'
order by $cust_name/name/text()
return $cust_name/name/text()@

--Aufgabe 2.2
xquery
declare default element namespace "http://xmlsampledb.org";
<result xmlns="http://xmlsampledb.org">
{
	for $cust_name_phone in db2-fn:xmlcolumn('CUSTOMER.INFO')/customerinfo
	where $cust_name_phone/phone != ''
	return ($cust_name_phone/name, $cust_name_phone/phone)
}
</result>@

--Aufgabe 2.3a)
select 
	xmlquery
	(
		'declare default element namespace "http://xmlsampledb.org"; $status/customerinfo/name/text()' 
		passing info as "status"
	) 
	as cust_name
from customer 
where status = 'gold'@
	
--Aufgabe 2.3b)
XQUERY 
declare default element namespace "http://xmlsampledb.org";
let $name :=
db2-fn:sqlquery
('
	SELECT info FROM customer WHERE status = ''gold''
')/customerinfo/name
return <goldcustomers>{$name}</goldcustomers>@

--Aufgabe 2.4
select
	xmlquery
	(
		'declare default element namespace "http://xmlsampledb.org"; $name_cust/customerinfo/name/text()' 
		passing info as "name_cust"
	) 
	as cust_name, status
from customer 
where 
	XMLEXISTS
	(
		'declare default element namespace "http://xmlsampledb.org"; $phonetype/customerinfo/phone[@type=''home'']' 
		PASSING info AS "phonetype"
	)@

--Aufgabe 2.5
select
	xmlquery
	(
		'declare default element namespace "http://xmlsampledb.org"; $cust_name/customerinfo' 
		passing info as "cust_name"
	) 
	as cust_name, status
from customer 
where 
	xmlexists
	(
		'declare default element namespace "http://xmlsampledb.org"; $cid/customerinfo[@cid != $cust_id]' 
		passing info as "cid", 
		cid as "cust_id"
	)@

--Aufgabe 3.1
SELECT 
	XMLELEMENT
	(
		NAME "nation",
		XMLNAMESPACES(DEFAULT 'http://exampledb.org'),
		XMLATTRIBUTES(n_nationkey AS "nationkey"), n_nationkey
	)
FROM nation
ORDER BY n_name@
	
--Aufgabe 3.2
SELECT 
	XMLELEMENT
	(
		NAME "customer",
		XMLNAMESPACES(DEFAULT 'http://exampledb.org'),
		XMLATTRIBUTES((SELECT COUNT(o_orderkey) FROM orders WHERE c_custkey = o_custkey) AS "numorders"), c_custkey
	)
FROM customer@
	
--Aufgabe 3.3
SELECT 
	XMLELEMENT
	( 
		NAME "nation", 
		XMLNAMESPACES(DEFAULT 'http://exampledb.org'),
		XMLATTRIBUTES
		( 
			(SELECT COUNT(c2.c_custkey) FROM customer c2 WHERE c2.c_nationkey = n_nationkey) AS "custcount"
		), 
		XMLAGG
		( 
			XMLELEMENT 
			(
				NAME "customer", c1.c_custkey
			)
		)
	)
FROM nation 
FULL OUTER JOIN customer c1
ON n_nationkey = c1.c_nationkey
GROUP BY n_nationkey@
	
--Aufgabe 4.1
CREATE UNIQUE INDEX cid
ON customer(info)
GENERATE KEY USING XMLPATTERN 'declare default element namespace "http://xmlsampledb.org"; /customerinfo/@cid'
AS SQL DOUBLE@

--SQL0803N  One or more values in the INSERT statement, UPDATE statement, or
--foreign key update caused by a DELETE statement are not valid because the
--primary key, unique constraint or unique index identified by "4" constrains
--table "DB2INS28.CUSTOMER" from having duplicate values for the index key.
--SQLSTATE=23505

--Aufgabe 4.2
CREATE INDEX phone 
ON customer(info)
GENERATE KEY USING XMLPATTERN 'declare default element namespace "http://xmlsampledb.org"; //phone'
AS SQL VARCHAR(100)@
