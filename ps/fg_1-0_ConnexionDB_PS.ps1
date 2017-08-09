Param(
[string]$reqStr
)


$reqStr = "Select nom, param FROM parametres WHERE nom = 'nom_domaine_ENI_Groupe';"

# Chargement du pilote .NET pour MySQL 
[system.reflection.Assembly]::LoadWithPartialName("MySql.Data")

# Récupération de tout le contenu du fichier de configuration
$confFile = Get-Content "..\ps\config.cfg"

# Evaluation des variables
## Adresse du serveur
$temp = select-string "..\ps\config.cfg" -pattern "# Adresse du serveur"
$serv = $confFile[($temp.LineNumber)]

## Port de connexion
$temp = select-string "..\ps\config.cfg" -pattern "# Port de connexion"
$port = $confFile[($temp.LineNumber)]

## nom d'utilisateur
$temp = select-string "..\ps\config.cfg" -pattern "# nom d'utilisateur"
$user = $confFile[($temp.LineNumber)]

## mot de passe
$temp = select-string "..\ps\config.cfg" -pattern "# mot de passe"
$password = $confFile[($temp.LineNumber)]

## nom de la base de donnee
$temp = select-string "..\ps\config.cfg" -pattern "# nom de la base de donnee"
$db = $confFile[($temp.LineNumber)]



# Ouverture de la connexion à la base

$mysql = New-Object MySql.Data.MySqlClient.MySqlConnection("server=" + $serv + ";port=" + $port + ";uid=" + $user + ";pwd=" + $password + ";database=" + $db + ";Pooling=False")  
echo $mysql
$mysql.Open()


$req = New-Object Mysql.Data.MysqlClient.MySqlCommand($reqStr,$mysql)  
	# Création du data adapter et du dataset qui permettront de traiter les données
	$dataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($req)  
	$dataSet = New-Object System.Data.DataSet  
	$script:rowCount = $dataAdapter.Fill($dataSet,"test")
	$script:result = $dataSet.Tables["test"]

return $result

#$nomDomaineGroupeENI = $result.Rows[0]["param"]
#$nomDomaineGroupeENI