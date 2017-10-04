function creation_Office_365
{
    # on vérifie que ce n'est pas la dernière exécution
    if ($vide -eq $NULL)
    {
        $Mail = "testENI1@campus-gscls.com"
       
        # connexion à Office 365

        $result = makeRequest ("Select * FROM plateforme WHERE nom = 'Office 365';")
        $LoginOffice = $result.identifiant
        $PasswordOffice = $result.MDP

        #### DEBUG
        $LoginOffice = "adminENI@gsc49.fr"
        $PasswordOffice = "vgrouproxx@1"

        $secureStringPwd = $PasswordOffice | ConvertTo-SecureString -AsPlainText -Force 

        $creds = New-Object System.Management.Automation.PSCredential -ArgumentList $LoginOffice, $secureStringPwd

        Connect-MsolService -Credential $creds

        # Création des comptes

        ## init des variables
        $SecPasswordStagiaire = $password | ConvertTo-SecureString -AsPlainText -Force


        ## Pour démo uniquement
        ### Sélection du groupe pour démo ENI (JB)
        $GroupId = Get-MsolGroup -SearchString "S_ENI_TEST"

        $O365usernew = new-MSolUSER -DisplayNAme $($Prenom + $Nom) -FirstName $Prenom -LastName $Nom -UserPrincipalName $StagMAil -Password $SecPasswordStagiaire

        ## Pour démo uniquement
        ### Ajout du compte dans le groupe de sécurité pour démo ENI (JB)
        Add-MsolGroupMember -GroupObjectId $GroupId.ObjectId -GroupMemberType User -GroupMemberObjectId $O365usernew.ObjectId

        $status = "OK"
        $action = "création"
        # on log ajoute les informations dans la base de données
        $timestamp = Get-Date -Format "yyyy-MM-dd hh:mm:ss"
        $reqinsertHist = "INSERT INTO projet_eni.historique (action, statut, timestamp, utilisateur, stagiaire, typeCompte, site, formation)"
        $reqinsertHist += " VALUES('" + $action + "', '" + $status + "', '" + $timestamp +"', '" + $ADusername + "', '" + $nom + " " + $prenom + "', '" + $plateformeBase +"', '" + $site + "', '" + $formation + "');"
        makeRequest $reqinsertHist
    }
}