cls
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -Path '..\libs\MySql.Data.dll'

# Initialisation des variables  
$serv = "192.168.1.2" # Addresse du serveur
$port = "3306" # Port de connexion (3306 par dÃ©faut)
$user = "vgroup"  # nom d'utilisateur pour la connexion
$password = "vgrouproxx" # mot de passe
$db = "projet_eni" # nom de la base de donnÃ©e
$global:OpenFileDialog = ""

# Chargement de la fonction de co à la DB
. "../ps/fg_1-1_DBUtils.ps1"

#Fabrication du tableau
function CreatTableauSelectionStag (){
    $script:dataGridView = New-Object System.Windows.Forms.DataGridView
    $script:dataGridView.Location = '30,120'
    $script:dataGridView.Size=New-Object System.Drawing.Size(920,450)

    #Create an unbound DataGridView by declaring a column count.
    $script:dataGridView.ColumnCount = 6
    $script:dataGridView.ColumnHeadersVisible = $true
    $script:dataGridView.Columns.Insert(0, (New-Object System.Windows.Forms.DataGridViewCheckBoxColumn))
    $script:dataGridView.Columns.Insert(3, (New-Object System.Windows.Forms.DataGridViewCheckBoxColumn))
    $script:dataGridView.Columns.Insert(4, (New-Object System.Windows.Forms.DataGridViewCheckBoxColumn))
    $script:dataGridView.Columns.Insert(5, (New-Object System.Windows.Forms.DataGridViewCheckBoxColumn))
    $script:dataGridView.Columns.Insert(6, (New-Object System.Windows.Forms.DataGridViewCheckBoxColumn))
    $script:dataGridView.Columns.Insert(7, (New-Object System.Windows.Forms.DataGridViewCheckBoxColumn))

    #Set the column header names.
    $script:dataGridView.Columns[0].Name = "Select"
    $script:dataGridView.Columns[1].Name = "Prénom"
    $script:dataGridView.Columns[2].Name = "Nom"
    $script:dataGridView.Columns[3].Name = "Active Directory"
    $script:dataGridView.Columns[4].Name = "Office 365"
    $script:dataGridView.Columns[5].Name = "NetAcad"
    $script:dataGridView.Columns[6].Name = "MEDIAplus"
    $script:dataGridView.Columns[7].Name = "7Speaking"
    $script:dataGridView.Columns[8].Name = "ID_CRM"
    $script:dataGridView.Columns[9].Name = "DateNaissance"
    $script:dataGridView.Columns[10].Name = "debutde"
    $script:dataGridView.Columns[11].Name = "dateFin"

    $script:dataGridView.Columns[8].Visible = $false
    $script:dataGridView.Columns[9].Visible = $false
    $script:dataGridView.Columns[10].Visible = $false
    $script:dataGridView.Columns[11].Visible = $false
	
    $script:rows = @()
    foreach ($a in $global:CSVContent){
        #[System.Windows.Forms.MessageBox]::Show($a.Nom, "row")
        $script:rows += ,@($false , $a.prenom , $a.nom ,$false , $false, $false ,$true ,$false, $a.codestagiaire, $a.DateNaissance, $a.debutde, $a.dateFin)
    }

    <#
    #Populate the rows.
    $row1 = @($null,"Main Dish", "boringMeatloaf", $null, $null,$null,$null,$null)
    $row2 = @($null,"Dessert", "lime juice evaporated milk", $null, $null,$null,$null,$null)
    $row3 = @($true,"Main Dish", "pork chops, salsa, orange juice", $null, $null,$null,$null,$null)
    $row4 = @($null,"Salad", "black beans, brown rice", $null, $null,$null,$null,$null)
    $row5 = @($null,"Dessert", "cream cheese", $null, $null,$null,$null,$null)
    $row6 = @($null, "Appetizer","black beans, sour cream", $null, $null,$null,$null,$null)
    $rows = @( $row1, $row2, $row3, $row4, $row5, $row6 )
    #>	

    foreach ($row in $script:rows){
        #[System.Windows.Forms.MessageBox]::Show($row[0] + $row[1] + $row[2], "row")
        $script:dataGridView.Rows.Add($row)
    }
}

function ReadTableauSelectionStag (){

    $script:comptesAD = @()
    [System.Windows.Forms.MessageBox]::Show("couou", "nom")
    [System.Windows.Forms.MessageBox]::Show($script:dataGridView.Rows[1].Cells[3].Value.toString(), "site")


    # Préparation des comptes à créer
        foreach ($script:b in $script:dataGridView.Rows){
        #$b.Cells[1].Value 
        #[System.Windows.Forms.MessageBox]::Show($script:b.Cells[2].Value, "nom")
        #[System.Windows.Forms.MessageBox]::Show($script:b.Cells[3].Value.tostring(), "AD true?")

        # Active Directory
        if ($script:b.Cells[3].Value.tostring() -like "True"){ 
            #[System.Windows.Forms.MessageBox]::Show($script:b.Cells[2].Value, "nom")  
            #[System.Windows.Forms.MessageBox]::Show($script:b.Cells[3].Value.tostring(), "true?")  
            $script:comptesAD += ,($script:b.Cells[1].Value, $script:b.Cells[2].Value ,"FORMATION" ,  $script:b.Cells[8].Value ,  $script:b.Cells[10].Value , $script:b.Cells[11].Value , $script:b.Cells[9].Value)          
        }

        # Office 365
        if ($b.Cells[4].Value -eq $true){
            $script:comptesOffice365 += @($b.Cells[1].Value, $b.Cells[2].Value)
        }

        # NetAcad
        if ($b.Cells[5].Value -eq $true){
          
        }

        # MEDIAplus
        if ($b.Cells[6].Value -eq $true){
          
        }

        # 7Speaking
        if ($b.Cells[7].Value -eq $true){
          
        }

        <# Pour event lors case cochée
        $listBoxProfils.CheckOnClick = $true
        # ajouter l'enregistrement en base de chaque case cochée.
        $listBoxProfils.Add_ItemCheck({ModifyProfilUtilisateur})
        #> 

    }  
    

    # Création des comptes
    echo "foreach"
    foreach ($script:c in $script:comptesAD){
    #[System.Windows.Forms.MessageBox]::Show($script:c, "row")
    #. "..\ps\fg_9-1_CreationComptesAD_PS.ps1 " $script:c
    }
}



# Extraction des info du CSV ; utilisé dans la fenetre de création du tableau
function extractCSV (){
    #$ListBoxtab.text = $("Formation : " + $global:Formation)
    #echo $("Formation : " + $global:Formation)
    #echo $("Formation : " + $global:Site)
    #echo $("Path : " + $global:OpenFileDialog.Filename)
    #[System.Windows.Forms.MessageBox]::Show($global:Site, "site")
    #[System.Windows.Forms.MessageBox]::Show($global:Formation, "formation")
    #[System.Windows.Forms.MessageBox]::Show($global:OpenFileDialog.Filename, "Path")
     
     $global:CSVContent = Import-csv -path $global:OpenFileDialog.Filename
     CreatTableauSelectionStag
}

# Creation de l'instance, connexion Ã  la base de donnÃ©es  
$mysql = New-Object MySql.Data.MySqlClient.MySqlConnection("server=" + $serv + ";port=" + $port + ";uid=" + $user + ";pwd=" + $password + ";database=" + $db + ";Pooling=False")  
$mysql.Open()
# recuperation de la liste des formations
$formation = MakeRequest "SELECT * FROM formation"
$site = MakeRequest "SELECT * FROM site"

#########################
### FENETRES  CSV  ###
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


# Raccourcis clavier : entrée pour valider ; Esc pour quitter

$FenetreCreationCSV.KeyPreview = $True
$FenetreCreationCSV.Add_KeyDown({if ($_.KeyCode -eq "Enter") 
    {$x=$FenetreCreationCSV.Text;$FenetreCreationCSV.Close()}})
$FenetreCreationCSV.Add_KeyDown({if ($_.KeyCode -eq "Escape") 
    {$FenetreCreationCSV.Close()}})

# Raccourcis clavier : entrée pour valider ; Esc pour quitter

$FenetreSelection.KeyPreview = $True
$FenetreSelection.Add_KeyDown({if ($_.KeyCode -eq "Enter") 
    {$x=$FenetreSelection.Text;$FenetreSelection.Close()}})
$FenetreSelection.Add_KeyDown({if ($_.KeyCode -eq "Escape") 
    {$FenetreSelection.Close()}})

# Raccourcis clavier : entrée pour valider ; Esc pour quitter

$FenetreCreationtab.KeyPreview = $True
$FenetreCreationtab.Add_KeyDown({if ($_.KeyCode -eq "Enter") 
    {$x=$FenetreCreationtab.Text;$FenetreCreationtab.Close()}})
$FenetreCreationtab.Add_KeyDown({if ($_.KeyCode -eq "Escape") 
    {$FenetreCreationtab.Close()}})

# Raccourcis clavier : entrée pour valider ; Esc pour quitter

$FenetreValidation.KeyPreview = $True
$FenetreValidation.Add_KeyDown({if ($_.KeyCode -eq "Enter") 
    {$x=$FenetreValidation.Text;$FenetreValidation.Close()}})
$FenetreValidation.Add_KeyDown({if ($_.KeyCode -eq "Escape") 
    {$FenetreValidation.Close()}})

#####################################
### ELEMENTS FENETRES CREATION (SELECTION du fichier) CSV ###
#####################################

# Apparition de la fenetre de dialogue de sélection du CSV
function ButtonParcourirCSV_Click() {
    $global:OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $global:OpenFileDialog.filter = "CSV (*.csv)| *.csv"
    $global:OpenFileDialog.ShowDialog() #| Out-Null
    $FileName = Split-Path $global:OpenFileDialog.filename -leaf
    $TextboxFileCSV.Text = $FileName
    return $global:OpenFileDialog.filename
}

# Elements graphiques
$ButtonRetourCSV = New-Object System.Windows.Forms.Button
$ButtonRetourCSV.Location = '40,600'
$ButtonRetourCSV.Size = '150,40'
$ButtonRetourCSV.Text = 'Retour'
$ButtonRetourCSV.add_Click($ButtonRetourCSV_Click)
$ButtonRetourCSV_Click = {
    $FenetreCreationCSV.Visible = $False
    $FenetreAccueil.Visible = $True
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
$ButtonParcourirCSV.add_Click({ButtonParcourirCSV_Click})

$TextboxFileCSV = New-Object System.Windows.Forms.Textbox 
$TextboxFileCSV.Location = '400,292'
$TextboxFileCSV.Size = '250,400'
$TextboxFileCSV.Height = 60
$TextboxFileCSV.Text = $OpenFileDialog.filename

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


#####################################################
### ELEMENTS FENETRES SELECTION FORMATION et SITE  ###
####################################################

function FillComboBoxFormation {
    # creation de la datatable
    $table = New-Object system.Data.DataTable
		
    # definition des colonnes
    $colId = New-Object system.Data.DataColumn "id",([string])
    $colNom = New-Object system.Data.DataColumn "nom",([string])
 
    # table des colonnes à la datatable
    $table.Columns.Add($colId)
    $table.Columns.Add($colNom)

    # alimentation de la datatable avec les formations
    foreach($formation in $script:formation) {
        $ligne = $table.NewRow()
        $ligne.id = $formation.ID
        $ligne.nom = $formation.nom
        $table.Rows.Add($ligne)
    }

    $script:ComboBoxFormation.DisplayMember = "nom"
    $script:ComboBoxFormation.ValueMember = "id"
    $script:ComboBoxFormation.DataSource = $table
}

function FillComboBoxSite {
    # creation de la datatable
    $table = New-Object system.Data.DataTable
		
    # definition des colonnes
    $colId = New-Object system.Data.DataColumn "id",([string])
    $colNom = New-Object system.Data.DataColumn "nom",([string])
 
    # table des colonnes à la datatable
    $table.Columns.Add($colId)
    $table.Columns.Add($colNom)

    # alimentation de la datatable avec les sites
    foreach($site in $script:site) {
        $ligne = $table.NewRow()
        $ligne.id = $site.ID
        $ligne.nom = $site.nom
        $table.Rows.Add($ligne)
    }

    $script:ComboBoxSite.DisplayMember = "nom"
    $script:ComboBoxSite.ValueMember = "id"
    $script:ComboBoxSite.DataSource = $table
}

# Elements graphiques
$ButtonRetourCSV2 = New-Object System.Windows.Forms.Button
$ButtonRetourCSV2.Location = '40,600'
$ButtonRetourCSV2.Size = '150,40'
$ButtonRetourCSV2.Text = 'Retour'
$ButtonRetourCSV2.add_Click($ButtonRetourCSV2_Click)
$ButtonRetourCSV2_Click = {
    $FenetreSelection.Visible = $False
    $FenetreCreationCSV.Visible = $True
}

$ButtonSuivantCSV2 = New-Object System.Windows.Forms.Button
$ButtonSuivantCSV2.Location = '800,600'
$ButtonSuivantCSV2.Size = '150,40'
$ButtonSuivantCSV2.Text = 'Suivant'
$ButtonSuivantCSV2.add_Click($ButtonSuivantCSV2_Click)
$ButtonSuivantCSV2_Click = {    
    $FenetreSelection.Visible = $False
    $global:Formation = $script:ComboBoxFormation.text
    $global:Site = $script:ComboBoxSite.text
    extractCSV
    $FenetreCreationtab.ShowDialog()
}

$FormLabelD = New-Object System.Windows.Forms.Label
$FormLabelD.Location = '30,30'
$FormLabelD.Size = '400,40'
$FormLabelD.Text = "Creation de compte stagiaire (CSV) : "

$FormLabelE = New-Object System.Windows.Forms.Label
$FormLabelE.Location = '30,100'
$FormLabelE.Size = '400,40'
$FormLabelE.Text = "Selectionnez la formation puis le site associé."

$FormLabelF = New-Object System.Windows.Forms.Label
$FormLabelF.Location = '300,295'
$FormLabelF.Size = '150,60'
$FormLabelF.Text = "Formation :"

#Formation
$ComboBoxFormation = New-Object System.Windows.Forms.ComboBox
$ComboBoxFormation.Location = '450,295'
$ComboBoxFormation.Size = '250,400'
$ComboBoxFormation.Height = 60
FillComboBoxFormation

$FormLabelG = New-Object System.Windows.Forms.Label
$FormLabelG.Location = '300,410'
$FormLabelG.Size = '150,60'
$FormLabelG.Text = "Site :"

#Site
$ComboBoxSite = New-Object System.Windows.Forms.ComboBox
$ComboBoxSite.Location = '450,410'
$ComboBoxSite.Size = '150,60'
$ComboBoxSite.Height = 60
FillComboBoxSite

#####################################
### ELEMENTS FENETRES CREATION TAB ###
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
#$ButtonRetourCSV3.add_Click($ButtonRetourCSV3_Click)
$ButtonRetourCSV3.add_Click({[System.Windows.Forms.MessageBox]::Show($script:dataGridView.Rows[2].Cells[0].Value.toString(), "row")})
$ButtonRetourCSV3_Click = {
    $FenetreCreationtab.Visible = $False
	$FenetreSelection.Visible = $True
}

$ButtonSuivantCSV3 = New-Object System.Windows.Forms.Button
$ButtonSuivantCSV3.Location = '800,600'
$ButtonSuivantCSV3.Size = '150,40'
$ButtonSuivantCSV3.Text = 'Suivant'
$ButtonSuivantCSV3.add_Click($ButtonSuivantCSV3_Click)
$ButtonSuivantCSV3_Click = {
    #[System.Windows.Forms.MessageBox]::Show($dataGridView.Rows[2].Cells[0].Value.toString(), "row")
    $FenetreCreationtab.Visible = $False
    $FenetreValidation.Visible = $True
    $FenetreValidation.Refresh()
    ReadTableauSelectionStag
    
}














#####################################
### ELEMENTS FENETRE VALIDATION   ###
#####################################

#[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
#[reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null


$ButtonRetourCSV4 = New-Object System.Windows.Forms.Button
$ButtonRetourCSV4.Location = '40,230'
$ButtonRetourCSV4.Size = '150,40'
$ButtonRetourCSV4.Text = 'Annuler'
$ButtonRetourCSV4.add_Click($ButtonRetourCSV4_Click)
$ButtonRetourCSV4_Click = {
    $FenetreValidation.Visible = $False
	$FenetreCreationCSV.Visible = $True
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
$FenetreCreationCSV.Controls.Add($TextboxFileCSV)
$FenetreCreationCSV.Controls.Add($FormLabelA)
$FenetreCreationCSV.Controls.Add($FormLabelB)
$FenetreCreationCSV.Controls.Add($FormLabelC)

$FenetreSelection.Controls.Add($ButtonRetourCSV2)
$FenetreSelection.Controls.Add($ButtonSuivantCSV2)
$FenetreSelection.Controls.Add($FormLabelD)
$FenetreSelection.Controls.Add($FormLabelE)
$FenetreSelection.Controls.Add($FormLabelF)
$FenetreSelection.Controls.Add($FormLabelG)
$FenetreSelection.Controls.Add($ComboBoxFormation)
$FenetreSelection.Controls.Add($ComboBoxSite)

$FenetreCreationtab.Controls.Add($ButtonRetourCSV3)
$FenetreCreationtab.Controls.Add($ButtonSuivantCSV3)
$FenetreCreationtab.Controls.Add($ListBoxtab)
$FenetreCreationtab.Controls.Add($FormLabelH)
$FenetreCreationtab.Controls.Add($FormLabelI)
$FenetreCreationtab.Controls.Add($script:dataGridView)

$FenetreValidation.Controls.Add($ButtonRetourCSV4)
$FenetreValidation.Controls.Add($FormLabelJ)
$FenetreValidation.Controls.Add($FormLabelK)
$FenetreValidation.Controls.Add($progressBar)


############
### show ###
############

$FenetreCreationCSV.ShowDialog()

$mysql.Close()