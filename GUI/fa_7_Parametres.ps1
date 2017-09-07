# Chargement du pilote .NET pour MySQL 
#[system.reflection.Assembly]::LoadWithPartialName("MySql.Data")
Add-Type -Path '../libs/MySql.Data.dll'
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Initialisation des variables  
$serv = "192.168.1.2" # Addresse du serveur
$port = "3306" # Port de connexion (3306 par dÃ©faut)
$user = "vgroup"  # nom d'utilisateur pour la connexion
$password = "vgrouproxx" # mot de passe
$db = "projet_eni" # nom de la base de donnÃ©e



# Creation de l'instance, connexion Ã  la base de donnÃ©es  
$mysql = New-Object MySql.Data.MySqlClient.MySqlConnection("server=" + $serv + ";port=" + $port + ";uid=" + $user + ";pwd=" + $password + ";database=" + $db + ";Pooling=False")  
echo $mysql
$mysql.Open()
#

#return $DataSet.Tables[0]


SQLRequest ("SELECT * FROM formation;")

$result.Rows[0].nom

$mysql.Close()


Function MakeForm {
$ListForm = New-Object System.Windows.Forms.Form
$ListForm.Text = "Paramétrage"
$ListForm.Size = New-Object System.Drawing.Size(1000,700)
$ListForm.StartPosition = "CenterScreen"
$ListForm.TopMost = $True

$ButtonADAdmin = New-Object System.Windows.Forms.Button
$ButtonADAdmin.Location = New-Object System.Drawing.Point(40,40)
$ButtonADAdmin.Size = New-Object System.Drawing.Size(200,50)
$ButtonADAdmin.Text = "Active Directory administratif"
$ButtonADAdmin.Add_Click({makeMenuAd})

$ButtonPlateformes = New-Object System.Windows.Forms.Button
$ButtonPlateformes.Location = New-Object System.Drawing.Point(40,100)
$ButtonPlateformes.Size = New-Object System.Drawing.Size(200,50)
$ButtonPlateformes.Text = "Plateformes"
$ButtonPlateformes.Add_Click({makeMenuPlateformes})

$ButtonDefProfils = New-Object System.Windows.Forms.Button
$ButtonDefProfils.Location = New-Object System.Drawing.Point(40,160)
$ButtonDefProfils.Size = New-Object System.Drawing.Size(200,50)
$ButtonDefProfils.Text = "Définition des profils"
$ButtonDefProfils.Add_Click({makeMenuDefProfils})

$ButtonAssProfils = New-Object System.Windows.Forms.Button
$ButtonAssProfils.Location = New-Object System.Drawing.Point(40,220)
$ButtonAssProfils.Size = New-Object System.Drawing.Size(200,50)
$ButtonAssProfils.Text = "Assignation des profils"
$ButtonAssProfils.Add_Click({makeMenuAssProfils})

$ButtonRetour = New-Object System.Windows.Forms.Button
$ButtonRetour.Location = New-Object System.Drawing.Point(30,580)
$ButtonRetour.Size = New-Object System.Drawing.Size(150,60)
$ButtonRetour.Text = "Retour"

$ListBoxMenu = New-Object System.Windows.Forms.ListBox 
$ListBoxMenu.Location = New-Object System.Drawing.Size(30,30) 
$ListBoxMenu.Size = New-Object System.Drawing.Size(220,20) 
$ListBoxMenu.Height = 530

$ListBoxMenuDeux = New-Object System.Windows.Forms.ListBox 
$ListBoxMenuDeux.Location = New-Object System.Drawing.Size(250,30) 
$ListBoxMenuDeux.Size = New-Object System.Drawing.Size(220,20) 
$ListBoxMenuDeux.Height = 530
$ListBoxMenuDeux.Text = "plop ;-)"

$ListBoxMenuTrois = New-Object System.Windows.Forms.ListBox 
$ListBoxMenuTrois.Location = New-Object System.Drawing.Size(470,30) 
$ListBoxMenuTrois.Size = New-Object System.Drawing.Size(470,20) 
$ListBoxMenuTrois.Height = 530
$ListBoxMenuTrois.Text = "plop ;-)"

$ListForm.Controls.Add($ButtonADAdmin) 
$ListForm.Controls.Add($ButtonPlateformes)
$ListForm.Controls.Add($ButtonDefProfils)
$ListForm.Controls.Add($ButtonAssProfils)
$ListForm.Controls.Add($ButtonRetour)
$ListForm.Controls.Add($ListBoxMenu)
$ListForm.Controls.Add($ListBoxMenuDeux)
$ListForm.Controls.Add($ListBoxMenuTrois)

# Afficher la fenetre
$ListForm.ShowDialog()
}


Function MakeMenuAd {

$FormLabelDA = New-Object System.Windows.Forms.Label
$FormLabelDA.Location = New-Object System.Drawing.Point(250,31)
$FormLabelDA.Size = New-Object System.Drawing.Size(5,700)
$FormLabelDA.Text = " "

$FormLabelTextAd1 = New-Object System.Windows.Forms.Label
$FormLabelTextAd1.Location = New-Object System.Drawing.Point(300,230)
$FormLabelTextAd1.Size = New-Object System.Drawing.Size(200,20)
$FormLabelTextAd1.Text = "Adresse IP ou nom du serveur : "
$FormLabelTextAd1.Visible = $true

$FormLabelTextAd2 = New-Object System.Windows.Forms.Label
$FormLabelTextAd2.Location = New-Object System.Drawing.Point(300,270)
$FormLabelTextAd2.Size = New-Object System.Drawing.Size(200,20)
$FormLabelTextAd2.Text = "Nom d'utilisateur : "
$FormLabelTextAd2.Visible = $true

$FormLabelTextAd3 = New-Object System.Windows.Forms.Label
$FormLabelTextAd3.Location = New-Object System.Drawing.Point(300,310)
$FormLabelTextAd3.Size = New-Object System.Drawing.Size(200,20)
$FormLabelTextAd3.Text = "Mot de passe : "
$FormLabelTextAd3.Visible = $true

$TextBoxAd1 = New-Object System.Windows.Forms.TextBox
$TextBoxAd1.Location = New-Object System.Drawing.Point(600,230)
$TextBoxAd1.Size = New-Object System.Drawing.Size(200,30)
$TextBoxAd1.Height = 100
$TextBoxAd1.Text = ""
$TextBoxAd1.Visible = $true

$TextBoxAd2 = New-Object System.Windows.Forms.TextBox
$TextBoxAd2.Location = New-Object System.Drawing.Point(600,270)
$TextBoxAd2.Size = New-Object System.Drawing.Size(200,30)
$TextBoxAd2.Height = 100
$TextBoxAd2.Text = ""
$TextBoxAd2.Visible = $true

$TextBoxAd3 = New-Object System.Windows.Forms.TextBox
$TextBoxAd3.Location = New-Object System.Drawing.Point(600,310)
$TextBoxAd3.Size = New-Object System.Drawing.Size(200,30)
$TextBoxAd3.Height = 100
$TextBoxAd3.Text = ""
$TextBoxAd3.Visible = $true

$ListBoxMenuTrois.Controls.clear();
$ListBoxMenuTrois.Controls.Add($TextBoxAd1)
$ListBoxMenuTrois.Controls.Add($TextBoxAd2)
$ListBoxMenuTrois.Controls.Add($TextBoxAd3)
$ListBoxMenuTrois.Controls.Add($FormLabelTextAd1)
$ListBoxMenuTrois.Controls.Add($FormLabelTextAd2)
$ListBoxMenuTrois.Controls.Add($FormLabelTextAd3)
$ListBoxMenuTrois.Controls.Add($FormLabelDA)

}


Function MakeMenuPlateformes {

# Active Directory

$FormLabelTextPlateformeAdTitre = New-Object System.Windows.Forms.Label
$FormLabelTextPlateformeAdTitre.Location = New-Object System.Drawing.Point(150,10)
$FormLabelTextPlateformeAdTitre.Size = New-Object System.Drawing.Size(200,20)
$FormLabelTextPlateformeAdTitre.Text = "Active Directory"
$FormLabelTextPlateformeAdTitre.Visible = $true

$FormLabelTextPlateformeAdIP = New-Object System.Windows.Forms.Label
$FormLabelTextPlateformeAdIP.Location = New-Object System.Drawing.Point(10,50)
$FormLabelTextPlateformeAdIP.Size = New-Object System.Drawing.Size(200,20)
$FormLabelTextPlateformeAdIP.Text = "Adresse IP ou nom du serveur : "
$FormLabelTextPlateformeAdIP.Visible = $true

$FormLabelTextPlateformeAdUser = New-Object System.Windows.Forms.Label
$FormLabelTextPlateformeAdUser.Location = New-Object System.Drawing.Point(10,90)
$FormLabelTextPlateformeAdUser.Size = New-Object System.Drawing.Size(200,20)
$FormLabelTextPlateformeAdUser.Text = "Nom d'utilisateur : "
$FormLabelTextPlateformeAdUser.Visible = $true

$FormLabelTextPlateformeAdMDP = New-Object System.Windows.Forms.Label
$FormLabelTextPlateformeAdMDP.Location = New-Object System.Drawing.Point(10,130)
$FormLabelTextPlateformeAdMDP.Size = New-Object System.Drawing.Size(200,20)
$FormLabelTextPlateformeAdMDP.Text = "Mot de passe : "
$FormLabelTextPlateformeAdMDP.Visible = $true

$FormLabelTextPlateformeAdRegex = New-Object System.Windows.Forms.Label
$FormLabelTextPlateformeAdRegex.Location = New-Object System.Drawing.Point(10,170)
$FormLabelTextPlateformeAdRegex.Size = New-Object System.Drawing.Size(200,30)
$FormLabelTextPlateformeAdRegex.Text = "Expression régulière de génération du mot de passe : "
$FormLabelTextPlateformeAdRegex.Visible = $true

$TextBoxPlateformeAdIP = New-Object System.Windows.Forms.TextBox
$TextBoxPlateformeAdIP.Location = New-Object System.Drawing.Point(220,50)
$TextBoxPlateformeAdIP.Size = New-Object System.Drawing.Size(200,30)
$TextBoxPlateformeAdIP.Height = 100
$TextBoxPlateformeAdIP.Text = ""
$TextBoxPlateformeAdIP.Visible = $true

$TextBoxPlateformeAdUser = New-Object System.Windows.Forms.TextBox
$TextBoxPlateformeAdUser.Location = New-Object System.Drawing.Point(220,90)
$TextBoxPlateformeAdUser.Size = New-Object System.Drawing.Size(200,30)
$TextBoxPlateformeAdUser.Height = 100
$TextBoxPlateformeAdUser.Text = ""
$TextBoxPlateformeAdUser.Visible = $true

$TextBoxPlateformeAdMDP = New-Object System.Windows.Forms.TextBox
$TextBoxPlateformeAdMDP.Location = New-Object System.Drawing.Point(220,130)
$TextBoxPlateformeAdMDP.Size = New-Object System.Drawing.Size(200,30)
$TextBoxPlateformeAdMDP.Height = 100
$TextBoxPlateformeAdMDP.Text = ""
$TextBoxPlateformeAdMDP.Visible = $true

$TextBoxPlateformeAdRegex = New-Object System.Windows.Forms.TextBox
$TextBoxPlateformeAdRegex.Location = New-Object System.Drawing.Point(220,170)
$TextBoxPlateformeAdRegex.Size = New-Object System.Drawing.Size(200,30)
$TextBoxPlateformeAdRegex.Height = 100
$TextBoxPlateformeAdRegex.Text = ""
$TextBoxPlateformeAdRegex.Visible = $true

# Kivuto

$FormLabelTextPlateformeKivutoTitre = New-Object System.Windows.Forms.Label
$FormLabelTextPlateformeKivutoTitre.Location = New-Object System.Drawing.Point(150,220)
$FormLabelTextPlateformeKivutoTitre.Size = New-Object System.Drawing.Size(200,20)
$FormLabelTextPlateformeKivutoTitre.Text = "Kivuto"
$FormLabelTextPlateformeKivutoTitre.Visible = $true

$FormLabelTextPlateformeKivutoIP = New-Object System.Windows.Forms.Label
$FormLabelTextPlateformeKivutoIP.Location = New-Object System.Drawing.Point(10,260)
$FormLabelTextPlateformeKivutoIP.Size = New-Object System.Drawing.Size(200,20)
$FormLabelTextPlateformeKivutoIP.Text = "Adresse IP ou nom du serveur : "
$FormLabelTextPlateformeKivutoIP.Visible = $true

$FormLabelTextPlateformeKivutoUser = New-Object System.Windows.Forms.Label
$FormLabelTextPlateformeKivutoUser.Location = New-Object System.Drawing.Point(10,300)
$FormLabelTextPlateformeKivutoUser.Size = New-Object System.Drawing.Size(200,20)
$FormLabelTextPlateformeKivutoUser.Text = "Nom d'utilisateur : "
$FormLabelTextPlateformeKivutoUser.Visible = $true

$FormLabelTextPlateformeKivutoMDP = New-Object System.Windows.Forms.Label
$FormLabelTextPlateformeKivutoMDP.Location = New-Object System.Drawing.Point(10,340)
$FormLabelTextPlateformeKivutoMDP.Size = New-Object System.Drawing.Size(200,20)
$FormLabelTextPlateformeKivutoMDP.Text = "Mot de passe : "
$FormLabelTextPlateformeKivutoMDP.Visible = $true

$FormLabelTextPlateformeKivutoRegex = New-Object System.Windows.Forms.Label
$FormLabelTextPlateformeKivutoRegex.Location = New-Object System.Drawing.Point(10,380)
$FormLabelTextPlateformeKivutoRegex.Size = New-Object System.Drawing.Size(200,30)
$FormLabelTextPlateformeKivutoRegex.Text = "Expression régulière de génération du mot de passe : "
$FormLabelTextPlateformeKivutoRegex.Visible = $true

$TextBoxPlateformeKivutoIP = New-Object System.Windows.Forms.TextBox
$TextBoxPlateformeKivutoIP.Location = New-Object System.Drawing.Point(220,260)
$TextBoxPlateformeKivutoIP.Size = New-Object System.Drawing.Size(200,30)
$TextBoxPlateformeKivutoIP.Height = 100
$TextBoxPlateformeKivutoIP.Text = ""
$TextBoxPlateformeKivutoIP.Visible = $true

$TextBoxPlateformeKivutoUser = New-Object System.Windows.Forms.TextBox
$TextBoxPlateformeKivutoUser.Location = New-Object System.Drawing.Point(220,300)
$TextBoxPlateformeKivutoUser.Size = New-Object System.Drawing.Size(200,30)
$TextBoxPlateformeKivutoUser.Height = 100
$TextBoxPlateformeKivutoUser.Text = ""
$TextBoxPlateformeKivutoUser.Visible = $true

$TextBoxPlateformeKivutoMDP = New-Object System.Windows.Forms.TextBox
$TextBoxPlateformeKivutoMDP.Location = New-Object System.Drawing.Point(220,340)
$TextBoxPlateformeKivutoMDP.Size = New-Object System.Drawing.Size(200,30)
$TextBoxPlateformeKivutoMDP.Height = 100
$TextBoxPlateformeKivutoMDP.Text = ""
$TextBoxPlateformeKivutoMDP.Visible = $true

$TextBoxPlateformeKivutoRegex = New-Object System.Windows.Forms.TextBox
$TextBoxPlateformeKivutoRegex.Location = New-Object System.Drawing.Point(220,380)
$TextBoxPlateformeKivutoRegex.Size = New-Object System.Drawing.Size(200,30)
$TextBoxPlateformeKivutoRegex.Height = 100
$TextBoxPlateformeKivutoRegex.Text = ""
$TextBoxPlateformeKivutoRegex.Visible = $true

# 7Speaking

$FormLabelTextPlateforme7SpeakingTitre = New-Object System.Windows.Forms.Label
$FormLabelTextPlateforme7SpeakingTitre.Location = New-Object System.Drawing.Point(150,430)
$FormLabelTextPlateforme7SpeakingTitre.Size = New-Object System.Drawing.Size(200,20)
$FormLabelTextPlateforme7SpeakingTitre.Text = "7 Speaking"
$FormLabelTextPlateforme7SpeakingTitre.Visible = $true

$FormLabelTextPlateforme7SpeakingMail = New-Object System.Windows.Forms.Label
$FormLabelTextPlateforme7SpeakingMail.Location = New-Object System.Drawing.Point(10,470)
$FormLabelTextPlateforme7SpeakingMail.Size = New-Object System.Drawing.Size(200,30)
$FormLabelTextPlateforme7SpeakingMail.Text = "adresse mail destinataire : "
$FormLabelTextPlateforme7SpeakingMail.Visible = $true

$TextBoxPlateforme7SpeakingMail = New-Object System.Windows.Forms.TextBox
$TextBoxPlateforme7SpeakingMail.Location = New-Object System.Drawing.Point(220,470)
$TextBoxPlateforme7SpeakingMail.Size = New-Object System.Drawing.Size(200,30)
$TextBoxPlateforme7SpeakingMail.Height = 100
$TextBoxPlateforme7SpeakingMail.Text = ""
$TextBoxPlateforme7SpeakingMail.Visible = $true

# cisco

$FormLabelTextPlateformeCiscoTitre = New-Object System.Windows.Forms.Label
$FormLabelTextPlateformeCiscoTitre.Location = New-Object System.Drawing.Point(150,520)
$FormLabelTextPlateformeCiscoTitre.Size = New-Object System.Drawing.Size(200,20)
$FormLabelTextPlateformeCiscoTitre.Text = "Cisco"
$FormLabelTextPlateformeCiscoTitre.Visible = $true

$FormLabelTextPlateformeCiscoMail = New-Object System.Windows.Forms.Label
$FormLabelTextPlateformeCiscoMail.Location = New-Object System.Drawing.Point(10,560)
$FormLabelTextPlateformeCiscoMail.Size = New-Object System.Drawing.Size(200,30)
$FormLabelTextPlateformeCiscoMail.Text = "adresse mail destinataire : "
$FormLabelTextPlateformeCiscoMail.Visible = $true

$TextBoxPlateformeCiscoMail = New-Object System.Windows.Forms.TextBox
$TextBoxPlateformeCiscoMail.Location = New-Object System.Drawing.Point(220,600)
$TextBoxPlateformeCiscoMail.Size = New-Object System.Drawing.Size(200,30)
$TextBoxPlateformeCiscoMail.Height = 100
$TextBoxPlateformeCiscoMail.Text = ""
$TextBoxPlateformeCiscoMail.Visible = $true

# MediaPlus

$FormLabelTextPlateformeMediaPTitre = New-Object System.Windows.Forms.Label
$FormLabelTextPlateformeMediaPTitre.Location = New-Object System.Drawing.Point(150,650)
$FormLabelTextPlateformeMediaPTitre.Size = New-Object System.Drawing.Size(200,20)
$FormLabelTextPlateformeMediaPTitre.Text = "Media Plus"
$FormLabelTextPlateformeMediaPTitre.Visible = $true

$FormLabelTextPlateformeMediaPIP = New-Object System.Windows.Forms.Label
$FormLabelTextPlateformeMediaPIP.Location = New-Object System.Drawing.Point(10,690)
$FormLabelTextPlateformeMediaPIP.Size = New-Object System.Drawing.Size(200,20)
$FormLabelTextPlateformeMediaPIP.Text = "Adresse IP ou nom du serveur : "
$FormLabelTextPlateformeMediaPIP.Visible = $true

$FormLabelTextPlateformeMediaPUser = New-Object System.Windows.Forms.Label
$FormLabelTextPlateformeMediaPUser.Location = New-Object System.Drawing.Point(10,730)
$FormLabelTextPlateformeMediaPUser.Size = New-Object System.Drawing.Size(200,20)
$FormLabelTextPlateformeMediaPUser.Text = "Nom d'utilisateur : "
$FormLabelTextPlateformeMediaPUser.Visible = $true

$FormLabelTextPlateformeMediaPMDP = New-Object System.Windows.Forms.Label
$FormLabelTextPlateformeMediaPMDP.Location = New-Object System.Drawing.Point(10,770)
$FormLabelTextPlateformeMediaPMDP.Size = New-Object System.Drawing.Size(200,20)
$FormLabelTextPlateformeMediaPMDP.Text = "Mot de passe : "
$FormLabelTextPlateformeMediaPMDP.Visible = $true

$FormLabelTextPlateformeMediaPRegex = New-Object System.Windows.Forms.Label
$FormLabelTextPlateformeMediaPRegex.Location = New-Object System.Drawing.Point(10,810)
$FormLabelTextPlateformeMediaPRegex.Size = New-Object System.Drawing.Size(200,30)
$FormLabelTextPlateformeMediaPRegex.Text = "Expression régulière de génération du mot de passe : "
$FormLabelTextPlateformeMediaPRegex.Visible = $true

$TextBoxPlateformeMediaPIP = New-Object System.Windows.Forms.TextBox
$TextBoxPlateformeMediaPIP.Location = New-Object System.Drawing.Point(220,690)
$TextBoxPlateformeMediaPIP.Size = New-Object System.Drawing.Size(200,30)
$TextBoxPlateformeMediaPIP.Height = 100
$TextBoxPlateformeMediaPIP.Text = ""
$TextBoxPlateformeMediaPIP.Visible = $true

$TextBoxPlateformeMediaPUser = New-Object System.Windows.Forms.TextBox
$TextBoxPlateformeMediaPUser.Location = New-Object System.Drawing.Point(220,730)
$TextBoxPlateformeMediaPUser.Size = New-Object System.Drawing.Size(200,30)
$TextBoxPlateformeMediaPUser.Height = 100
$TextBoxPlateformeMediaPUser.Text = ""
$TextBoxPlateformeMediaPUser.Visible = $true

$TextBoxPlateformeMediaPMDP = New-Object System.Windows.Forms.TextBox
$TextBoxPlateformeMediaPMDP.Location = New-Object System.Drawing.Point(220,770)
$TextBoxPlateformeMediaPMDP.Size = New-Object System.Drawing.Size(200,30)
$TextBoxPlateformeMediaPMDP.Height = 100
$TextBoxPlateformeMediaPMDP.Text = ""
$TextBoxPlateformeMediaPMDP.Visible = $true

$TextBoxPlateformeMediaPRegex = New-Object System.Windows.Forms.TextBox
$TextBoxPlateformeMediaPRegex.Location = New-Object System.Drawing.Point(220,810)
$TextBoxPlateformeMediaPRegex.Size = New-Object System.Drawing.Size(200,30)
$TextBoxPlateformeMediaPRegex.Height = 100
$TextBoxPlateformeMediaPRegex.Text = ""
$TextBoxPlateformeMediaPRegex.Visible = $true

$ListBoxMenuTrois.Controls.clear();
$ListBoxMenuTrois.Controls.Add($FormLabelTextPlateformeAdTitre)
$ListBoxMenuTrois.Controls.Add($FormLabelTextPlateformeAdIP)
$ListBoxMenuTrois.Controls.Add($FormLabelTextPlateformeAdUser)
$ListBoxMenuTrois.Controls.Add($FormLabelTextPlateformeAdMDP)
$ListBoxMenuTrois.Controls.Add($FormLabelTextPlateformeAdRegex)
$ListBoxMenuTrois.Controls.Add($TextBoxPlateformeAdIP)
$ListBoxMenuTrois.Controls.Add($TextBoxPlateformeAdUser)
$ListBoxMenuTrois.Controls.Add($TextBoxPlateformeAdMDP)
$ListBoxMenuTrois.Controls.Add($TextBoxPlateformeAdRegex)

$ListBoxMenuTrois.Controls.Add($FormLabelTextPlateformeKivutoTitre)
$ListBoxMenuTrois.Controls.Add($FormLabelTextPlateformeKivutoIP)
$ListBoxMenuTrois.Controls.Add($FormLabelTextPlateformeKivutoUser)
$ListBoxMenuTrois.Controls.Add($FormLabelTextPlateformeKivutoMDP)
$ListBoxMenuTrois.Controls.Add($FormLabelTextPlateformeKivutoRegex)
$ListBoxMenuTrois.Controls.Add($TextBoxPlateformeKivutoIP)
$ListBoxMenuTrois.Controls.Add($TextBoxPlateformeKivutoUser)
$ListBoxMenuTrois.Controls.Add($TextBoxPlateformeKivutoMDP)
$ListBoxMenuTrois.Controls.Add($TextBoxPlateformeKivutoRegex)

$ListBoxMenuTrois.Controls.Add($FormLabelTextPlateformeMediaPTitre)
$ListBoxMenuTrois.Controls.Add($FormLabelTextPlateformeMediaPIP)
$ListBoxMenuTrois.Controls.Add($FormLabelTextPlateformeMediaPUser)
$ListBoxMenuTrois.Controls.Add($FormLabelTextPlateformeMediaPMDP)
$ListBoxMenuTrois.Controls.Add($FormLabelTextPlateformeMediaPRegex)
$ListBoxMenuTrois.Controls.Add($TextBoxPlateformeMediaPIP)
$ListBoxMenuTrois.Controls.Add($TextBoxPlateformeMediaPUser)
$ListBoxMenuTrois.Controls.Add($TextBoxPlateformeMediaPMDP)
$ListBoxMenuTrois.Controls.Add($TextBoxPlateformeMediaPRegex)

$ListBoxMenuTrois.Controls.Add($FormLabelTextPlateforme7SpeakingTitre)
$ListBoxMenuTrois.Controls.Add($FormLabelTextPlateforme7SpeakingMail)
$ListBoxMenuTrois.Controls.Add($TextBoxPlateforme7SpeakingMail)

$ListBoxMenuTrois.Controls.Add($FormLabelTextPlateformeCiscoTitre)
$ListBoxMenuTrois.Controls.Add($FormLabelTextPlateformeCiscoMail)
$ListBoxMenuTrois.Controls.Add($TextBoxPlateformeCiscoMail)

}


Function MakeMenuDefProfils {

$FormLabelTextDefProfils1 = New-Object System.Windows.Forms.Label
$FormLabelTextDefProfils1.Location = New-Object System.Drawing.Point(300,220)
$FormLabelTextDefProfils1.Size = New-Object System.Drawing.Size(200,20)
$FormLabelTextDefProfils1.Text = "plop ;-)"
$FormLabelTextDefProfils1.Visible = $true

$ListBoxMenuTrois.Controls.clear();
$ListBoxMenuTrois.Controls.Add($FormLabelTextDefProfils1)

}


Function MakeMenuAssProfils {

$FormLabelTextAssProfils1 = New-Object System.Windows.Forms.Label
$FormLabelTextAssProfils1.Location = New-Object System.Drawing.Point(300,220)
$FormLabelTextAssProfils1.Size = New-Object System.Drawing.Size(200,20)
$FormLabelTextAssProfils1.Text = "plop ;-)"
$FormLabelTextAssProfils1.Visible = $true

$ListBoxMenuTrois.Controls.clear();
$ListBoxMenuTrois.Controls.Add($FormLabelTextAssProfils1)
}

makeForm