# fg_9.5_CreationComptes7Speaking_PS
function creation_7speaking
{
    # on vérifie que ce n'est pas la dernière exécution
    if ($vide -eq $NULL)
    {
        # Génération d'un CSV pour 7Speaking
        # on vérifie que le fichier n'existe pas déjà
        $fileExist = test-path ../temp/7speaking.csv
        if ($fileExist -eq $false)
        {
            Add-Content -Path ../temp/7speaking.csv  -Value '"Nom","Prenom","email","ID interne","Date debut de formation","duree"'  
        }

        $login = $($PrenomSSCaratSpec.Substring(0,1).ToLower() + $NomSSCaratSpec.ToLower())
        $duree = $FinFormation.Substring(6,4) - $DebutFormation.Substring(6,4)

        $stagiaires7Sspeaking = @(
            "'" + $nom + "','" + $prenom + "','" + $login + "'" + $CodeStagiaire + "','" + $DebutFormation + "','" + $duree + "'"
        )

          $stagiaires7Sspeaking | foreach { Add-Content -Path ../temp/7speaking.csv -Value $_ }
    }
    else
    {
        # on vérifie l'existence d'un CSV
        $fileExist = test-path ../temp/7speaking.csv
        if ($fileExist -eq $true)
        {
            $result = makeRequest ("Select nom, mail FROM plateforme WHERE nom = '7Speaking';")
            $mail7Speaking = $result.mail

            # Récupération de l'adresse du SMTP de l'ENI
            $result = makeRequest ("Select nom, param FROM parametres WHERE nom = 'smtp_ip';")
            $IPSmtp = $result.param
            $result = makeRequest ("Select nom, param FROM parametres WHERE nom = 'smtp_port';")
            $PortSmtp = $result.param
            $result = makeRequest ("Select nom, param FROM parametres WHERE nom = 'smtp_expediteur';")
            $EmetteurSmtp = $result.param

            #Conversion du CSV en unicode
            Get-Content ..\temp\7speaking.csv -encoding string | Out-File -FilePath ..\temp\creation_7speaking.csv -Encoding Unicode
            rm ../temp/7speaking.csv
            #Envoi du mail avec le CSV
            Send-MailMessage -From $EmetteurSmtp -To $mail7Speaking -Subject "ENI Ecole - Creation de comptes 7Speaking" -Body "Bonjour, veuillez trouver ci joint le fichier CSV contenant les comptes 7Speaking" -Attachments "../temp/creation_7speaking.csv" -SmtpServer $IPSmtp
            rm ../temp/creation_7speaking.csv
        }
    }
}