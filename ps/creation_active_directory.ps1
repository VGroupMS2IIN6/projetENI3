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
        $StagPassTemp = . "..\ps\fg_3-0_GenerationMdpTemp_PS.ps1" $Prenom $Nom $Naissance

        # Génération SAMAcount NAme
        $StagSAMAN = $($Prenom.Substring(0,1).ToLower() + $Nom.ToLower())

        If ($StagSAMAN.length -ge 18) 
        {
            $StagSAMAN=$StagSAMAN.Substring(0,18) 
        }

        # Génération de la Secure String pour le mdp stagiaire
        $SecStagPassTemp = $StagPassTemp | ConvertTo-SecureString -AsPlainText -Force 

        echo $StagSAMAN

        New-ADUser -Name $($Prenom + $Nom) -surname $Nom -GivenName $Prenom -SamAccountName $StagSAMAN -Server $NomDomainStag -AccountPassword $SecStagPassTemp -Credential $creds
    }
}