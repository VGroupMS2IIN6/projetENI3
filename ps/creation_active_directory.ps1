# fg_9.1_CreationComptesAD_PS

. "../ps/fg_1-1_DBUtils.ps1"

Param(
[string]$StagPrenom,
[string]$StagNom,
[string]$StagFormation,
[string]$StagDateRentree,
[string]$StagDatefinContrat,
[string]$StagDateNaissance,
[int]$StagIDCRM
)

openDB

# Récupération des paramètres du domaine stagiaire ENI
$result = makeRequest ("Select * FROM plateforme WHERE nom = 'active directory';")
$LoginDomainStag = $result.identifiant
$PasswordDomainStag = $result.MDP
$NomDomainStag = $result.domaine + ":389"


$SecPassDomainStag = $PasswordDomainStag | ConvertTo-SecureString -AsPlainText -Force 

$creds = New-Object System.Management.Automation.PSCredential -ArgumentList $LoginDomainStag, $SecPassDomainStag

Import-Module ActiveDirectory

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

New-ADUser -Name $($StagPrenom + $StagNom) -surname $StagNom -GivenName $StagPrenom -SamAccountName $StagSAMAN -Server $NomDomainStag -AccountPassword $SecStagPassTemp -Credential $creds

closeDB