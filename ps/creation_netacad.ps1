# fg_9.5_CreationComptesNetAcad_PS

# Init des variables paramètres


Function SQLRequest ($reqStr)
{
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


# Cretion de l'instance, connexion Ã  la base de donnÃ©es  
$mysql = New-Object MySql.Data.MySqlClient.MySqlConnection("server=" + $serv + ";port=" + $port + ";uid=" + $user + ";pwd=" + $password + ";database=" + $db + ";Pooling=False")  
echo $mysql
$mysql.Open()


# Récupération de l'adresse mail d'envoi à NetAcad
SQLRequest ("Select nom, mail FROM plateforme WHERE nom = 'NetAcad';")
$mailNetAcad = $result.Rows[0]["mail"]

# Récupération de l'adresse du SMTP de l'ENI
SQLRequest ("Select nom, param FROM parametre WHERE nom = 'SMTP_ENI';")
$SmtpENI = $result.Rows[0]["param"]

$mysql.Close()

# Génération d'un CSV pour 7Speaking
Add-Content -Path NetAcad.csv  -Value '"Nom","Prenom","email","ID interne","Date debut de formation","duree"'  

  $stagiairesNetAcad = @(

  '"Adam","Bertram","abertram"'
  '"Joe","Jones","jjones"'
  '"Mary","Baker","mbaker"'

  )

  $stagiaires7Sspeaking | foreach { Add-Content -Path  NetAcad.csv -Value $_ }


#Envoi du mail avec le CSV
Send-MailMessage -From "Eric Persan <epersan@eni-ecole.fr>" -To $mailNetAcad -Subject "ENI Ecole - Creation de comptes" -Body "Bonjour, veuillez trouver ci joint le fichier CSV contenant les comptes à créer" -Attachments "NetAcad.csv" -SmtpServer $SmtpENI