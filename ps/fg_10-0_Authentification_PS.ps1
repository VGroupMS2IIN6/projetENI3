<#
Fonction : fg_10.0_Authentification _PSAuteur : JB
Entrées :
    - nom d’utilisateur (SAMAcountName)
    - mot de passe (saisit par l'utilisateur)
Dernière MAJ : 28/06/2017
#>

# Récupération des paramètres
Param(
[string]$ADusername,
[string]$ADpassword
)

#[System.Windows.Forms.MessageBox]::Show($ADusername, "username")
#[System.Windows.Forms.MessageBox]::Show($ADpassword, "password")

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


# Récupération du nom de domaine du Groupe ENI
SQLRequest ("Select nom, param FROM parametres WHERE nom = 'nom_domaine_ENI_Groupe';")
$nomDomaineGroupeENI = $result.Rows[0]["param"]

$mysql.Close()

##### DEBUG
#$ADusername = "sartu"
#$ADpassword = "admin123@"
#[System.Windows.Forms.MessageBox]::Show($ADusername, "ADusername")
#[System.Windows.Forms.MessageBox]::Show($ADpassword, "ADpassword")

Add-Type -AssemblyName System.DirectoryServices.AccountManagement
$ct = [System.DirectoryServices.AccountManagement.ContextType]::Domain
$pc = New-Object System.DirectoryServices.AccountManagement.PrincipalContext $ct,$nomDomaineGroupeENI
if($pc.ValidateCredentials($ADusername,$ADpassword) -eq $true)
    {
    echo 'VRAI2'
    $global:return = 'vrai'
    }
else
    {
    echo 'FAUX2'
    $global:return = 'faux'
    }

return $return