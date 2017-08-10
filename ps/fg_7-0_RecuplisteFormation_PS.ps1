<#
Fonction : fg_7-0


#>

Function SQLRequest ($reqStr)
{
	# Affichage de la requete pour les logs
	echo $reqStr >> $logfile
	
	$req = New-Object Mysql.Data.MysqlClient.MySqlCommand($reqStr,$mysql)  
	# Création du data adapter et du dataset qui permettront de traiter les données
	$dataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($req)  
	$dataSet = New-Object System.Data.DataSet  
	$script:rowCount = $dataAdapter.Fill($dataSet,"test")
	$script:result = $dataSet.Tables["test"]
}


# Chargement du pilote .NET pour MySQL 
[system.reflection.Assembly]::LoadWithPartialName("MySql.Data")

# Initialisation des variables  
$serv = "192.168.1.2" # Addresse du serveur
$port = "3306" # Port de connexion (3306 par dÃ©faut)
$user = "vgroup"  # nom d'utilisateur pour la connexion
$password = "vgrouproxx" # mot de passe
$db = "projet_eni" # nom de la base de donnÃ©e



# Creation de l'instance, connexion Ã  la base de donnÃ©es  
$mysql = New-Object MySql.Data.MySqlClient.MySqlConnection("server=" + $serv + ";port=" + $port + ";uid=" + $user + ";pwd=" + $password + ";database=" + $db + ";Pooling=False")  
echo $mysql
$mysql.Open()


#return $DataSet.Tables[0]



SQLRequest ("SELECT * FROM formation;")

$result.Rows

$mysql.Close()

