<?php
$database = 'SAMPLE';
$user = /*Instanz*/;
$password = '';
$hostname = /*IP*/;
$port = 60072;

$con_string = "DRIVER={IBM DB2 ODBC DRIVER};".
				"DATABASE=$database;".
				"HOSTNAME=$hostname;".
				"PORT=$port;".
				"PROTOCOL=TCPIP;".
				"UID=$user;".
				"PWD=$password;";
				
$con = db2_connect($con_string, '', '');

if ($con) 
{
    echo "<p>Erfolgreich verbunden!</p>";
}
else 
{
    echo db2_con_errormsg();
}
?>