<?php
require_once('connect.php');
$sql = "SELECT p.projno, p.projname, d.deptname FROM project p, department d WHERE p.deptno = d.deptno";
$st = db2_exec($con, $sql);
while ($row = db2_fetch_assoc($st)) 
{
	printf("%s|%s|%s<br>", $row['PROJNO'], $row['PROJNAME'], $row['DEPTNAME']);
}
db2_close($con);
?>
<p><a href="index.php"><span style="color:#A5DF00;">zurück zur Hauptseite</span></a></p>
