# Chargement du pilote .NET pour MySQL 
[system.reflection.Assembly]::LoadWithPartialName("MySql.Data")


Function MakeNewForm {
	$Form.Close()
	$Form.Dispose()
	MakeForm
}

Function AddMenuAd {
    $FormLabelTextPlateforme1.Visible = $false
    $FormLabelTextPlateforme2.Visible = $false
    $FormLabelTextPlateforme3.Visible = $false
    $FormLabelTextPlateforme4.Visible = $false
    $TextBoxPlateforme1.Visible = $false
    $TextBoxPlateforme2.Visible = $false
    $TextBoxPlateforme3.Visible = $false
    $TextBoxPlateforme4.Visible = $false
	$FormLabelTextAd1.Visible = $true
    $FormLabelTextAd2.Visible = $true
    $FormLabelTextAd3.Visible = $true
    $TextBoxAd1.Visible = $true
    $TextBoxAd2.Visible = $true
    $TextBoxAd3.Visible = $true
    $FormLabelTextAssProfils1.Visible = $false
    $FormLabelTextDefProfils1.Visible = $false
}

Function AddMenuPlateforme {
	$FormLabelTextPlateforme1.Visible = $true
    $FormLabelTextPlateforme2.Visible = $true
    $FormLabelTextPlateforme3.Visible = $true
    $FormLabelTextPlateforme4.Visible = $true
    $TextBoxPlateforme1.Visible = $true
    $TextBoxPlateforme2.Visible = $true
    $TextBoxPlateforme3.Visible = $true
    $TextBoxPlateforme4.Visible = $true
    $FormLabelTextAd1.Visible = $false
    $FormLabelTextAd2.Visible = $false
    $FormLabelTextAd3.Visible = $false
    $TextBoxAd1.Visible = $false
    $TextBoxAd2.Visible = $false
    $TextBoxAd3.Visible = $false
    $FormLabelTextAssProfils1.Visible = $false
    $FormLabelTextDefProfils1.Visible = $false
}

Function AddMenuDefProfils {
    $FormLabelTextPlateforme1.Visible = $false
    $FormLabelTextPlateforme2.Visible = $false
    $FormLabelTextPlateforme3.Visible = $false
    $FormLabelTextPlateforme4.Visible = $false
    $TextBoxPlateforme1.Visible = $false
    $TextBoxPlateforme2.Visible = $false
    $TextBoxPlateforme3.Visible = $false
    $TextBoxPlateforme4.Visible = $false
	$FormLabelTextAd1.Visible = $false
    $FormLabelTextAd2.Visible = $false
    $FormLabelTextAd3.Visible = $false
    $TextBoxAd1.Visible = $false
    $TextBoxAd2.Visible = $false
    $TextBoxAd3.Visible = $false
    $FormLabelTextDefProfils1.Text = "plop !!! Je suis le menu def des profils ;-)"
	$FormLabelTextDefProfils1.Visible = $true
    $FormLabelTextAssProfils1.Visible = $false
}

Function AddMenuAssProfils {
    $FormLabelTextPlateforme1.Visible = $false
    $FormLabelTextPlateforme2.Visible = $false
    $FormLabelTextPlateforme3.Visible = $false
    $FormLabelTextPlateforme4.Visible = $false
    $TextBoxPlateforme1.Visible = $false
    $TextBoxPlateforme2.Visible = $false
    $TextBoxPlateforme3.Visible = $false
    $TextBoxPlateforme4.Visible = $false
	$FormLabelTextAd1.Visible = $false
    $FormLabelTextAd2.Visible = $false
    $FormLabelTextAd3.Visible = $false
    $TextBoxAd1.Visible = $false
    $TextBoxAd2.Visible = $false
    $TextBoxAd3.Visible = $false
    $FormLabelTextAssProfils1.Text = "plop !!! Je suis le menu ass des profils;-)"
	$FormLabelTextAssProfils1.Visible = $true
    $FormLabelTextDefProfils1.Visible = $false
}

<#
Fonction : fg_7.0


#>

Function MakeForm {

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$ListForm = New-Object System.Windows.Forms.Form
$ListForm.Text = "Paramétrage"
$ListForm.Size = New-Object System.Drawing.Size(1000,700)
$ListForm.StartPosition = "CenterScreen"
$ListForm.TopMost = $True

$ButtonADAdmin = New-Object System.Windows.Forms.Button
$ButtonADAdmin.Location = New-Object System.Drawing.Point(40,40)
$ButtonADAdmin.Size = New-Object System.Drawing.Size(200,50)
$ButtonADAdmin.Text = "Active Directory administratif"
#$ButtonADAdmin.DialogResult = [System.Windows.Forms.DialogResult]::OK
$ButtonADAdmin.Add_Click({AddMenuAd})
#$ButtonADAdmin.Add_Click({MakeNewForm})

$ButtonPlateformes = New-Object System.Windows.Forms.Button
$ButtonPlateformes.Location = New-Object System.Drawing.Point(40,100)
$ButtonPlateformes.Size = New-Object System.Drawing.Size(200,50)
$ButtonPlateformes.Text = "Plateformes"
$ButtonPlateformes.Add_Click({AddMenuPlateforme})


$ButtonDefProfils = New-Object System.Windows.Forms.Button
$ButtonDefProfils.Location = New-Object System.Drawing.Point(40,160)
$ButtonDefProfils.Size = New-Object System.Drawing.Size(200,50)
$ButtonDefProfils.Text = "Définition des profils"
$ButtonDefProfils.Add_Click({AddMenuDefProfils})

$ButtonAssProfils = New-Object System.Windows.Forms.Button
$ButtonAssProfils.Location = New-Object System.Drawing.Point(40,220)
$ButtonAssProfils.Size = New-Object System.Drawing.Size(200,50)
$ButtonAssProfils.Text = "Assignation des profils"
$ButtonAssProfils.Add_Click({AddMenuAssProfils})

$ButtonAPropos = New-Object System.Windows.Forms.Button
$ButtonAPropos.Location = New-Object System.Drawing.Point(30,580)
$ButtonAPropos.Size = New-Object System.Drawing.Size(150,60)
$ButtonAPropos.Text = "A propos"

$FormLabelDA = New-Object System.Windows.Forms.Label
$FormLabelDA.Location = New-Object System.Drawing.Point(250,31)
$FormLabelDA.Size = New-Object System.Drawing.Size(5,700)
$FormLabelDA.Text = " "

$FormLabelTextAd1 = New-Object System.Windows.Forms.Label
$FormLabelTextAd1.Location = New-Object System.Drawing.Point(300,230)
$FormLabelTextAd1.Size = New-Object System.Drawing.Size(200,20)
$FormLabelTextAd1.Text = "Adresse IP ou nom du serveur : "
$FormLabelTextAd1.Visible = $false

$FormLabelTextAd2 = New-Object System.Windows.Forms.Label
$FormLabelTextAd2.Location = New-Object System.Drawing.Point(300,270)
$FormLabelTextAd2.Size = New-Object System.Drawing.Size(200,20)
$FormLabelTextAd2.Text = "Nom d'utilisateur : "
$FormLabelTextAd2.Visible = $false

$FormLabelTextAd3 = New-Object System.Windows.Forms.Label
$FormLabelTextAd3.Location = New-Object System.Drawing.Point(300,310)
$FormLabelTextAd3.Size = New-Object System.Drawing.Size(200,20)
$FormLabelTextAd3.Text = "Mot de passe : "
$FormLabelTextAd3.Visible = $false

$FormLabelTextPlateforme1 = New-Object System.Windows.Forms.Label
$FormLabelTextPlateforme1.Location = New-Object System.Drawing.Point(300,230)
$FormLabelTextPlateforme1.Size = New-Object System.Drawing.Size(200,20)
$FormLabelTextPlateforme1.Text = "Adresse IP ou nom du serveur : "
$FormLabelTextPlateforme1.Visible = $false

$FormLabelTextPlateforme2 = New-Object System.Windows.Forms.Label
$FormLabelTextPlateforme2.Location = New-Object System.Drawing.Point(300,270)
$FormLabelTextPlateforme2.Size = New-Object System.Drawing.Size(200,20)
$FormLabelTextPlateforme2.Text = "Nom d'utilisateur : "
$FormLabelTextPlateforme2.Visible = $false

$FormLabelTextPlateforme3 = New-Object System.Windows.Forms.Label
$FormLabelTextPlateforme3.Location = New-Object System.Drawing.Point(300,310)
$FormLabelTextPlateforme3.Size = New-Object System.Drawing.Size(200,20)
$FormLabelTextPlateforme3.Text = "Mot de passe : "
$FormLabelTextPlateforme3.Visible = $false

$FormLabelTextPlateforme4 = New-Object System.Windows.Forms.Label
$FormLabelTextPlateforme4.Location = New-Object System.Drawing.Point(300,340)
$FormLabelTextPlateforme4.Size = New-Object System.Drawing.Size(200,30)
$FormLabelTextPlateforme4.Text = "Expression régulière de génération du mot de passe : "
$FormLabelTextPlateforme4.Visible = $false

$FormLabelTextDefProfils1 = New-Object System.Windows.Forms.Label
$FormLabelTextDefProfils1.Location = New-Object System.Drawing.Point(300,220)
$FormLabelTextDefProfils1.Size = New-Object System.Drawing.Size(200,20)
$FormLabelTextDefProfils1.Text = "plop ;-)"
$FormLabelTextDefProfils1.Visible = $false

$FormLabelTextAssProfils1 = New-Object System.Windows.Forms.Label
$FormLabelTextAssProfils1.Location = New-Object System.Drawing.Point(300,220)
$FormLabelTextAssProfils1.Size = New-Object System.Drawing.Size(200,20)
$FormLabelTextAssProfils1.Text = "plop ;-)"
$FormLabelTextAssProfils1.Visible = $false

$TextBoxAd1 = New-Object System.Windows.Forms.TextBox
$TextBoxAd1.Location = New-Object System.Drawing.Point(600,230)
$TextBoxAd1.Size = New-Object System.Drawing.Size(200,30)
$TextBoxAd1.Height = 100
$TextBoxAd1.Text = ""
$TextBoxAd1.Visible = $false

$TextBoxAd2 = New-Object System.Windows.Forms.TextBox
$TextBoxAd2.Location = New-Object System.Drawing.Point(600,270)
$TextBoxAd2.Size = New-Object System.Drawing.Size(200,30)
$TextBoxAd2.Height = 100
$TextBoxAd2.Text = ""
$TextBoxAd2.Visible = $false

$TextBoxAd3 = New-Object System.Windows.Forms.TextBox
$TextBoxAd3.Location = New-Object System.Drawing.Point(600,310)
$TextBoxAd3.Size = New-Object System.Drawing.Size(200,30)
$TextBoxAd3.Height = 100
$TextBoxAd3.Text = ""
$TextBoxAd3.Visible = $false

$TextBoxPlateforme1 = New-Object System.Windows.Forms.TextBox
$TextBoxPlateforme1.Location = New-Object System.Drawing.Point(600,230)
$TextBoxPlateforme1.Size = New-Object System.Drawing.Size(200,30)
$TextBoxPlateforme1.Height = 100
$TextBoxPlateforme1.Text = ""
$TextBoxPlateforme1.Visible = $false

$TextBoxPlateforme2 = New-Object System.Windows.Forms.TextBox
$TextBoxPlateforme2.Location = New-Object System.Drawing.Point(600,270)
$TextBoxPlateforme2.Size = New-Object System.Drawing.Size(200,30)
$TextBoxPlateforme2.Height = 100
$TextBoxPlateforme2.Text = ""
$TextBoxPlateforme2.Visible = $false

$TextBoxPlateforme3 = New-Object System.Windows.Forms.TextBox
$TextBoxPlateforme3.Location = New-Object System.Drawing.Point(600,310)
$TextBoxPlateforme3.Size = New-Object System.Drawing.Size(200,30)
$TextBoxPlateforme3.Height = 100
$TextBoxPlateforme3.Text = ""
$TextBoxPlateforme3.Visible = $false

$TextBoxPlateforme4 = New-Object System.Windows.Forms.TextBox
$TextBoxPlateforme4.Location = New-Object System.Drawing.Point(600,340)
$TextBoxPlateforme4.Size = New-Object System.Drawing.Size(200,30)
$TextBoxPlateforme4.Height = 100
$TextBoxPlateforme4.Text = ""
$TextBoxPlateforme4.Visible = $false


$ListBoxMenu = New-Object System.Windows.Forms.ListBox 
$ListBoxMenu.Location = New-Object System.Drawing.Size(30,30) 
$ListBoxMenu.Size = New-Object System.Drawing.Size(220,20) 
$ListBoxMenu.Height = 530

$ListBoxInfos = New-Object System.Windows.Forms.ListBox 
$ListBoxInfos.Location = New-Object System.Drawing.Size(225,30) 
$ListBoxInfos.Size = New-Object System.Drawing.Size(725,20) 
$ListBoxInfos.Height = 530
$ListBoxInfos.Text = "plop ;-)"

$ListForm.Controls.Add($ButtonADAdmin) 
$ListForm.Controls.Add($ButtonPlateformes)
$ListForm.Controls.Add($ButtonDefProfils)
$ListForm.Controls.Add($ButtonAssProfils)
$ListForm.Controls.Add($TextBoxAd1)
$ListForm.Controls.Add($TextBoxAd2)
$ListForm.Controls.Add($TextBoxAd3)
$ListForm.Controls.Add($TextBoxPlateforme1)
$ListForm.Controls.Add($TextBoxPlateforme2)
$ListForm.Controls.Add($TextBoxPlateforme3)
$ListForm.Controls.Add($TextBoxPlateforme4)
$ListForm.Controls.Add($FormLabelTextAd1)
$ListForm.Controls.Add($FormLabelTextAd2)
$ListForm.Controls.Add($FormLabelTextAd3)
$ListForm.Controls.Add($FormLabelTextPlateforme1)
$ListForm.Controls.Add($FormLabelTextPlateforme2)
$ListForm.Controls.Add($FormLabelTextPlateforme3)
$ListForm.Controls.Add($FormLabelTextPlateforme4)
$ListForm.Controls.Add($FormLabelTextDefProfils1)
$ListForm.Controls.Add($FormLabelTextAssProfils1)
$ListForm.Controls.Add($FormLabelDA)
$ListForm.Controls.Add($ButtonAPropos)
$ListForm.Controls.Add($ListBoxMenu)

$ListForm.Controls.Add($ListBoxInfos)

# Chargement du pilote .NET pour MySQL 
[system.reflection.Assembly]::LoadWithPartialName("MySql.Data")

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

# Afficher la fenetre
$ListForm.ShowDialog()
}

MakeForm