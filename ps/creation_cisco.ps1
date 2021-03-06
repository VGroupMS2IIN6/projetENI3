﻿# fg_9.5_CreationComptesNetAcad_PS
function creation_cisco
{
    # on vérifie que ce n'est pas la dernière exécution
    if ($vide -eq $NULL -and $script:creationTotale -eq $true)
    {

        # on vérifie que le fichier n'existe pas déjà
        $fileExist = test-path ../temp/cisco.csv
        if ($fileExist -eq $false)
        {
            # Génération d'un CSV pour cisco
            Add-Content -Path ../temp/cisco.csv  -Value '"Nom","Prenom","email"'
        }
        
        $stagiairesCisco = @(
        "'" + $nom + "','" + $prenom + "','" + $Email + "'"
        )

        $stagiairesCisco | foreach { Add-Content -Path ../temp/cisco.csv -Value $_ }
        $status = "OK"
        $action = "création"
        # on log ajoute les informations dans la base de données
        $timestamp = Get-Date -Format "yyyy-MM-dd hh:mm:ss"
        $reqinsertHist = "INSERT INTO projet_eni.historique (action, statut, timestamp, utilisateur, stagiaire, typeCompte, site, formation)"
        $reqinsertHist += " VALUES('" + $action + "', '" + $status + "', '" + $timestamp +"', '" + $ADusername + "', '" + $script:NomSSCaratSpec + " " + $script:PrenomSSCaratSpec + "', '" + $script:plateformeBase +"', '" + $script:site + "', '" + $script:formation + "');"
        makeRequest $reqinsertHist
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