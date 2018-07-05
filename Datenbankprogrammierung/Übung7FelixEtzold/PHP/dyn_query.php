<?php
require_once('connect.php');
$sql = "SELECT firstnme, lastname, salary FROM employee WHERE salary > " . $_POST['salary'];
$st = db2_exec($con, $sql);
while ($row = db2_fetch_assoc($st)) 
{
	printf("%s|%s|%s<br>", $row['FIRSTNME'], $row['LASTNAME'], $row['SALARY']);
}
db2_close($con);
?>
<p><a href="index.php"><span style="color:#A5DF00;">zurück zur Hauptseite</span></a></p>