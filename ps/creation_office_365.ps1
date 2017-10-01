function creation_office365
{
    $Mail = "testENI1@campus-gscls.com"
    $password = "TATAYooy589"
    
    # connexion à Office 365
    #$LoginOffice = "jblanchard@gsc49.fr"
    #$PasswordOffice = "JbgFMsDL@"

    $result = makeRequest ("Select * FROM plateforme WHERE nom = 'Office 365';")
    $LoginOffice = $result.identifiant
    $PasswordOffice = $result.MDP

    $secureStringPwd = $PasswordOffice | ConvertTo-SecureString -AsPlainText -Force 

    $creds = New-Object System.Management.Automation.PSCredential -ArgumentList $LoginOffice, $secureStringPwd

    Connect-MsolService -Credential $creds

    # Création des comptes

    ## init des variables


    new-MSolUSER -DisplayNAme $($Prenom + $Nom) -FirstName $Prenom -LastName $Nom -UserPrincipalName $StagMAil -Password $StagmdpTemp
}