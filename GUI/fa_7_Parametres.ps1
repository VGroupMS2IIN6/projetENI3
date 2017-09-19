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

# recuperation de la liste des plateformes
$plateformes = MakeRequest "SELECT * FROM plateforme;"

# Creation des composants dont on aura besoin plus tard
$ListBoxAffichage = New-Object System.Windows.Forms.ListBox 
$ListBoxAffichage.Location = New-Object System.Drawing.Size(255,30) 
$ListBoxAffichage.Size = New-Object System.Drawing.Size(700,530) 
$ComboBoxPlateformes = New-Object System.Windows.Forms.ComboBox
$ComboBoxPlateformes.Location = New-Object System.Drawing.Point(10,10)
$ComboBoxPlateformes.Size = New-Object System.Drawing.Size(200,20)
$ComboBoxPlateformes.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
#$ComboBoxPlateformes.Items.AddRange($plateformes.nom)
#$ComboBoxPlateformes.SelectedIndex = 1
FillComboBox
$textBoxURL = New-Object System.Windows.Forms.TextBox
$textBoxURL.Location = New-Object System.Drawing.Point(220,50)
$textBoxURL.Size = New-Object System.Drawing.Size(200,22)
$textBoxMail = New-Object System.Windows.Forms.TextBox
$textBoxMail.Location = New-Object System.Drawing.Point(220,90)
$textBoxMail.Size = New-Object System.Drawing.Size(200,22)
$textBoxUser = New-Object System.Windows.Forms.TextBox
$textBoxUser.Location = New-Object System.Drawing.Point(220,130)
$textBoxUser.Size = New-Object System.Drawing.Size(200,22)
$textBoxMdp = New-Object System.Windows.Forms.TextBox
$textBoxMdp.Location = New-Object System.Drawing.Point(220,170)
$textBoxMdp.Size = New-Object System.Drawing.Size(200,22)
$textBoxRegexMdp = New-Object System.Windows.Forms.TextBox
$textBoxRegexMdp.Location = New-Object System.Drawing.Point(220,210)
$textBoxRegexMdp.Size = New-Object System.Drawing.Size(200,22)
$checkBoxObligatoire = New-Object System.Windows.Forms.CheckBox
$checkBoxObligatoire.Location = New-Object System.Drawing.Point(220,250)
$checkBoxObligatoire.Size = New-Object System.Drawing.Size(200,22)

# Affichage de l'ecran
MakeForm

$mysql.Close()

function FillComboBox {
    # creation de la datatable
    $table = New-Object system.Data.DataTable
		
    # definition des colonnes
    $colId = New-Object system.Data.DataColumn "id",([string])
    $colNom = New-Object system.Data.DataColumn "nom",([string])
 
    # table des colonnes à la datatable
    $table.Columns.Add($colId)
    $table.Columns.Add($colNom)

    # alimentation de la datatable avec les plateformes
    foreach($plateforme in $script:plateformes) {
        $ligne = $table.NewRow()
        $ligne.id = $plateforme.ID
        $ligne.nom = $plateforme.nom
        $table.Rows.Add($ligne)
    }
    $script:ComboBoxPlateformes.DisplayMember = "nom"
    $script:ComboBoxPlateformes.ValueMember = "id"
    $script:ComboBoxPlateformes.DataSource = $table
}

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
    $listForm = New-Object System.Windows.Forms.Form
    $listForm = New-Object System.Windows.Forms.Form
    $listForm.Text = "Paramétrage"
    $listForm.Size = New-Object System.Drawing.Size(1000,700)
    $listForm.StartPosition = "CenterScreen"
    #$listForm.TopMost = $True

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
    $ButtonDefProfils.Text = "Défnition des profils"
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

    $listForm.Controls.Add($ButtonADAdmin) 
    $listForm.Controls.Add($ButtonPlateformes)
    $listForm.Controls.Add($ButtonDefProfils)
    $listForm.Controls.Add($ButtonAssProfils)
    $listForm.Controls.Add($ButtonRetour)
    $listForm.Controls.Add($ListBoxMenu)
    $listForm.Controls.Add($script:ListBoxAffichage)

    # Afficher la fenetre
    $listForm.ShowDialog()
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

    $script:ListBoxAffichage.Controls.clear();
    $script:ListBoxAffichage.Controls.Add($TextBoxAd1)
    $script:ListBoxAffichage.Controls.Add($TextBoxAd2)
    $script:ListBoxAffichage.Controls.Add($TextBoxAd3)
    $script:ListBoxAffichage.Controls.Add($FormLabelTextAd1)
    $script:ListBoxAffichage.Controls.Add($FormLabelTextAd2)
    $script:ListBoxAffichage.Controls.Add($FormLabelTextAd3)
    $script:ListBoxAffichage.Controls.Add($FormLabelDA)
}

Function ModifyPlateforme {
    $reqUpdate = "update plateforme set"
    $reqUpdate += " URL='" + $script:textBoxURL.Text + "',"
    $reqUpdate += " mail='" + $script:textBoxMail.Text + "',"
    $reqUpdate += " identifiant='" + $script:textBoxUser.Text + "',"
    $reqUpdate += " MDP='" + $script:textBoxMdp.Text + "',"
    $reqUpdate += " RegexMDP='" + $script:textBoxRegexMdp.Text + "',"
    $reqUpdate += " obligatoire='" + $script:checkBoxObligatoire.Checked + "'"
    $reqUpdate += " where id=" + $script:ComboBoxPlateformes.SelectedItem.id
    #MakeRequest $reqUpdate
}

Function MakeMenuPlateformes {
    $buttonEnregistrer = New-Object System.Windows.Forms.Button
    $buttonEnregistrer.Location = New-Object System.Drawing.Point(215,10)
    $buttonEnregistrer.Size = New-Object System.Drawing.Size(70,22)
    $buttonEnregistrer.Text = "Enregistrer"
    $buttonEnregistrer.Add_Click({ModifyPlateforme})

    $labelURL = New-Object System.Windows.Forms.Label
    $labelURL.Location = New-Object System.Drawing.Point(10,50)
    $labelURL.Size = New-Object System.Drawing.Size(200,20)
    $labelURL.Text = "Adresse IP ou nom du serveur"
    $labelURL.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes

    $labelMail = New-Object System.Windows.Forms.Label
    $labelMail.Location = New-Object System.Drawing.Point(10,90)
    $labelMail.Size = New-Object System.Drawing.Size(200,20)
    $labelMail.Text = "Adresse mail destinataire"
    $labelMail.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes
    
    $labelUser = New-Object System.Windows.Forms.Label
    $labelUser.Location = New-Object System.Drawing.Point(10,130)
    $labelUser.Size = New-Object System.Drawing.Size(200,20)
    $labelUser.Text = "Nom d'utilisateur"
    $labelUser.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes

    $labelMdp = New-Object System.Windows.Forms.Label
    $labelMdp.Location = New-Object System.Drawing.Point(10,170)
    $labelMdp.Size = New-Object System.Drawing.Size(200,20)
    $labelMdp.Text = "Mot de passe"
    $labelMdp.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes

    $labelRegexMdp = New-Object System.Windows.Forms.Label
    $labelRegexMdp.Location = New-Object System.Drawing.Point(10,210)
    $labelRegexMdp.Size = New-Object System.Drawing.Size(200,20)
    $labelRegexMdp.Text = "Regex de génération du mot de passe"
    $labelRegexMdp.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes
    
    $labelObligatoire = New-Object System.Windows.Forms.Label
    $labelObligatoire.Location = New-Object System.Drawing.Point(10,250)
    $labelObligatoire.Size = New-Object System.Drawing.Size(200,20)
    $labelObligatoire.Text = "Compte obligatoire"
    $labelObligatoire.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes
    
    $script:ListBoxAffichage.Controls.clear();
    $script:ListBoxAffichage.Controls.Add($script:ComboBoxPlateformes)
    $script:ListBoxAffichage.Controls.Add($buttonEnregistrer)
    $script:ListBoxAffichage.Controls.Add($labelURL)
    $script:ListBoxAffichage.Controls.Add($script:textBoxURL)
    $script:ListBoxAffichage.Controls.Add($labelMail)
    $script:ListBoxAffichage.Controls.Add($script:textBoxMail)
    $script:ListBoxAffichage.Controls.Add($labelUser)
    $script:ListBoxAffichage.Controls.Add($script:textBoxUser)
    $script:ListBoxAffichage.Controls.Add($labelMdp)
    $script:ListBoxAffichage.Controls.Add($script:textBoxMdp)
    $script:ListBoxAffichage.Controls.Add($labelRegexMdp)
    $script:ListBoxAffichage.Controls.Add($script:textBoxRegexMdp)
    $script:ListBoxAffichage.Controls.Add($labelObligatoire)
    $script:ListBoxAffichage.Controls.Add($script:checkBoxObligatoire)

    # alimentation des champs pour la plateforme selectionnee
    FillPlateforme

    $ComboBoxPlateformes.add_SelectedIndexChanged({
        FillPlateforme
    })
}

Function FillPlateforme {
    $plateforme = RetreiveRow $script:plateformes "id" $script:ComboBoxPlateformes.SelectedItem.id
    $script:textBoxURL.Text = $plateforme.URL
    $script:textBoxMail.Text = $plateforme.mail
    $script:textBoxUser.Text = $plateforme.identifiant
    $script:textBoxMdp.Text = $plateforme.MDP
    $script:textBoxRegexMdp.Text = $plateforme.regexMDP
    $script:checkBoxObligatoire.Checked = $plateforme.obligatoire
}

Function MakeMenuDefProfils {
    $FormLabelTextDefProfils1 = New-Object System.Windows.Forms.Label
    $FormLabelTextDefProfils1.Location = New-Object System.Drawing.Point(300,220)
    $FormLabelTextDefProfils1.Size = New-Object System.Drawing.Size(200,20)
    $FormLabelTextDefProfils1.Text = "plop ;-)"
    $FormLabelTextDefProfils1.Visible = $true

    $script:ListBoxAffichage.Controls.clear();
    $script:ListBoxAffichage.Controls.Add($FormLabelTextDefProfils1)
}

Function MakeMenuAssProfils {
    $FormLabelTextAssProfils1 = New-Object System.Windows.Forms.Label
    $FormLabelTextAssProfils1.Location = New-Object System.Drawing.Point(300,220)
    $FormLabelTextAssProfils1.Size = New-Object System.Drawing.Size(200,20)
    $FormLabelTextAssProfils1.Text = "plop ;-)"
    $FormLabelTextAssProfils1.Visible = $true

    $script:ListBoxAffichage.Controls.clear();
    $script:ListBoxAffichage.Controls.Add($FormLabelTextAssProfils1)
}