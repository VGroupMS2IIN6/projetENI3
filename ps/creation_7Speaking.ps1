# fg_9.5_CreationComptes7Speaking_PS
function creation_7speaking
{
    # on vérifie que ce n'est pas la dernière exécution
    if ($vide -eq $NULL)
    {
        # Init des variables paramètres

        # Récupération de l'adresse mail d'envoi à 7Speaking
        $result = makeRequest ("Select nom, mail FROM plateforme WHERE nom = '7Speaking';")
        $mail7Speaking = $result.mail

        # Récupération de l'adresse du SMTP de l'ENI
        $result = makeRequest ("Select nom, param FROM parametre WHERE nom = 'smtp_ip';")
        $IPSmtp = $result.param
        $result = makeRequest ("Select nom, param FROM parametre WHERE nom = 'smtp_port';")
        $PortSmtp = $result.param
        $result = makeRequest ("Select nom, param FROM parametre WHERE nom = 'smtp_expediteur';")
        $EmetteurSmtp = $result.param

        # Génération d'un CSV pour 7Speaking
        Add-Content -Path ../temp/7Speaking.csv  -Value '"Nom","Prenom","email","ID interne","Date debut de formation","duree"'  

          $stagiaires7Sspeaking = @(

          '"Adam","Bertram","abertram"'
          '"Joe","Jones","jjones"'
          '"Mary","Baker","mbaker"'

          )

          $stagiaires7Sspeaking | foreach { Add-Content -Path ../temp/7Speaking.csv -Value $_ }
    }
    else
    {
        #Envoi du mail avec le CSV
        Send-MailMessage -From $EmetteurSmtp -To $mail7Speaking -Subject "ENI Ecole - Creation de comptes" -Body "Bonjour, veuillez trouver ci joint le fichier CSV contenant les comptes à créer" -Attachments "../temp/7Speaking.csv" -SmtpServer $IPSmtp
        rm ../temp/7Speaking.csv
    }
}