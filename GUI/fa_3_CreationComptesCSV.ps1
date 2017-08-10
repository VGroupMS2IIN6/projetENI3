#########################
### FENETRES     CSV  ###
#########################

$FenetreCreationCSV = New-Object System.Windows.Forms.Form
$FenetreCreationCSV.StartPosition = "CenterScreen"
$FenetreCreationCSV.ClientSize = '1000,700'
$FenetreCreationCSV.Text = "Application de creation de comptes stagiaires"
$FenetreCreationCSV.Formborderstyle = 3

$FenetreSelection = New-Object System.Windows.Forms.Form
$FenetreSelection.StartPosition = "CenterScreen"
$FenetreSelection.ClientSize = '1000,700'
$FenetreSelection.Text = "Application de creation de comptes stagiaires"
$FenetreSelection.Formborderstyle = 3

$FenetreCreationtab = New-Object System.Windows.Forms.Form
$FenetreCreationtab.StartPosition = "CenterScreen"
$FenetreCreationtab.ClientSize = '1000,700'
$FenetreCreationtab.Text = "Application de creation de comptes stagiaires"
$FenetreCreationtab.Formborderstyle = 3

$FenetreValidation = New-Object System.Windows.Forms.Form
$FenetreValidation.StartPosition = "CenterScreen"
$FenetreValidation.ClientSize = '1000,290'
$FenetreValidation.Text = "Application de creation de comptes stagiaires"


#####################################
### ELEMENTS FENETRES CREATION CSV###
#####################################

$ButtonRetourCSV = New-Object System.Windows.Forms.Button
$ButtonRetourCSV.Location = '40,600'
$ButtonRetourCSV.Size = '150,40'
$ButtonRetourCSV.Text = 'Retour'
$ButtonRetourCSV.add_Click($ButtonRetourCSV_Click)
$ButtonRetourCSV_Click = {
    $FenetreCreationCSV.Visible = $False
    $FenetreAccueil.ShowDialog()
}

$ButtonSuivantCSV = New-Object System.Windows.Forms.Button
$ButtonSuivantCSV.Location = '800,600'
$ButtonSuivantCSV.Size = '150,40'
$ButtonSuivantCSV.Text = 'Suivant'
$ButtonSuivantCSV.add_Click($ButtonSuivantCSV_Click)
$ButtonSuivantCSV_Click = {
    $FenetreCreationCSV.Visible = $False
    $FenetreSelection.ShowDialog()
}


$ButtonParcourirCSV = New-Object System.Windows.Forms.Button
$ButtonParcourirCSV.Location = '650,290'
$ButtonParcourirCSV.Size = '150,60'
$ButtonParcourirCSV.Text = 'Parcourir'
$ButtonParcourirCSV.add_Click($ButtonParcourirCSV_Click)
#$ButtonParcourirCSV_Click = {
#   
#}

$ListBoxCreationCompteCSV = New-Object System.Windows.Forms.ListBox 
$ListBoxCreationCompteCSV.Location = '400,292'
$ListBoxCreationCompteCSV.Size = '250,400'
$ListBoxCreationCompteCSV.Height = 60

$FormLabelA = New-Object System.Windows.Forms.Label
$FormLabelA.Location = '30,30'
$FormLabelA.Size = '400,40'
$FormLabelA.Text = "Creation de compte stagiaire (CSV) : "


$FormLabelB = New-Object System.Windows.Forms.Label
$FormLabelB.Location = '30,100'
$FormLabelB.Size = '400,40'
$FormLabelB.Text = "Importez le fichier .CSV provenant du CRM de l'ENI "

$FormLabelC = New-Object System.Windows.Forms.Label
$FormLabelC.Location = '260,310'
$FormLabelC.Size = '150,60'
$FormLabelC.Text = "Fichier à importer "


#####################################
### ELEMENTS FENETRES SELECTION   ###
#####################################

$ButtonRetourCSV2 = New-Object System.Windows.Forms.Button
$ButtonRetourCSV2.Location = '40,600'
$ButtonRetourCSV2.Size = '150,40'
$ButtonRetourCSV2.Text = 'Retour'
$ButtonRetourCSV2.add_Click($ButtonRetourCSV2_Click)
$ButtonRetourCSV2_Click = {
    $FenetreSelection.Visible = $False
    $FenetreCreationCSV.ShowDialog()
}


$ButtonSuivantCSV2 = New-Object System.Windows.Forms.Button
$ButtonSuivantCSV2.Location = '800,600'
$ButtonSuivantCSV2.Size = '150,40'
$ButtonSuivantCSV2.Text = 'Suivant'
$ButtonSuivantCSV2.add_Click($ButtonSuivantCSV2_Click)
$ButtonSuivantCSV2_Click = {
    $FenetreSelection.Visible = $False
    $FenetreCreationtab.ShowDialog()
}


$FormLabelD = New-Object System.Windows.Forms.Label
$FormLabelD.Location = '30,30'
$FormLabelD.Size = '400,40'
$FormLabelD.Text = "Creation de compte stagiaire (CSV) : "

$FormLabelE = New-Object System.Windows.Forms.Label
$FormLabelE.Location = '30,100'
$FormLabelE.Size = '400,40'
$FormLabelE.Text = "Selectionnez la formation"

$FormLabelF = New-Object System.Windows.Forms.Label
$FormLabelF.Location = '260,310'
$FormLabelF.Size = '150,60'
$FormLabelF.Text = "Formation"
#Formation
$ListBoxFormation = New-Object System.Windows.Forms.ListBox 
$ListBoxFormation.Location = '430,295'
$ListBoxFormation.Size = '250,400'
$ListBoxFormation.Height = 60


$FormLabelG = New-Object System.Windows.Forms.Label
$FormLabelG.Location = '260,410'
$FormLabelG.Size = '150,60'
$FormLabelG.Text = "Site"
#Site
$ListBoxSite = New-Object System.Windows.Forms.ListBox 
$ListBoxSite.Location = '430,390'
$ListBoxSite.Size = '250,400'
$ListBoxSite.Height = 60

#####################################
### ELEMENTS FENETRES CREATIONTAB ###
#####################################

$FormLabelH = New-Object System.Windows.Forms.Label
$FormLabelH.Location = '30,30'
$FormLabelH.Size = '400,40'
$FormLabelH.Text = "Creation de compte stagiaire (CSV) : "


$FormLabelI = New-Object System.Windows.Forms.Label
$FormLabelI.Location = '30,80'
$FormLabelI.Size = '400,40'
$FormLabelI.Text = "Selection des stagiaires et des plateformes"


$ButtonRetourCSV3 = New-Object System.Windows.Forms.Button
$ButtonRetourCSV3.Location = '40,600'
$ButtonRetourCSV3.Size = '150,40'
$ButtonRetourCSV3.Text = 'Retour'
$ButtonRetourCSV3.add_Click($ButtonRetourCSV3_Click)
$ButtonRetourCSV3_Click = {
    $FenetreCreationtab.Visible = $False
	$FenetreSelection.Showdialog()
    
}

$ButtonSuivantCSV3 = New-Object System.Windows.Forms.Button
$ButtonSuivantCSV3.Location = '800,600'
$ButtonSuivantCSV3.Size = '150,40'
$ButtonSuivantCSV3.Text = 'Suivant'
$ButtonSuivantCSV3.add_Click($ButtonSuivantCSV3_Click)
$ButtonSuivantCSV3_Click = {
    $FenetreCreationtab.Visible = $False
    $FenetreValidation.Showdialog()
}

$ListBoxtab = New-Object System.Windows.Forms.ListBox 
$ListBoxtab.Location = '30,150' 
$ListBoxtab.Size = '920,20'
$ListBoxtab.Height = 440


#####################################
### ELEMENTS FENETRE VALIDATION   ###
#####################################

$ButtonRetourCSV4 = New-Object System.Windows.Forms.Button
$ButtonRetourCSV4.Location = '40,230'
$ButtonRetourCSV4.Size = '150,40'
$ButtonRetourCSV4.Text = 'Annuler'
$ButtonRetourCSV4.add_Click($ButtonRetourCSV4_Click)
$ButtonRetourCSV4_Click = {
    $FenetreValidation.Visible = $False
	$FenetreCreationtab.Showdialog()
}
    
$FormLabelJ = New-Object System.Windows.Forms.Label
$FormLabelJ.Location = '30,30'
$FormLabelJ.Size = '400,40'
$FormLabelJ.Text = "Creation de compte stagiaire (CSV) : "


$FormLabelK = New-Object System.Windows.Forms.Label
$FormLabelK.Location = '30,80'
$FormLabelK.Size = '400,40'
$FormLabelK.Text = "Creation de compte en cours..."


###########################################
### AJOUT DES ELEMENTS SUR LA FENETRE   ###
###########################################
$FenetreCreationCSV.Controls.Add($ButtonRetourCSV)
$FenetreCreationCSV.Controls.Add($ButtonSuivantCSV)
$FenetreCreationCSV.Controls.Add($ButtonParcourirCSV)
$FenetreCreationCSV.Controls.Add($ListBoxCreationCompteCSV)
$FenetreCreationCSV.Controls.Add($FormLabelA)
$FenetreCreationCSV.Controls.Add($FormLabelB)
$FenetreCreationCSV.Controls.Add($FormLabelC)

$FenetreSelection.Controls.Add($ButtonRetourCSV2)
$FenetreSelection.Controls.Add($ButtonSuivantCSV2)
$FenetreSelection.Controls.Add($FormLabelD)
$FenetreSelection.Controls.Add($FormLabelE)
$FenetreSelection.Controls.Add($FormLabelF)
$FenetreSelection.Controls.Add($FormLabelG)
$FenetreSelection.Controls.Add($ListBoxFormation)
$FenetreSelection.Controls.Add($ListBoxSite)

$FenetreCreationtab.Controls.Add($ButtonRetourCSV3)
$FenetreCreationtab.Controls.Add($ButtonSuivantCSV3)
$FenetreCreationtab.Controls.Add($ListBoxtab)
$FenetreCreationtab.Controls.Add($FormLabelH)
$FenetreCreationtab.Controls.Add($FormLabelI)


$FenetreValidation.Controls.Add($ButtonRetourCSV4)
$FenetreValidation.Controls.Add($FormLabelJ)
$FenetreValidation.Controls.Add($FormLabelK)


############
### show ###
############

$FenetreCreationCSV.ShowDialog()