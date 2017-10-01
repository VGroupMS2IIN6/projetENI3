﻿# fg_9.5_CreationComptesNetAcad_PS
function creation_cisco
{
    # on vérifie que ce n'est pas la dernière exécution
    if ($vide -eq $NULL)
    {

        # on vérifie que le fichier n'existe pas déjà
        $fileExist = test-path ../temp/cisco.csv
        if ($fileExist -eq $false)
        {
            # Génération d'un CSV pour cisco
            Add-Content -Path ../temp/cisco.csv  -Value '"Nom","Prenom","email","ID interne","Date debut de formation","duree"'  
        }
        $login = $($PrenomSSCaratSpec.Substring(0,1).ToLower() + $NomSSCaratSpec.ToLower())

        $stagiairesCisco = @(
        "'" + $nom + "','" + $prenom + "','" + $login + "'"
        )

        $stagiairesCisco | foreach { Add-Content -Path ../temp/cisco.csv -Value $_ }
    }
    else
    {
        # on vérifie l'existence d'un CSV
        $fileExist = test-path ../temp/cisco.csv
        if ($fileExist -eq $true)
        {
            # Récupération de l'adresse mail d'envoi pour cisco
            $result = makeRequest ("Select nom, mail FROM plateforme WHERE nom = 'cisco';")
            $mailCisco = $result.mail

            # Récupération de l'adresse du SMTP de l'ENI
            $result = makeRequest ("Select nom, param FROM parametres WHERE nom = 'smtp_ip';")
            $IPSmtp = $result.param
            $result = makeRequest ("Select nom, param FROM parametres WHERE nom = 'smtp_port';")
            $PortSmtp = $result.param
            $result = makeRequest ("Select nom, param FROM parametres WHERE nom = 'smtp_expediteur';")
            $EmetteurSmtp = $result.param

            #Conversion du CSV en unicode
            Get-Content ..\temp\cisco.csv -encoding string | Out-File -FilePath ..\temp\creation_cisco.csv -Encoding Unicode
            rm ../temp/cisco.csv
            #Envoi du mail avec le CSV
            Send-MailMessage -From $EmetteurSmtp -To $mailCisco -Subject "ENI Ecole - Creation de comptes Cisco" -Body "Bonjour, veuillez trouver ci joint le fichier CSV contenant les comptes Cisco" -Attachments "../temp/creation_cisco.csv" -SmtpServer $IPSmtp
            rm ../temp/creation_cisco.csv
        }
    }
}