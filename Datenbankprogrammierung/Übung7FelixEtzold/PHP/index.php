<!doctype html>
<html>
	<head>
		<meta charset="utf-8">
	</head>
	<body>
		<form action="connectiontest.php" method="post">
			<p><h2><p><span style="color:#A5DF00;">Verbindungszentrum</span></h2></p>
			
			<label for="hostname"><span style="color:#FE9A2E;">Hostname:</span></label></br>
			<input type="text" name="hostname" id="hostname" value=/*IP*/></br>

			<label for="port"><span style="color:#FE9A2E;">Port:</span></label></br>
			<input type="text" name="port" id="port" value="60072"></br>

			<label for="database"><span style="color:#FE9A2E;">Database:</span></label></br>
			<input type="text" name="database" id="database" value="SAMPLE"></br>s

			<label for="database"><span style="color:#FE9A2E;">Username:</span></label></br>
			<input type="text" name="username" id="username" value=/*Instanz*/></br>

			<label for="password"><span style="color:#FE9A2E;">Password:</span></label></br>
			<input type="password" name="password" id="password" value=""></br>

			<input type="submit" value="Bestätigen"><br/><br/>
		</form>
	</body>
</html>