--Aufgabe 1a
WITH rekTabelle(deptno, admrdept) AS
(
	SELECT root.deptno, root.admrdept
	FROM department root
	UNION ALL
	SELECT parent.deptno, child.admrdept
	FROM rekTabelle parent, department child
	WHERE parent.admrdept = child.deptno AND child.admrdept != parent.admrdept 
)
SELECT DISTINCT deptno, admrdept
FROM rekTabelle
ORDER BY deptno, admrdept;

--Aufgabe 1b
CREATE GLOBAL TEMPORARY TABLE tempTabelle (admrdept VARCHAR(3)) 
ON COMMIT PRESERVE ROWS@

CREATE OR REPLACE PROCEDURE alle_Abteilungen(IN deptnr VARCHAR(3))
LANGUAGE SQL
BEGIN
	DECLARE jetAbteilung VARCHAR(3);
	DECLARE vor_Abteilung VARCHAR(3);
	
	DECLARE C1 CURSOR FOR
		SELECT d.admrdept
		FROM department d
		WHERE d.deptno = deptnr;

	DECLARE C2 CURSOR FOR
		SELECT d.admrdept
		FROM department d
		WHERE d.deptno = (SELECT * FROM tempTabelle ORDER BY admrdept DESC FETCH FIRST 1 ROW ONLY);	

	OPEN C1; FETCH C1 INTO jetAbteilung; CLOSE C1;
	INSERT INTO tempTabelle(admrdept) VALUES jetAbteilung;
	REPEAT
		OPEN C2;
		SET jetAbteilung = vor_Abteilung;
		FETCH C2 INTO vor_Abteilung; 
		INSERT INTO tempTabelle(admrdept) VALUES jetAbteilung;
		CLOSE C2;
	UNTIL (jetAbteilung = vor_Abteilung) END REPEAT;
END@

CALL alle_Abteilungen('G22')@
/* Erstellt irgendwie noch den ein "-" */

--Aufgabe 2.1.1
CREATE OR REPLACE TRIGGER T_ACCT_CHK
NO CASCADE BEFORE INSERT ON ORDERS
REFERENCING NEW AS new_row
FOR EACH ROW MODE DB2SQL
BEGIN ATOMIC
	DECLARE Guthaben INTEGER;
	SET Guthaben = (SELECT c.c_acctbal FROM customer c WHERE c.c_custkey = new_row.o_custkey);

	IF Guthaben < 0 THEN
		SIGNAL SQLSTATE '40000' SET MESSAGE_TEXT = 'Kunde hat negativen Kontostand';
	END IF;
END@

INSERT INTO ORDERS VALUES (50000, 1414, 'O', 555, '2015-06-08', '5-Low', 'Clerk#000000951', 0, 'adsf')	-- Kunde mit negativem Kontostand
INSERT INTO ORDERS VALUES (50000, 2, 'O', 555, '2015-06-08', '5-Low', 'Clerk#000000951', 0, 'adsf')		-- Kunde mit positivem Kontostand


--Aufgabe 2.1.2
CREATE OR REPLACE TRIGGER T_ORDERDATE_CHK
NO CASCADE BEFORE INSERT ON ORDERS
REFERENCING NEW AS new_row
FOR EACH ROW MODE DB2SQL
BEGIN ATOMIC
	SET new_row.o_orderdate = CURRENT DATE;
END@

INSERT INTO ORDERS VALUES (500005, 2, 'O', 555, '2015-06-08', '5-Low', 'Clerk#000000951', 0, 'adsf')	-- Datum wird auf heutiges Datum geändert

--Aufgabe 2.2.1 Einfügen
CREATE OR REPLACE TRIGGER T_LINEITEM_INSERT
AFTER INSERT ON LINEITEM
REFERENCING NEW AS new_row
FOR EACH ROW MODE DB2SQL
BEGIN ATOMIC
	UPDATE ORDERS 
	SET o_totalprice = o_totalprice + l_extendedprice * (1 - l_discount) * (1 + l_tax)
	WHERE o_orderkey = new_row.l_orderkey;	
END@

--Aufgabe 2.2.2	Löschen				
CREATE OR REPLACE TRIGGER T_LINEITEM_DELETE
AFTER DELETE ON LINEITEM
REFERENCING OLD AS old_row
FOR EACH ROW MODE DB2SQL
BEGIN ATOMIC
	UPDATE ORDERS 
	SET o_totalprice = o_totalprice - l_extendedprice * (1 - l_discount) * (1 + l_tax)
	WHERE o_orderkey = old_row.l_orderkey;	
END@

--aufgabe 2.2.3	Update
CREATE OR REPLACE TRIGGER T_LINEITEM_UPDATE
AFTER UPDATE ON LINEITEM
REFERENCING OLD AS old_row NEW AS new_row
FOR EACH ROW MODE DB2SQL
BEGIN ATOMIC
	UPDATE ORDERS
	SET o_totalprice = o_totalprice - old_row.l_extendedprice * (1 - old_row.l_discount) * (1 + old_row.l_tax)
	WHERE o_orderkey = old_row.l_orderkey;
		
	UPDATE ORDERS 
	SET o_totalprice = o_totalprice + new_row.l_extendedprice * (1 - new_row.l_discount) * (1 + new_row.l_tax)
	WHERE o_orderkey = new_row.l_orderkey;
END@

--Aufgabe 3
CREATE TABLE RAUM (RNR INT PRIMARY KEY NOT NULL, BEZ VARCHAR(25))@
CREATE TABLE VERANSTALTUNG(NAME VARCHAR(25), TERMIN DATE, RNR INT, FOREIGN KEY (RNR) REFERENCES RAUM(RNR))@

CREATE OR REPLACE TRIGGER NO_DOUBLE_BOOKING
BEFORE INSERT ON VERANSTALTUNG
REFERENCING NEW AS new_row
FOR EACH ROW MODE DB2SQL
BEGIN ATOMIC
	DECLARE sodele INTEGER;
	-- gibt es eine VERANSTALTUNG an diesem Tag?
	SET sodele = (SELECT count(*) FROM veranstaltung WHERE name = new_row.name AND termin = new_row.termin);
	
	IF(sodele > 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Es gibt schon eine Veranstaltung an diesem Tag';
	END IF;
END@

-- Sequenz
CREATE OR REPLACE SEQUENCE SEQ_RNR
START WITH 1 
INCREMENT BY 1
NO MAXVALUE
NO CYCLE
CACHE 24@

INSERT INTO RAUM VALUES (NEXT VALUE FOR SEQ_RNR, 'Messehalle 1')@

/* Hier müsste man eig auf Sequenz verweisen.... */
INSERT INTO VERANSTALTUNG VALUES ('WWDC', '2015-06-08', NEXT VALUE FOR SEQ_RNR)@
INSERT INTO VERANSTALTUNG VALUES ('Bockwurstkonvention', '2015-04-08', NEXT VALUE FOR SEQ_RNR)@

--Aufgabe 4.1
--(A) - An SQL stored procedure that accepts an integer value as input 
--and returns a cursor for all rows found in table TAB1 to procedure 
--caller

--Aufgabe 4.2
--(B) - DROP SPECIFIC PROCEDURE SProc

--Aufgabe 4.3
--Antwort: 4 Zeilen werden in der Tabelle Notifylog hinzugefügt

--Aufgabe 4.4
--Antwort: Die neue ID ist 4
