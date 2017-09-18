# Chargement du pilote .NET pour MySQL 
#[system.reflection.Assembly]::LoadWithPartialName("MySql.Data")
Add-Type -Path '..\libs\MySql.Data.dll'
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Initialisation des variables  
$serv = "192.168.0.1" # Addresse du serveur
$port = "3306" # Port de connexion (3306 par dÃ©faut)
$user = "vgroup"  # nom d'utilisateur pour la connexion
$password = "vgrouproxx" # mot de passe
$db = "projet_eni" # nom de la base de donnÃ©e

# Creation de l'instance, connexion Ã  la base de donnÃ©es  
$mysql = New-Object MySql.Data.MySqlClient.MySqlConnection("server=" + $serv + ";port=" + $port + ";uid=" + $user + ";pwd=" + $password + ";database=" + $db + ";Pooling=False")  
$mysql.Open()

MakeForm

$mysql.Close()

function MakeRequest($request) {
    $command = New-Object Mysql.Data.MysqlClient.MySqlCommand($request,$mysql)  
    $dataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($command)
    $dataSet = New-Object System.Data.DataSet
    $recordCount = $dataAdapter.Fill($dataSet, "data")
    $result = $dataSet.Tables["data"]
    return $result
}

function RetreiveRow($result, $field, $filter) {
    foreach($row in $result)
    {
        if($row.$field -eq $filter)
        {
            return $row
        }
    }
}

Function MakeForm {
    $ListForm = New-Object System.Windows.Forms.Form
    $ListForm.Text = "Paramétrage"
    $ListForm.Size = New-Object System.Drawing.Size(1000,700)
    $ListForm.StartPosition = "CenterScreen"
    #$ListForm.TopMost = $True

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
    $ListBoxMenuDeux.Location = New-Object System.Drawing.Size(255,30) 
    $ListBoxMenuDeux.Size = New-Object System.Drawing.Size(700,20) 
    $ListBoxMenuDeux.Height = 530
    $ListBoxMenuDeux.Text = "plop ;-)"

    $ListForm.Controls.Add($ButtonADAdmin) 
    $ListForm.Controls.Add($ButtonPlateformes)
    $ListForm.Controls.Add($ButtonDefProfils)
    $ListForm.Controls.Add($ButtonAssProfils)
    $ListForm.Controls.Add($ButtonRetour)
    $ListForm.Controls.Add($ListBoxMenu)
    $ListForm.Controls.Add($ListBoxMenuDeux)

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

    $ListBoxMenuDeux.Controls.clear();
    $ListBoxMenuDeux.Controls.Add($TextBoxAd1)
    $ListBoxMenuDeux.Controls.Add($TextBoxAd2)
    $ListBoxMenuDeux.Controls.Add($TextBoxAd3)
    $ListBoxMenuDeux.Controls.Add($FormLabelTextAd1)
    $ListBoxMenuDeux.Controls.Add($FormLabelTextAd2)
    $ListBoxMenuDeux.Controls.Add($FormLabelTextAd3)
    $ListBoxMenuDeux.Controls.Add($FormLabelDA)
}

Function MakeMenuPlateformes {

$plateformes = MakeRequest "SELECT * FROM plateforme;"

$ComboBoxPlateformes = New-Object System.Windows.Forms.ComboBox
$ComboBoxPlateformes.Location = New-Object System.Drawing.Point(10,10)
$ComboBoxPlateformes.Size = New-Object System.Drawing.Size(200,20)
$ComboBoxPlateformes.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$ComboBoxPlateformes.Items.AddRange($plateformes.nom)
$ComboBoxPlateformes.SelectedIndex = 0

$labelURL = New-Object System.Windows.Forms.Label
$labelURL.Location = New-Object System.Drawing.Point(10,50)
$labelURL.Size = New-Object System.Drawing.Size(200,20)
$labelURL.Text = "Adresse IP ou nom du serveur"
$labelURL.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes

$textBoxURL = New-Object System.Windows.Forms.TextBox
$textBoxURL.Name = "textBoxURL"
$textBoxURL.Location = New-Object System.Drawing.Point(220,50)
$textBoxURL.Size = New-Object System.Drawing.Size(200,20)
$textBoxURL.Height = 100

$labelMail = New-Object System.Windows.Forms.Label
$labelMail.Location = New-Object System.Drawing.Point(10,90)
$labelMail.Size = New-Object System.Drawing.Size(200,20)
$labelMail.Text = "Adresse mail destinataire"
$labelMail.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes

$textBoxMail = New-Object System.Windows.Forms.TextBox
$textBoxMail.Name = "textBoxMail"
$textBoxMail.Location = New-Object System.Drawing.Point(220,90)
$textBoxMail.Size = New-Object System.Drawing.Size(200,30)
$textBoxMail.Height = 100

$labelUser = New-Object System.Windows.Forms.Label
$labelUser.Location = New-Object System.Drawing.Point(10,130)
$labelUser.Size = New-Object System.Drawing.Size(200,20)
$labelUser.Text = "Nom d'utilisateur"
$labelUser.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes

$textBoxUser = New-Object System.Windows.Forms.TextBox
$textBoxUser.Name = "textBoxUser"
$textBoxUser.Location = New-Object System.Drawing.Point(220,130)
$textBoxUser.Size = New-Object System.Drawing.Size(200,30)
$textBoxUser.Height = 100

$labelMdp = New-Object System.Windows.Forms.Label
$labelMdp.Location = New-Object System.Drawing.Point(10,170)
$labelMdp.Size = New-Object System.Drawing.Size(200,20)
$labelMdp.Text = "Mot de passe"
$labelMdp.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes

$textBoxMdp = New-Object System.Windows.Forms.TextBox
$textBoxMdp.Name = "textBoxMdp"
$textBoxMdp.Location = New-Object System.Drawing.Point(220,170)
$textBoxMdp.Size = New-Object System.Drawing.Size(200,30)
$textBoxMdp.Height = 100

$labelRegexMdp = New-Object System.Windows.Forms.Label
$labelRegexMdp.Location = New-Object System.Drawing.Point(10,210)
$labelRegexMdp.Size = New-Object System.Drawing.Size(200,20)
$labelRegexMdp.Text = "Regex de génération du mot de passe"
$labelRegexMdp.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes

$textBoxRegexMdp = New-Object System.Windows.Forms.TextBox
$textBoxRegexMdp.Name = "textBoxRegexMdp"
$textBoxRegexMdp.Location = New-Object System.Drawing.Point(220,210)
$textBoxRegexMdp.Size = New-Object System.Drawing.Size(200,30)
$textBoxRegexMdp.Height = 100

$labelObligatoire = New-Object System.Windows.Forms.Label
$labelObligatoire.Location = New-Object System.Drawing.Point(10,250)
$labelObligatoire.Size = New-Object System.Drawing.Size(200,20)
$labelObligatoire.Text = "Compte obligatoire"
$labelObligatoire.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes

$textBoxObligatoire = New-Object System.Windows.Forms.TextBox
$textBoxObligatoire.Name = "textBoxObligatoire"
$textBoxObligatoire.Location = New-Object System.Drawing.Point(220,250)
$textBoxObligatoire.Size = New-Object System.Drawing.Size(200,30)
$textBoxObligatoire.Height = 100

$ListBoxMenuDeux.Controls.clear();
$ListBoxMenuDeux.Controls.Add($ComboBoxPlateformes)
$ListBoxMenuDeux.Controls.Add($labelURL)
$ListBoxMenuDeux.Controls.Add($textBoxURL)
$ListBoxMenuDeux.Controls.Add($labelMail)
$ListBoxMenuDeux.Controls.Add($textBoxMail)
$ListBoxMenuDeux.Controls.Add($labelUser)
$ListBoxMenuDeux.Controls.Add($textBoxUser)
$ListBoxMenuDeux.Controls.Add($labelMdp)
$ListBoxMenuDeux.Controls.Add($textBoxMdp)
$ListBoxMenuDeux.Controls.Add($labelRegexMdp)
$ListBoxMenuDeux.Controls.Add($textBoxRegexMdp)
$ListBoxMenuDeux.Controls.Add($labelObligatoire)
$ListBoxMenuDeux.Controls.Add($textBoxObligatoire)

# récupération de la ligne de la table plateforme en fonction de l'index
FillPlateforme $plateformes $ComboBoxPlateformes.SelectedItem $textBoxURL $textBoxMail $textBoxUser $textBoxMdp $textBoxRegexMdp $textBoxObligatoire
#$ComboBoxPlateformes.Add_click({FillPlateforme $plateformes $ComboBoxPlateformes.SelectedItem $textBoxURL $textBoxMail $textBoxUser $textBoxMdp $textBoxRegexMdp $textBoxObligatoire})
}

Function FillPlateforme($plateformes, $selectedItem, $textBoxURL, $textBoxMail, $textBoxUser, $textBoxMdp, $textBoxRegexMdp, $textBoxObligatoire)
{
    $plateforme = RetreiveRow $plateformes "nom" $selectedItem
    $textBoxURL.Text = $plateforme.URL
    $textBoxMail.Text = $plateforme.mail
    $textBoxUser.Text = $plateforme.identifiant
    $textBoxMdp.Text = $plateforme.MDP
    $textBoxRegexMdp.Text = $plateforme.regexMDP
    $textBoxObligatoire.Text = $plateforme.obligatoire
}

Function MakeMenuDefProfils {

$FormLabelTextDefProfils1 = New-Object System.Windows.Forms.Label
$FormLabelTextDefProfils1.Location = New-Object System.Drawing.Point(300,220)
$FormLabelTextDefProfils1.Size = New-Object System.Drawing.Size(200,20)
$FormLabelTextDefProfils1.Text = "plop ;-)"
$FormLabelTextDefProfils1.Visible = $true

$ListBoxMenuDeux.Controls.clear();
$ListBoxMenuDeux.Controls.Add($FormLabelTextDefProfils1)

}


Function MakeMenuAssProfils {

$FormLabelTextAssProfils1 = New-Object System.Windows.Forms.Label
$FormLabelTextAssProfils1.Location = New-Object System.Drawing.Point(300,220)
$FormLabelTextAssProfils1.Size = New-Object System.Drawing.Size(200,20)
$FormLabelTextAssProfils1.Text = "plop ;-)"
$FormLabelTextAssProfils1.Visible = $true

$ListBoxMenuDeux.Controls.clear();
$ListBoxMenuDeux.Controls.Add($FormLabelTextAssProfils1)
}