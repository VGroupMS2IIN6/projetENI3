#############################
### CREATION DES FENETRES ###
#############################

$FenetreAccueil = New-Object System.Windows.Forms.Form
$FenetreAccueil.StartPosition = "CenterScreen"
$FenetreAccueil.ClientSize = '1000,700'

$FenetreCreationCSV = New-Object System.Windows.Forms.Form
$FenetreCreationCSV.StartPosition = "CenterScreen"
$FenetreCreationCSV.ClientSize = '1000,700'

$FenetreCreationUnitaire = New-Object System.Windows.Forms.Form
$FenetreCreationUnitaire.StartPosition = "CenterScreen"
$FenetreCreationUnitaire.ClientSize = '1000,700'

$FenetreResetPWD = New-Object System.Windows.Forms.Form
$FenetreResetPWD.StartPosition = "CenterScreen"
$FenetreResetPWD.ClientSize = '1000,700'

$FenetreHistorique = New-Object System.Windows.Forms.Form
$FenetreHistorique.StartPosition = "CenterScreen"
$FenetreHistorique.ClientSize = '1000,700'

$FenetreGestionFormation = New-Object System.Windows.Forms.Form
$FenetreGestionFormation.StartPosition = "CenterScreen"
$FenetreGestionFormation.ClientSize = '1000,700'

$FenetreParametres = New-Object System.Windows.Forms.Form
$FenetreParametres.StartPosition = "CenterScreen"
$FenetreParametres.ClientSize = '1000,700'

$FenetreAPropos = New-Object System.Windows.Forms.Form
$FenetreAPropos.StartPosition = "CenterScreen"
$FenetreAPropos.ClientSize = '1000,700'


################################
### ELEMENTS FENETRE ACCUEIL ###
################################

$ButtonCreationCSV = New-Object System.Windows.Forms.Button
$ButtonCreationCSV.Location = '30,30'
$ButtonCreationCSV.Size = '150,60'
$ButtonCreationCSV.Text = "Creation Comptes CSV"
$ButtonCreationCSV.add_Click($ButtonCreationCSV_Click)
$ButtonCreationCSV_Click = {
	$FenetreAccueil.Visible = $false
	$FenetreCreationCSV.ShowDialog()
}

$ButtonUnit = New-Object System.Windows.Forms.Button
$ButtonUnit.Location = '190,30'
$ButtonUnit.Size = '150,60'
$ButtonUnit.Text = "Creation Compte Unitaire"
$ButtonUnit.add_Click($ButtonUnit_CLick)
$ButtonUnit_Click = {
	$FenetreAccueil.Visible = $false
	$FenetreCreationUnitaire.ShowDialog()
}

$ButtonResetPWD = New-Object System.Windows.Forms.Button
$ButtonResetPWD.Location = '350,30'
$ButtonResetPWD.Size = '150,60'
$ButtonResetPWD.Text = "Réinisialisation MDP"
$ButtonResetPWD.add_Click($ButtonResetPWD_Click)
$ButtonResetPWD_Click = {
	$FenetreAccueil.Visible = $false
	$FenetreResetPWD.ShowDialog()
}

$ButtonHistorique = New-Object System.Windows.Forms.Button
$ButtonHistorique.Location = '510,30'
$ButtonHistorique.Size = '150,60'
$ButtonHistorique.Text = 'Historique'
$ButtonHistorique.add_Click($ButtonHistorique_Click)
$ButtonHistorique_Click = {
	$FenetreAccueil.Visible = $false
	$FenetreHistorique.ShowDialog()
}

$ButtonGestionFormation = New-Object System.Windows.Forms.Button
$ButtonGestionFormation.Location = '670,30'
$ButtonGestionFormation.Size = '150,60'
$ButtonGestionFormation.Text = "Gestion des Formations"
$ButtonGestionFormation.add_Click($ButtonGestionFormation_Click)
$ButtonGestionFormation_Click = {
	$FenetreAccueil.Visible = $false
	$FenetreGestionFormation.ShowDialog()
}

$ButtonParametres = New-Object System.Windows.Forms.Button
$ButtonParametres.Location = '830,30'
$ButtonParametres.Size = '150,60'
$ButtonParametres.Text = "Paramètres"
$ButtonParametres.add_Click($ButtonParametres_Click)
$ButtonParametres_Click = {
	$FenetreAccueil.Visible = $false
	$FenetreParametres.ShowDialog()
}

$ButtonAPropos = New-Object System.Windows.Forms.Button
$ButtonAPropos.Location = '30,580'
$ButtonAPropos.Size = '150,60'
$ButtonAPropos.Text = "A propos"
$ButtonAPropos.add_Click($ButtonAPropos_Click)
$ButtonAPropos_CLick = {
	$FenetreAccueil.Visible = $false
	$FenetreAPropos.ShowDialog()
}

$FormLabelDA = New-Object System.Windows.Forms.Label
$FormLabelDA.Location = '30,120'
$FormLabelDA.Size = '900,20'
$FormLabelDA.Text = "Dernières Activités : "

$ListBoxDA = New-Object System.Windows.Forms.ListBox 
$ListBoxDA.Location = '30,150' 
$ListBoxDA.Size = '920,20'
$ListBoxDA.Height = 400

#####################################
### ELEMENTS FENETRE CREATION CSV ###
#####################################

$ButtonRetourCSV = New-Object System.Windows.Forms.Button
$ButtonRetourCSV.Location = '800,580'
$ButtonRetourCSV.Size = '150,60'
$ButtonRetourCSV.Text = 'Retour'
$ButtonRetourCSV.add_Click($ButtonRetourCSV_Click)
$ButtonRetourCSV_Click = {
    $FenetreCreationCSV.Visible = $false
	$FenetreAccueil.Visible = $true
}

##########################################
### ELEMENTS FENETRE CREATION UNITAIRE ###
##########################################

$ButtonRetourUnitaire = New-Object System.Windows.Forms.Button
$ButtonRetourUnitaire.Location = '800,580'
$ButtonRetourUnitaire.Size = '150,60'
$ButtonRetourUnitaire.Text = 'Retour'
$ButtonRetourUnitaire.add_Click($ButtonRetourUnitaire_Click)
$ButtonRetourUnitaire_CLick = {
    $FenetreCreationUnitaire.Visible = $false
	$FenetreAccueil.Visible = $true
}

#######################################
### ELEMENTS FENETRE RESET PASSWORD ###
#######################################

$ButtonRetourResetPWD = New-Object System.Windows.Forms.Button
$ButtonRetourResetPWD.Location = '800,580'
$ButtonRetourResetPWD.Size = '150,60'
$ButtonRetourResetPWD.Text = 'Retour'
$ButtonRetourResetPWD.add_Click($ButtonRetourResetPWD_CLick)
$ButtonRetourResetPWD_Click = {
    $FenetreResetPWD.Visible = $false
	$FenetreAccueil.Visible = $true
}

###################################
### ELEMENTS FENETRE HISTORIQUE ###
###################################

$FormLabelHistorique = New-Object System.Windows.Forms.Label
$FormLabelHistorique.Location = '30,120'
$FormLabelHistorique.Size = '900,20'
$FormLabelHistorique.Text = "Historique "

$ListBoxHistorique = New-Object System.Windows.Forms.ListBox 
$ListBoxHistorique.Location = '30,150'
$ListBoxHistorique.Size = '920,20'
$ListBoxHistorique.Height = 400

$ButtonRetourHistorique = New-Object System.Windows.Forms.Button
$ButtonRetourHistorique.Location = '800,580'
$ButtonRetourHistorique.Size = '150,60'
$ButtonRetourHistorique.Text = 'Retour'
$ButtonRetourHistorique.add_Click($ButtonRetourHistorique_Click)
$ButtonRetourHistorique_Click = {
    $FenetreHistorique.Visible = $false
	$FenetreAccueil.Visible = $true
}


##########################################
### ELEMENTS FENETRE GESTION FORMATION ###
##########################################

$ButtonRetourFormation = New-Object System.Windows.Forms.Button
$ButtonRetourFormation.Location = '800,580'
$ButtonRetourFormation.Size = '150,60'
$ButtonRetourFormation.Text = 'Retour'
$ButtonRetourFormation.add_Click($ButtonRetourFormation_Click)
$ButtonRetourFormation_Click = {
    $FenetreGestionFormation.Visible = $false
	$FenetreAccueil.Visible = $true
}

###################################
### ELEMENTS FENETRE PARAMETRES ###
###################################

$ButtonRetourParametres = New-Object System.Windows.Forms.Button
$ButtonRetourParametres.Location = '800,580'
$ButtonRetourParametres.Size = '150,60'
$ButtonRetourParametres.Text = 'Retour'
$ButtonRetourParametres.add_Click($ButtonRetourParametres_Click)
$ButtonRetourParametres_Click = {
    $FenetreParametres.Visible = $false
	$FenetreAccueil.Visible = $true
}


#######################################
### ELEMENTS FENETRE RESET PASSWORD ###
#######################################

$ButtonRetourAPropos = New-Object System.Windows.Forms.Button
$ButtonRetourAPropos.Location = '800,580'
$ButtonRetourAPropos.Size = '150,60'
$ButtonRetourAPropos.Text = 'Retour'
$ButtonRetourAPropos.add_Click($ButtonRetourAPropos_Click)
$ButtonRetourAPropos_Click = {
    $FenetreAPropos.Visible = $false
	$FenetreAccueil.Visible = $true
}

###########################################
### AJOUT DES ELEMENTS SUR LES FENETRES ###
###########################################

$FenetreAccueil.Controls.Add($ButtonHistorique)
$FenetreAccueil.Controls.Add($ButtonCreationCSV) 
$FenetreAccueil.Controls.Add($ButtonUnit)
$FenetreAccueil.Controls.Add($ButtonREsetPWD)
$FenetreAccueil.Controls.Add($ButtonGestionFormation)
$FenetreAccueil.Controls.Add($ButtonParametres)
$FenetreAccueil.Controls.Add($ButtonAPropos)
$FenetreAccueil.Controls.Add($FormLabelDA)
$FenetreAccueil.Controls.Add($ListBoxDA)

$FenetreCreationCSV.Controls.Add($ButtonRetourCSV)

$FenetreCreationUnitaire.Controls.Add($ButtonRetourUnitaire)

$FenetreResetPWD.Controls.Add($ButtonRetourResetPWD)

$FenetreHistorique.Controls.Add($FormLabelHistorique)
$FenetreHistorique.Controls.Add($ListBoxHistorique)
$FenetreHistorique.Controls.Add($ButtonRetourHistorique)

$FenetreGestionFormation.Controls.Add($ButtonRetourFormation)

$FenetreParametres.Controls.Add($ButtonRetourParametres)

$FenetreAPropos.Controls.Add($ButtonRetourAPropos)

##############################################
### LANCEMENT DE L'APPLI (FENETRE ACCUEIL) ###
##############################################

$FenetreAccueil.ShowDialog()