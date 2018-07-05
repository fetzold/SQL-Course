<?php
require_once('connect.php');
$sql = "SELECT d.deptname, e.firstnme, e.lastname FROM department d, employee e WHERE d.mgrno = e.empno";
$st = db2_exec($con, $sql);
while ($row = db2_fetch_array($st)) 
{
	echo "$row[0] | $row[1] | $row[2]<br>";
}
db2_close($con);
?>
<p><a href="index.php"><span style="color:#A5DF00;">zurück zur Hauptseite</span></a></p>