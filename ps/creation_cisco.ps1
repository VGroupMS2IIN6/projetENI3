# fg_9.5_CreationComptesNetAcad_PS
function creation_cisco
{
    # on vérifie que ce n'est pas la dernière exécution
    if ($vide -eq $NULL)
    {
        # Init des variables paramètres

        # Récupération de l'adresse mail d'envoi pour cisco
        $result = makeRequest ("Select nom, mail FROM plateforme WHERE nom = 'cisco';")
        $mailCisco = $result.mail

        # Récupération de l'adresse du SMTP de l'ENI
        $result = SQLRequest ("Select nom, param FROM parametre WHERE nom = 'smtp_ip';")
        $IPSmtp = $result.param
        $result = SQLRequest ("Select nom, param FROM parametre WHERE nom = 'smtp_port';")
        $PortSmtp = $result.param
        $result = SQLRequest ("Select nom, param FROM parametre WHERE nom = 'smtp_expediteur';")
        $EmetteurSmtp = $result.param

        # Génération d'un CSV pour cisco
        Add-Content -Path ../temp/Cisco.csv  -Value '"Nom","Prenom","email","ID interne","Date debut de formation","duree"'  

        $stagiairesCisco = @(
        '"Adam","Bertram","abertram"'
        '"Joe","Jones","jjones"'
        '"Mary","Baker","mbaker"'
        )

        $stagiairesCisco | foreach { Add-Content -Path ../temp/Cisco.csv -Value $_ }
    }
    else
    {
        #Envoi du mail avec le CSV
        Send-MailMessage -From $EmetteurSmtp -To $mailCisco -Subject "ENI Ecole - Creation de comptes" -Body "Bonjour, veuillez trouver ci joint le fichier CSV contenant les comptes à créer" -Attachments "../temp/Cisco.csv" -SmtpServer $IPSmtp
        rm ../temp/Cisco.csv
    }
}