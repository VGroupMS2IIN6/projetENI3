<#
Fonction : fg_10.0_Authentification _PSAuteur : JB
Entrées :
    - nom d’utilisateur (SAMAcountName)
    - mot de passe (saisit par l'utilisateur)
Dernière MAJ : 28/06/2017
#>

#[System.Windows.Forms.MessageBox]::Show($ADusername, "username")
#[System.Windows.Forms.MessageBox]::Show($ADpassword, "password")

# Récupération du nom de domaine du Groupe ENI

function controlUserCredentials
{
    $result = makeRequest ("Select nom, param FROM parametres WHERE nom = 'nom_domaine_ENI_Groupe';")
    $nomDomaineGroupeENI = $result.param

    $result = makeRequest ("Select count(login) exist FROM utilisateur WHERE login = '$ADusername';")
    $UserAppli = $result.exist

    if($UserAppli -eq 1)
        {
        Add-Type -AssemblyName System.DirectoryServices.AccountManagement
        $ct = [System.DirectoryServices.AccountManagement.ContextType]::Domain
        $pc = New-Object System.DirectoryServices.AccountManagement.PrincipalContext $ct,$nomDomaineGroupeENI
        if($pc.ValidateCredentials($ADusername,$ADpassword) -eq $true)
            {
            echo 'vrai'
            $global:return = 'vrai'
            }
        else
            {
            echo 'FAUX3'
            $global:return = 'faux'
            }
        }
    else
        {
        echo 'FAUX2'
        $global:return = 'faux'
        }
}

##### DEBUG
#$ADusername = "sartu"
#$ADpassword = "admin123@"
#[System.Windows.Forms.MessageBox]::Show($ADusername, "ADusername")
#[System.Windows.Forms.MessageBox]::Show($ADpassword, "ADpassword")

return $return