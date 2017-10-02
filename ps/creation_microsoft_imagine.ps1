function creation_microsoft_imagine
{
    # on vérifie que ce n'est pas la dernière exécution
    if ($vide -eq $NULL)
    {
        # Récupération des paramètres du domaine stagiaire ENI
        $result = makeRequest ("Select * FROM plateforme WHERE nom = 'active directory';")
        $LoginDomainStag = $result.identifiant
        $PasswordDomainStag = $result.MDP
        $NomDomainStag = $result.domaine + ":389"


        $SecPassDomainStag = $PasswordDomainStag | ConvertTo-SecureString -AsPlainText -Force 

        $creds = New-Object System.Management.Automation.PSCredential -ArgumentList $LoginDomainStag, $SecPassDomainStag

        Import-Module ActiveDirectory

        
        # Génération SAMAcount NAme
        $StagSAMAN = $($PrenomSSCaratSpec.ToLower() + "." + $NomSSCaratSpec.ToLower() + $annee)

        If ($StagSAMAN.length -ge 18) 
        {
            $StagSAMAN=$StagSAMAN.Substring(0,18) 
        }

        $GroupMicrosoftImagine = "Microsoft_Imagine"

        Add-ADGroupMember -identity $GroupMicrosoftImagine -Members $StagSAMAN -Server $NomDomainStag -Credential $creds
        $status = "OK"
        $action = "création"
        # on log ajoute les informations dans la base de données
        $timestamp = Get-Date -Format "yyyy-MM-dd hh:mm:ss"
        $reqinsertHist = "INSERT INTO projet_eni.historique (action, statut, timestamp, utilisateur, stagiaire, typeCompte, site, formation)"
        $reqinsertHist += " VALUES('" + $action + "', '" + $status + "', '" + $timestamp +"', '" + $ADusername + "', '" + $nom + " " + $prenom + "', '" + $plateformeBase +"', '" + $site + "', '" + $formation + "');"
        makeRequest $reqinsertHist
    }
}