function creation_Office_365
{
    # on vérifie que ce n'est pas la dernière exécution
    if ($vide -eq $NULL)
    {
       # connexion à Office 365

        $result = makeRequest ("Select * FROM plateforme WHERE nom = 'Office 365';")
        $LoginOffice = $result.identifiant
        $PasswordOffice = $result.MDP

        $secureStringPwd = $PasswordOffice | ConvertTo-SecureString -AsPlainText -Force 

        $creds = New-Object System.Management.Automation.PSCredential -ArgumentList $LoginOffice, $secureStringPwd

        Connect-MsolService -Credential $creds

        ## Pour démo uniquement
        ### Sélection du groupe pour démo ENI (JB)

        $email = $($PrenomSSCaratSpec.Substring(0,1).ToLower() + "." + $NomSSCaratSpec.ToLower() + $annee + "@gsc49.fr")
        $GroupId = Get-MsolGroup -SearchString "S_ENI_TEST"

        $O365usernew = new-MSolUSER -DisplayNAme $($Prenom + $Nom) -FirstName $Prenom -LastName $Nom -UserPrincipalName $email -Password $password -UsageLocation "FR"

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
        $reqinsertHist += " VALUES('" + $action + "', '" + $status + "', '" + $timestamp +"', '" + $ADusername + "', '" + $nom + " " + $prenom + "', '" + $plateformeBase +"', '" + $site + "', '" + $formation + "');"
        makeRequest $reqinsertHist
    }
}