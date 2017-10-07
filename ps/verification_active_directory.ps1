#variables disponibles
#$Nom
#$NomSSCaratSpec
#$Prenom
#$PrenomSSCaratSpec
#$CodeStagiaire
#$DateNaissance
#$DebutFormation
#$FinFormation
#$Email
#$SamAccountName
#$formation
#$site
#$annee
#$domaine
#$password
#$creationTotale
#$creation

function verification_active_directory {
    $script:creationTotale = $true
    $script:creationAD = $true
    $result = makeRequest ("Select * FROM plateforme WHERE nom = 'active directory';")
    $LoginDomainStag = $result.identifiant
    $PasswordSecureDomainStag = $result.MDP
    $NomDomainStag = $result.domaine
    $NomDomainStagPort = $NomDomainStag + ":389"

    $PasswordDomainStag = Dechiffrement $PasswordSecureDomainStag 

    $SecPassDomainStag = $PasswordDomainStag | ConvertTo-SecureString -AsPlainText -Force 

    $creds = New-Object System.Management.Automation.PSCredential -ArgumentList $LoginDomainStag, $SecPassDomainStag

    Import-Module ActiveDirectory

    $sortie = $false


    while ($sortie -ne $true)
    {
        # Obtention du SAMAccountName
        $ADuser = get-aduser -identity $script:SamAccountName -Credential $creds -Properties * -Server $NomDomainStagPort

        # SamAccountName Existe dans l'AD stag ?
        if ($ADuser -eq $null -or $ADuser.SamAccountName -ne $script:SamAccountName )
        {
            $sortie = $true
        }
        else{
            # Vérification de l'ID du CRM
            ## Récupération du l'IdCRM de l'AD
            $ADuser | select description
            $IdCrmAD = $ADuser.description.tostring().split()[3]

            # Test si l'ID du CRM n'existe pas dans l'AD
            # Si'il n'existe pas : demande s'il faut poursuivre la création
            if ($IdCrmAD.length -eq 0){
                $a = new-object -comobject wscript.shell
                #on demande si il faut créer quand même
                $intAnswer = $a.popup("Un stagiaire nommé " + $script:prenom + " "+ $script:nom.toupper() +" semble déjà exister. Souhaitez-vous le créer quand même ?", `
                0,"Alerte",4)
                #si créer quand même
                If ($intAnswer -eq 6) {
                    increment
                }
                else
                {
                    $sortie = $true
                    $script:creationTotale = $false
                    $script:creationAD = $false
                }
            }
            else
            {
                if ($IdCrmAD -eq $CodeStagiaire)
                {
                    #si l'ID CRM est identique au code stagiaire
                    $sortie = $true
                    $script:creationTotale = $true
                    $script:creationAD = $false
                }
                else
                {
                    # si l'ID CRM et différent
                    increment
                }
            }
        }
    }
}

function increment
{
    if ($script:SamAccountName -match '[A-Za-z][0-9]{4}$'){
        # SamAccountName sans incrément
        $script:SamAccountName = $script:SamAccountName + "1"
        $script:UserPrincipalName = $script:PrenomSSCaratSpec + "." + $script:NomSSCaratSpec + $script:annee + "1@" + $NomDomainStag
    }
    elseif($script:SamAccountName -match '[A-Za-z][0-9]{5}$'){
        # SamAccountName avec incrément sur 1 digit
        $strIncr = $script:SamAccountName.Substring($script:SamAccountName.Length - 1, 1)
        $increment = [int]$strIncr
        $increment++
        $SamAccountName_sansIcrem = $script:SamAccountName.Substring(0,($script:SamAccountName.Length - 1))
        $script:SamAccountName = $SamAccountName_sansIcrem + $increment
        $script:UserPrincipalName = $script:PrenomSSCaratSpec + "." + $script:NomSSCaratSpec + $script:annee + $increment + "@" + $NomDomainStag
    }
    elseif($script:SamAccountName -match '[A-Za-z][0-9]{6}$'){
        # SamAccountName avec incrément sur 2 digits
        $strIncr = $script:SamAccountName.Substring($script:SamAccountName.Length - 2, 2)
        $increment = [int] $strIncr
        $increment++
        $SamAccountName_sansIcrem = $script:SamAccountName.Substring(0,($script:SamAccountName.Length - 2))
        $script:SamAccountName = $SamAccountName_sansIcrem + $increment
        $script:UserPrincipalName = $script:PrenomSSCaratSpec + "." + $script:NomSSCaratSpec + $script:annee + $increment + "@" + $NomDomainStag
    }
}