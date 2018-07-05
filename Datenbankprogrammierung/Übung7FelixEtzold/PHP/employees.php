<?php
require_once('connect.php');
$sql = "SELECT firstnme, lastname, birthdate FROM employee";
$st = db2_exec($con, $sql);
while ($row = db2_fetch_object($st)) 
{
	echo "{$row->FIRSTNME} | {$row->LASTNAME} | {$row->BIRTHDATE}<br>";
}
db2_close($con);
?>
<p><a href="index.php"><span style="color:#A5DF00;">zurück zur Hauptseite</span></a></p>