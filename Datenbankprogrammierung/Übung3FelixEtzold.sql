--Aufgabe 1.1
CATALOG ADMIN TCPIP NODE sodele REMOTE /*IP*/;

--Aufgabe 1.2
CATALOG TCPIP NODE sodele2 REMOTE /*IP*/  SERVER 60000 REMOTE_INSTANCE /*Instanz*/;

--Aufgabe 1.3
CATALOG DATABASE geodb AT NODE sodele2;

--Aufgabe 1.4
list node directory; --Instanz
list admin node directory; --Verwaltung
list database directory; --Datenbank

--Aufgabe 1.5
CONNECT TO geodb USER db2ins10 USING Iabvuf;

--Aufgabe 1.6
SELECT geo_Landkreis FROM geodb WHERE GEO_Bundesland = 'SN' GROUP BY GEO_landkreis ;

--Aufgabe 1.7
UNCATALOG NODE sodele;
UNCATALOG NODE sodele2;
UNCATALOG DATABASE; geodb;
 
--Aufgabe 2.1 a)
db2 FORCE APPLICATION ALL;
db2stop;
db2start;

--Aufgabe 2.1 b)
--Befehl: 
db2pd -edus
--Ergebns:
idle

--Aufgabe 2.1 c)
/*
EDU Name                      
==============================
db2fw15 (TPCH) 0              
db2fw14 (TPCH) 0              
db2fw13 (TPCH) 0              
db2fw12 (TPCH) 0              
db2fw11 (TPCH) 0              
db2fw10 (TPCH) 0              
db2fw9 (TPCH) 0               
db2fw8 (TPCH) 0               
db2fw7 (TPCH) 0               
db2fw6 (TPCH) 0               
db2fw5 (TPCH) 0               
db2fw4 (TPCH) 0               
db2fw3 (TPCH) 0               
db2fw2 (TPCH) 0               
db2fw1 (TPCH) 0               
db2fw0 (TPCH) 0               
db2wlmd (TPCH) 0              
db2pfchr (TPCH) 0             
db2pfchr (TPCH) 0             
db2pfchr (TPCH) 0             
db2pclnr (TPCH) 0             
db2pclnr (TPCH) 0             
db2pclnr (TPCH) 0             
db2pclnr (TPCH) 0             
db2pclnr (TPCH) 0             
db2pclnr (TPCH) 0             
db2pclnr (TPCH) 0             
db2pclnr (TPCH) 0             
db2pclnr (TPCH) 0             
db2pclnr (TPCH) 0             
db2pclnr (TPCH) 0             
db2pclnr (TPCH) 0             
db2pclnr (TPCH) 0             
db2pclnr (TPCH) 0             
db2pclnr (TPCH) 0             
db2dlock (TPCH) 0             
db2lfr (TPCH) 0               
db2loggw (TPCH) 0             
db2loggr (TPCH) 0             
db2taskd (TPCH) 0             
db2stmm (TPCH) 0              
db2agent (TPCH) 0
*/

--Aufgabe 3.1
SELECT tabname FROM syscat.tables WHERE type='V' OR type='W';

--Aufgabe 4.1
/*
Durch unzulässigen parallelen Datenbankzugriff treten Anomalien im Mehrbenutzerbetrieb auf
Es gibt 4 verschiedene Anomalien:

1. Lost Update: Problem wenn mehrere parallele Schreibzugriffe auf eine gemeinsam genutzte Information auftreten. Zwei Transaktionen verändern selbe Information, 
				dann kann die Änderung der ersten durch die Änderung der zweiten Transaktion überschrieben werden
2. Dirty Read: zwei gleichzeitg ablaufende Transaktionen die eine Datei lesen, die von einer anderern Transaktion geschrieben werden, jedoch nicht committed wurde
3. Non-Repeatable Read: innerhalb einer Transaktion diesselbe Leseoperation unterschiedliche Ergebnisse liefert
4. Phantom:  Wenn z.b. ein Datensatz gelesen wird, aber gleichzeitig eine ablaufende Transaktion Eigenschaften verändert/einfügt, Erste Transaktion kann inkonsistente Daten enthalten 
*/

--Aufgabe 4.2
/*
Isolationsstufen geben an welche Parallelitätsnebeneffekte (=Anomalien) zulässig sind. 

Eine niedrige Isolationstufe erhöht die Möglichkeit das viele Benutzer gleichzeitig auf Daten
zugreifen können aber auch führt es zu einem Anstieg negativer Parallelitätsnebeneffekte.

Eine hohe Isolationsstufe schränkt die Tyüen der Parallelitätseffekte ein, aber dafür werden mehr Systemressourcen
beansprucht und die wahrscheinlichkeit steigt, das sich Transaktionen untereinander blockieren
*/

--Aufgabe 4.3
/*
Szenario 1: 
Folgende Anomalie liegt vor: Lost UPDATE
Isolationsstufe: Read Committed , Repeatable Read, Serializable

Szenario 2:
Folgende Anomalie liegt vor: Non-Repeatable Read
Isolationsstufe: Repeatable Read, Serializable
*/

--Aufgabe 5.2
--c) MAX_COORDAGENTS
