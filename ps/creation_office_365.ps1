cls

PARAM(
$StagPrenom = "test"
$StagNom = "ENI"
$StagMAil = "testENI1@campus-gscls.com"
$StagmdpTemp = "TATAYooy589"
)
# connexion à Office 365
$user = "jblanchard@gsc49.fr"
$password = "JbgFMsDL@"
$secureStringPwd = $password | ConvertTo-SecureString -AsPlainText -Force 

$creds = New-Object System.Management.Automation.PSCredential -ArgumentList $user, $secureStringPwd

Connect-MsolService -Credential $creds

# Création des comptes

## init des variables


new-MSolUSER -DisplayNAme $($StagPrenom + $StagNom) -FirstName $StagPrenom -LastName $Stagnom -UserPrincipalName $StagMAil -Password $StagmdpTemp
## Licence !!!!!