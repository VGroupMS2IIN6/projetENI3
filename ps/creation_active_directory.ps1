# fg_9.1_CreationComptesAD_PS
function creation_active_directory
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

        # Génération du mot de passe temporaire

        # Génération SAMAcount NAme
        $StagSAMAN = $($PrenomSSCaratSpec.ToLower() + "." + $NomSSCaratSpec.ToLower() + $annee)

        If ($StagSAMAN.length -ge 18) 
        {
            $StagSAMAN=$StagSAMAN.Substring(0,18) 
        }

        # Génération de la Secure String pour le mdp stagiaire
        $SecPasswordStagiaire = $password | ConvertTo-SecureString -AsPlainText -Force 


        New-ADUser -Name $($Prenom + $Nom) -description $("Rentree " + $DebutFormation.Substring(6,4) + $DebutFormation.Substring(3,2) + $DebutFormation.Substring(0,2) + " IDCRM " + $CodeStagiaire)  -surname $Nom -GivenName $Prenom -SamAccountName $StagSAMAN -Server $NomDomainStag -AccountPassword $SecPasswordStagiaire -Credential $creds
        $status = "OK"
        $action = "création"
        # on log ajoute les informations dans la base de données
        $timestamp = Get-Date -Format "yyyy-MM-dd hh:mm:ss"
        $reqinsertHist = "INSERT INTO projet_eni.historique (action, statut, timestamp, utilisateur, stagiaire, typeCompte, site, formation)"
        $reqinsertHist += " VALUES('" + $action + "', '" + $status + "', '" + $timestamp +"', '" + $ADusername + "', '" + $nom + " " + $prenom + "', '" + $plateforme +"', '" + $site + "', '" + $formation + "');"
        makeRequest $reqinsertHist
    }
}