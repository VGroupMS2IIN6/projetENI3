function creation_office365
{
    # on vérifie que ce n'est pas la dernière exécution
    if ($vide -eq $NULL)
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
        $timestamp = Get-Date -Format "yyyy-MM-dd hh:mm:ss"
        $reqinsertHist = "INSERT INTO projet_eni.historique (action, statut, timestamp, utilisateur, stagiaire, typeCompte, site, formation)"
        $reqinsertHist += " VALUES('" + $action + "', '" + $status + "', '" + $timestamp +"', '" + $ADusername + "', '" + $nom + " " + $prenom + "', '" + $plateforme +"', '" + $site + "', '" + $formation + "');"
        makeRequest $reqinsertHist
    }
}