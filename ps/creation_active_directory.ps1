# fg_9.1_CreationComptesAD_PS
function creation_active_directory
{
    # on vérifie que ce n'est pas la dernière exécution
    if ($vide -eq $NULL -and $script:creationAD -eq $true)
    {
        # Récupération des paramètres du domaine stagiaire ENI
        $result = makeRequest ("Select * FROM plateforme WHERE nom = 'active directory';")
        $LoginDomainStag = $result.identifiant
        $PasswordSecureDomainStag = $result.MDP
        $NomDomainStag = $result.domaine
        $NomDomainStagPort = $NomDomainStag + ":389"

        $PasswordDomainStag = Dechiffrement $PasswordSecureDomainStag 

        $SecPassDomainStag = $PasswordDomainStag | ConvertTo-SecureString -AsPlainText -Force 

        $creds = New-Object System.Management.Automation.PSCredential -ArgumentList $LoginDomainStag, $SecPassDomainStag

        Import-Module ActiveDirectory

        # Génération de la Secure String pour le mdp stagiaire
        $PasswordStagiaireSecure = $password | ConvertTo-SecureString -AsPlainText -Force 
        $groupe = "GG_" + $formation + "_" + $site
        $description = "Rentree " + $DebutFormation.Substring(6,4) + $DebutFormation.Substring(3,2) + $DebutFormation.Substring(0,2) + " IDCRM " + $CodeStagiaire
        $name = $Prenom + $Nom
        $UserLDAP = 'CN=' + $prenom + $nom + ',CN=Users,DC=campus-eni,DC=ovh'
        New-ADUser -Name $name -description $description  -surname $Nom -GivenName $Prenom -SamAccountName $SamAccountName -Server $NomDomainStagPort -UserPrincipalName $UserPrincipalName -AccountPassword $PasswordStagiaireSecure -Credential $creds -PassThru | Enable-ADAccount
        Add-ADGroupMember -identity $groupe -Member $SamAccountName -Server $NomDomainStagPort -Credential $creds
        Move-ADObject $UserLDAP -TargetPath 'OU=ComptesUtilisateurs,DC=campus-eni,DC=ovh' -Server $NomDomainStagPort -Credential $creds
        $status = "OK"
        $action = "création"
        # on log ajoute les informations dans la base de données
        $timestamp = Get-Date -Format "yyyy-MM-dd hh:mm:ss"
        $reqinsertHist = "INSERT INTO projet_eni.historique (action, statut, timestamp, utilisateur, stagiaire, typeCompte, site, formation)"
        $reqinsertHist += " VALUES('" + $action + "', '" + $status + "', '" + $timestamp +"', '" + $ADusername + "', '" + $nom + " " + $prenom + "', '" + $plateformeBase +"', '" + $site + "', '" + $formation + "');"
        makeRequest $reqinsertHist
    }
}