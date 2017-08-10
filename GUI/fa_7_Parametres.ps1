### A FAIRE ###
#
#Pour pouvoir executer un script powershell sur le PC :
#
#1) lancer powershell en tant qu'administrateur
#2) taper cette commande :  Set-ExecutionPolicy RemoteSigned
#3) Taper : T
#4) Et voila !
#
### SCRIPT ###
Function MakeNewForm {
	$Form.Close()
	$Form.Dispose()
	MakeForm
}

Function AddMenuAd {
    $FormLabelText.Text = "plop !!! Je suis le menu AD ;-)"
	$FormLabelText.Visible = $true
}

Function AddMenuPlateforme {
    $FormLabelText.Text = ("Je n'arrive pas a lui faire afficher le résultat de la requête ... :" + $result.Rows[0].nom)
	$FormLabelText.Visible = $true
}

Function AddMenuDefProfils {
    $FormLabelText.Text = "plop !!! Je suis le menu def des profils ;-)"
	$FormLabelText.Visible = $true
}

Function AddMenuAssProfils {
    $FormLabelText.Text = "plop !!! Je suis le menu ass des profils;-)"
	$FormLabelText.Visible = $true
}

<#
Fonction : fg_7.0


#>

Function SQLRequest ($reqStr)
{
	# Affichage de la requete pour les logs
	echo $reqStr >> $logfile
	
	$req = New-Object Mysql.Data.MysqlClient.MySqlCommand($reqStr,$mysql)  
	# Création du data adapter et du dataset qui permettront de traiter les données
	$dataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($req)  
	$dataSet = New-Object System.Data.DataSet  
	$script:rowCount = $dataAdapter.Fill($dataSet,"test")
	$script:result = $dataSet.Tables["test"]
}

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

$FormLabelText = New-Object System.Windows.Forms.Label
$FormLabelText.Location = New-Object System.Drawing.Point(300,220)
$FormLabelText.Size = New-Object System.Drawing.Size(200,30)
$FormLabelText.Text = "plop ;-)"
$FormLabelText.Visible = $false

$ListBoxMenu = New-Object System.Windows.Forms.ListBox 
$ListBoxMenu.Location = New-Object System.Drawing.Size(30,30) 
$ListBoxMenu.Size = New-Object System.Drawing.Size(220,20) 
$ListBoxMenu.Height = 530

$ListBoxInfos = New-Object System.Windows.Forms.ListBox 
$ListBoxInfos.Location = New-Object System.Drawing.Size(225,30) 
$ListBoxInfos.Size = New-Object System.Drawing.Size(725,20) 
$ListBoxInfos.Height = 530
$ListBoxInfos.Text = "plop ;-)"


$ListForm.Controls.Add($FormLabelText)
$ListForm.Controls.Add($FormLabelDA)





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


#return $DataSet.Tables[0]


SQLRequest ("SELECT * FROM formation;")

$result.Rows[0].nom

$mysql.Close()

# Afficher la fenetre
$ListForm.ShowDialog()
}

MakeForm