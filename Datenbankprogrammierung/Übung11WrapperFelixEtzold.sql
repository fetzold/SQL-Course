/*---------------------
--WRAPPER
--Name: Felix Etzold
--Martikel-NR: 3848736
--Instanz: db2ins28
----------------------*/

--Aufgabe 1.1
CATALOG ADMIN TCPIP NODE sodele REMOTE /*IP*/;
CATALOG TCPIP NODE sodele2 REMOTE /*IP*/  SERVER 60000 REMOTE_INSTANCE /*Instanz*/;
CATALOG DATABASE geodb AS geodbrmt AT NODE sodele2;
CONNECT TO geodbrmt USER db2ins10 USING Iabvuf;


--Aufgabe 1.2
CREATE WRAPPER geodb_wrp;


--Aufgabe 1.3
CREATE SERVER geodb_srv WRAPPER geodb_wrp AUTHORIZATION /*Instanz*/ PASSWORD /*Passwort*/;


--Aufgabe 1.4
CREATE USER MAPPING FOR PUBLIC SERVER geodb_srv OPTIONS (REMOTE_AUTHID /*Instanz*/ PASSWORD /*Passwort*/);


--Aufgabe 1.5
CREATE NICKNAME geodb_pop FOR geodb_srv.db2ins10.population;


--Aufgabe 1.6
SELECT n_name, g.population FROM nation, geodb_pop WHERE n_nationkey = g.nationkey;


--Aufgabe 1.7
--Catalog: Speichert Datenbank Standortoinformationen im Systemdatenbankverzeichnis
--Wrapper: Mechanismen mit denen der Server mit Datenquellen interagiert



