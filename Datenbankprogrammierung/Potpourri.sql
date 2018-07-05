--Aufgabe 1
CREATE TABLE AUTOR(ANR INT PRIMARY KEY NOT NULL, NAME VARCHAR(25))
CREATE TABLE BUCH(TITEL VARCHAR(25), ANR INT, FOREIGN KEY (ANR) REFERENCES AUTOR(ANR))

CREATE OR REPLACE SEQUENCE SEQ_ANR AS INT 
START WITH 1 
INCREMENT BY 1 
MINVALUE 1 
NO MAXVALUE 
NO CYCLE 
NO CACHE ORDER

INSERT INTO AUTOR VALUES (NEXT VALUE FOR SEQ_ANR, 'Markus Heitz')

INSERT INTO BUCH VALUES ('Die Zwerge',PREVIOUS VALUE FOR SEQ_ANR)
INSERT INTO BUCH VALUES ('Die Albae ',PREVIOUS VALUE FOR SEQ_ANR)

/*
Aufgabe 2.1
Anomalie: Non-Repeatable Read
Auswirkung: Selbe Leseoperation von T1 liefert unterschiedliche Ergebnisse
Isolationsstufe: Repeatable Read

Aufgabe 2.2
Anomalie: Lost Update
Auswirkung: T1 und T2 schreiben parallel und verändern dieselbe Information, das heißt eine Änderung wird überschrieben
Isolationsstufe: Read Committed

Aufgabe 2.3
Anomalie: Dirty Read
Auswirkung: zwei gleichzeitg ablaufende Transaktionen die eine Datei lesen, die von einer anderern Transaktion geschrieben werden, jedoch nicht committed wurde
Isolationsstufe: Read Committed

Aufgabe 2.4
Anomalie: Phantom
Auswirkung: inkonsistente Daten der ersten Transaktion
Isolationsstufe: Serializable

Aufgabe 3
c) Der Nutzer muss hinreichende Privilegien auf den referenzierten Tabellen besitzen.
*/

