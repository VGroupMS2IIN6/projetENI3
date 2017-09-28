# fg_9.1_CreationComptesAD_PS
Param(
[string]$StagPrenom,
[string]$StagNom,
[string]$StagFormation,
[string]$StagDateRentree,
[string]$StagDatefinContrat,
[string]$StagDateNaissance,
[int]$StagIDCRM
)


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


# CrÃ©ation de l'instance, connexion Ã  la base de donnÃ©es  
$mysql = New-Object MySql.Data.MySqlClient.MySqlConnection("server=" + $serv + ";port=" + $port + ";uid=" + $user + ";pwd=" + $password + ";database=" + $db + ";Pooling=False")  
echo $mysql
$mysql.Open()


# Récupération des paramètres du domaine stagiaire ENI
SQLRequest ("Select nom, param FROM parametres WHERE nom Like '%domaine_stag';")
$LoginDomainStag = $result.Rows[0]["param"]
$PasswordDomainStag = $result.Rows[1]["param"]
$SecPassDomainStag = $PasswordDomainStag | ConvertTo-SecureString -AsPlainText -Force 

$creds = New-Object System.Management.Automation.PSCredential -ArgumentList $LoginDomainStag, $SecPassDomainStag

$mysql.Close()

Import-Module ActiveDirectory

#Init variables
<#
$StagPrenom = "Olivier"
$StagNom = "Jacob-gerghgrthrthrthr"
$StagFormation = "T2SI"
$StagDateRentree = "2017-09-20 17:51:51"
$StagPassTemp = . "..\ps\fg_3-0_GenerationMdpTemp_PS.ps1" 
$StagDatefinContrat = "2019-09-20 17:51:51"
#>

# Génération du mot de passe temporaire
$StagPassTemp = . "..\ps\fg_3-0_GenerationMdpTemp_PS.ps1" $StagPrenom $StagNom $StagDateNaissance

# Génération SAMAcount NAme
$StagSAMAN = $($StagPrenom.Substring(0,1).ToLower() + $StagNom.ToLower())

If ($StagSAMAN.length -ge 18) 
{
$StagSAMAN=$StagSAMAN.Substring(0,18) 
}

# Génération de la Secure String pour le mdp stagiaire
$SecStagPassTemp = $StagPassTemp | ConvertTo-SecureString -AsPlainText -Force 

echo $StagSAMAN

New-ADUser -Name $($StagPrenom + $StagNom) -surname $StagNom -GivenName $StagPrenom -SamAccountName $StagSAMAN -Server "campus-eni.ovh" -AccountPassword $SecStagPassTemp -Credential $creds -whatif