<?php
$database = $_POST["database"];
$user = $_POST["username"];
$password = $_POST["password"];
$hostname = $_POST["hostname"];
$port = $_POST["port"];

$con_string = "DRIVER={IBM DB2 ODBC DRIVER};".
				"DATABASE=$database;".
				"HOSTNAME=$hostname;".
				"PORT=$port;".
				"UID=$user;".
				"PWD=$password;".
				"PROTOCOL=TCPIP;";
				
$con = db2_connect($con_string, '', '');

if ($conn) 
{
    echo "Erfolgreich verbunden!<br>";
}
else 
{
    echo db2_con_errormsg();
}
?>
<p><a href="index.php"><span style="color:#A5DF00;">zurück zur Hauptseite</span></a></p>

