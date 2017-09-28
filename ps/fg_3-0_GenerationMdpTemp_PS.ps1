<#
Fonction : fg_3.0_GenerationMdpTemp_PSAuteur : JB
Entrées :
    - Prénom du stagiaire
    - Nom du stagiaire
    - Date de naissance
    - Id de la plateforme concernée
Dernière MAJ : 28/06/2017
#>

# Récupération des paramètres
Param(
[string]$prenomStag,
[string]$nomStag,
[string]$dateNaissanceStag
#[int]$IdPlateforme
)

#### Conection à la DB déjà effectué avant par une autre fonction ?

# Requete SQL de récupération de l'expresion régulière de génération du mot de passe en fonction de la plateforme
$reqStr = "SELECT p.regexMDP FROM plateforme AS p WHERE p.identifiant = '" + $IdPlateforme + "'"  
$req = New-Object Mysql.Data.MysqlClient.MySqlCommand($reqStr,$mysql)
$dataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($req)  
$dataSet = New-Object System.Data.DataSet  
$dataAdapter.Fill($dataSet,"test") | out-null


# DEV : 
<#
$prenomStag = "jonathan"
$nomStag = "blanchard"
$dateNaissanceStag = "01/03/1988"
#>

# Génération du mot de passe
$pwd = $($prenomStag.Substring(0,2).ToLower() + $nomStag.Substring(0,2).ToUpper() + $dateNaissanceStag.Substring(0,2).ToUpper() + "@")

return $pwd