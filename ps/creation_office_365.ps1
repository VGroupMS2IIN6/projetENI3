function creation_Office_365
{
    # on vérifie que ce n'est pas la dernière exécution
    if ($vide -eq $NULL -and $script:creationTotale -eq $true)
    {
       # connexion à Office 365

        $result = makeRequest ("Select * FROM plateforme WHERE nom = 'Office 365';")
        $LoginOffice = $result.identifiant
        $PasswordSecureOffice = $result.MDP
        $PasswordDomainStag = Dechiffrement $PasswordSecureOffice

        $secureStringPwd = $PasswordDomainStag | ConvertTo-SecureString -AsPlainText -Force 

        $creds = New-Object System.Management.Automation.PSCredential -ArgumentList $LoginOffice, $secureStringPwd

        Connect-MsolService -Credential $creds

        ## Pour démo uniquement
        ### Sélection du groupe pour démo ENI (JB)

        $email = $($script:PrenomSSCaratSpec.ToLower() + "." + $script:NomSSCaratSpec.ToLower() + $script:annee + "@gsc49.fr")
        $GroupId = Get-MsolGroup -SearchString "S_ENI_TEST"

        $O365usernew = new-MSolUSER -DisplayNAme $($script:Prenom + " " + $script:Nom) -FirstName $script:Prenom -LastName $script:Nom -UserPrincipalName $email -Password $script:password -UsageLocation "FR"

        ### Ajout du compte dans le groupe de sécurité pour démo ENI (JB)
        Add-MsolGroupMember -GroupObjectId $GroupId.ObjectId -GroupMemberType User -GroupMemberObjectId $O365usernew.ObjectId
        ##################################################################################

        # Set licence O365
        Set-MsolUserLicense -UserPrincipalName $email -AddLicenses "gsc49:EXCHANGESTANDARD_STUDENT"

        $status = "OK"
        $action = "création"
        # on log ajoute les informations dans la base de données
        $timestamp = Get-Date -Format "yyyy-MM-dd hh:mm:ss"
        $reqinsertHist = "INSERT INTO projet_eni.historique (action, statut, timestamp, utilisateur, stagiaire, typeCompte, site, formation)"
        $reqinsertHist += " VALUES('" + $action + "', '" + $status + "', '" + $timestamp +"', '" + $ADusername + "', '" + $script:NomSSCaratSpec + " " + $script:PrenomSSCaratSpec + "', '" + $script:plateformeBase +"', '" + $script:site + "', '" + $script:formation + "');"
        makeRequest $reqinsertHist
    }
}