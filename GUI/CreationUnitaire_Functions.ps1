Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$labelFormation = New-Object System.Windows.Forms.Label
$comboBoxFormation = New-Object System.Windows.Forms.ComboBox
$labelSite = New-Object System.Windows.Forms.Label
$comboBoxSite = New-Object System.Windows.Forms.ComboBox
$buttonImporter = New-Object System.Windows.Forms.Button

$TextBoxCodeStagiaire = New-Object System.Windows.Forms.TextBox
$TextBoxNom = New-Object System.Windows.Forms.TextBox
$TextBoxPrenom = New-Object System.Windows.Forms.TextBox
$TextBoxDateNaissance = New-Object System.Windows.Forms.TextBox
$TextBoxdebutde = New-Object System.Windows.Forms.TextBox
$TextBoxdateFin = New-Object System.Windows.Forms.TextBox
$TextBoxCodePlanning = New-Object System.Windows.Forms.TextBox
$TextBoxCodeFormation = New-Object System.Windows.Forms.TextBox
$TextBoxCodePromotion = New-Object System.Windows.Forms.TextBox
$TextBoxEmailCampus = New-Object System.Windows.Forms.TextBox
$TextBoxSAMAccountName = New-Object System.Windows.Forms.TextBox

$LabelCodeStagiaire = New-Object System.Windows.Forms.Label
$LabelNom = New-Object System.Windows.Forms.Label
$LabelPrenom = New-Object System.Windows.Forms.Label
$LabelDateNaissance = New-Object System.Windows.Forms.Label
$Labeldebutde = New-Object System.Windows.Forms.Label
$LabeldateFin = New-Object System.Windows.Forms.Label
$LabelCodePlanning = New-Object System.Windows.Forms.Label
$LabelCodeFormation = New-Object System.Windows.Forms.Label
$LabelCodePromotion = New-Object System.Windows.Forms.Label
$LabelEmailCampus = New-Object System.Windows.Forms.Label
$LabelSAMAccountName = New-Object System.Windows.Forms.Label

function FillComboBox([System.Windows.Forms.ComboBox] $comboBox, $elems, $nomCol) {
    # creation de la datatable
    $table = New-Object System.Data.DataTable
		
    # definition des colonnes
    $colId = New-Object System.Data.DataColumn "id",([int])
    $colLib = New-Object System.Data.DataColumn $nomCol,([string])
 
    # table des colonnes à la datatable
    $table.Columns.Add($colId)
    $table.Columns.Add($colLib)

    # alimentation de la datatable avec les plateformes
    foreach($elem in $elems) {
        $ligne = $table.NewRow()
        $ligne.id = $elem.ID
        $ligne.$nomCol = $elem.$nomCol
        $table.Rows.Add($ligne)
    }

    $comboBox.DisplayMember = $nomCol
    $comboBox.ValueMember = "id"
    $comboBox.DataSource = $table
}

Function FillFormation {
    # on récupère la liste des formations filtrées en fonction du site sélectionné
    $reqSel = "select f.* from formation f"
    $reqSel += " join ass_formation_site fs on fs.formation = f.id"
    $reqSel += " where fs.existe = 1"
    $reqSel += " and fs.site = " + $script:comboBoxSite.SelectedItem.id
    $script:formations = MakeRequest $reqSel

    # on affiche la sélection du site
    $script:labelFormation.Visible = $true
    $script:comboBoxFormation.Visible = $true
    FillComboBox $script:comboBoxFormation $script:formations "nom"
    $script:comboBoxFormation.SelectedIndex = -1
    $script:comboBoxFormation.add_SelectedIndexChanged({FillDataGrid})
}

Function MakeForm {
    $listForm = New-Object System.Windows.Forms.Form
    $listForm.Text = "Création de comptes stagiaires"
    $listForm.Size = New-Object System.Drawing.Size(1000,700)
    $listForm.StartPosition = "CenterScreen"

    $placementHauteur = 100
    $placementLargeurLabel = 10
    $placementLargeurText = 120
    
    $script:labelCodeStagiaire.Location = New-Object System.Drawing.Point($placementLargeurLabel,$placementHauteur)
    $script:labelCodeStagiaire.Size = New-Object System.Drawing.Size(100,22)
    $script:labelCodeStagiaire.text = "CodeStagiaire"
    $script:labelCodeStagiaire.Visible = $true

    $script:textBoxCodeStagiaire.Location = New-Object System.Drawing.Point($placementLargeurText,$placementHauteur)
    $script:textBoxCodeStagiaire.Size = New-Object System.Drawing.Size(200,20)
    $script:textBoxCodeStagiaire.Visible = $true
    
    $placementHauteur = $placementHauteur + 40
    
    $script:labelNom.Location = New-Object System.Drawing.Point($placementLargeurLabel,$placementHauteur)
    $script:labelNom.Size = New-Object System.Drawing.Size(100,22)
    $script:labelNom.text = "Nom"
    $script:labelNom.Visible = $true

    $script:textBoxNom.Location = New-Object System.Drawing.Point($placementLargeurText,$placementHauteur)
    $script:textBoxNom.Size = New-Object System.Drawing.Size(200,20)
    $script:textBoxNom.Visible = $true

    $placementHauteur = $placementHauteur + 40

    $script:labelPrenom.Location = New-Object System.Drawing.Point($placementLargeurLabel,$placementHauteur)
    $script:labelPrenom.Size = New-Object System.Drawing.Size(100,22)
    $script:labelPrenom.text = "Prenom"
    $script:labelPrenom.Visible = $true

    $script:textBoxPrenom.Location = New-Object System.Drawing.Point($placementLargeurText,$placementHauteur)
    $script:textBoxPrenom.Size = New-Object System.Drawing.Size(200,20)
    $script:textBoxPrenom.Visible = $true

    $placementHauteur = $placementHauteur + 40

    $script:labelDateNaissance.Location = New-Object System.Drawing.Point($placementLargeurLabel,$placementHauteur)
    $script:labelDateNaissance.Size = New-Object System.Drawing.Size(100,22)
    $script:labelDateNaissance.text = "DateNaissance"
    $script:labelDateNaissance.Visible = $true

    $script:textBoxDateNaissance.Location = New-Object System.Drawing.Point($placementLargeurText,$placementHauteur)
    $script:textBoxDateNaissance.Size = New-Object System.Drawing.Size(200,20)
    $script:textBoxDateNaissance.Visible = $true

    $placementHauteur = $placementHauteur + 40

    $script:labeldebutde.Location = New-Object System.Drawing.Point($placementLargeurLabel,$placementHauteur)
    $script:labeldebutde.Size = New-Object System.Drawing.Size(100,22)
    $script:labeldebutde.text = "debutde"
    $script:labeldebutde.Visible = $true

    $script:textBoxdebutde.Location = New-Object System.Drawing.Point($placementLargeurText,$placementHauteur)
    $script:textBoxdebutde.Size = New-Object System.Drawing.Size(200,20)
    $script:textBoxdebutde.Visible = $true

    $placementHauteur = $placementHauteur + 40

    $script:labeldateFin.Location = New-Object System.Drawing.Point($placementLargeurLabel,$placementHauteur)
    $script:labeldateFin.Size = New-Object System.Drawing.Size(100,22)
    $script:labeldateFin.text = "dateFin"
    $script:labeldateFin.Visible = $true

    $script:textBoxdateFin.Location = New-Object System.Drawing.Point($placementLargeurText,$placementHauteur)
    $script:textBoxdateFin.Size = New-Object System.Drawing.Size(200,20)
    $script:textBoxdateFin.Visible = $true

    $placementHauteur = $placementHauteur + 40

    $script:labelCodePlanning.Location = New-Object System.Drawing.Point($placementLargeurLabel,$placementHauteur)
    $script:labelCodePlanning.Size = New-Object System.Drawing.Size(100,22)
    $script:labelCodePlanning.text = "CodePlanning"
    $script:labelCodePlanning.Visible = $true

    $script:textBoxCodePlanning.Location = New-Object System.Drawing.Point($placementLargeurText,$placementHauteur)
    $script:textBoxCodePlanning.Size = New-Object System.Drawing.Size(200,20)
    $script:textBoxCodePlanning.Visible = $true

    $placementHauteur = $placementHauteur + 40

    $script:labelCodeFormation.Location = New-Object System.Drawing.Point($placementLargeurLabel,$placementHauteur)
    $script:labelCodeFormation.Size = New-Object System.Drawing.Size(100,22)
    $script:labelCodeFormation.text = "CodeFormation"
    $script:labelCodeFormation.Visible = $true

    $script:textBoxCodeFormation.Location = New-Object System.Drawing.Point($placementLargeurText,$placementHauteur)
    $script:textBoxCodeFormation.Size = New-Object System.Drawing.Size(200,20)
    $script:textBoxCodeFormation.Visible = $true

    $placementHauteur = $placementHauteur + 40

    $script:labelCodePromotion.Location = New-Object System.Drawing.Point($placementLargeurLabel,$placementHauteur)
    $script:labelCodePromotion.Size = New-Object System.Drawing.Size(100,22)
    $script:labelCodePromotion.text = "CodePromotion"
    $script:labelCodePromotion.Visible = $true

    $script:textBoxCodePromotion.Location = New-Object System.Drawing.Point($placementLargeurText,$placementHauteur)
    $script:textBoxCodePromotion.Size = New-Object System.Drawing.Size(200,20)
    $script:textBoxCodePromotion.Visible = $true

    $placementHauteur = $placementHauteur + 40

    $script:labelEmailCampus.Location = New-Object System.Drawing.Point($placementLargeurLabel,$placementHauteur)
    $script:labelEmailCampus.Size = New-Object System.Drawing.Size(100,22)
    $script:labelEmailCampus.text = "EmailCampus"
    $script:labelEmailCampus.Visible = $true

    $script:textBoxEmailCampus.Location = New-Object System.Drawing.Point($placementLargeurText,$placementHauteur)
    $script:textBoxEmailCampus.Size = New-Object System.Drawing.Size(200,20)
    $script:textBoxEmailCampus.Visible = $true

    $placementHauteur = $placementHauteur + 40

    $script:labelSAMAccountName.Location = New-Object System.Drawing.Point($placementLargeurLabel,$placementHauteur)
    $script:labelSAMAccountName.Size = New-Object System.Drawing.Size(100,22)
    $script:labelSAMAccountName.text = "SAMAccountName"
    $script:labelSAMAccountName.Visible = $true

    $script:textBoxSAMAccountName.Location = New-Object System.Drawing.Point($placementLargeurText,$placementHauteur)
    $script:textBoxSAMAccountName.Size = New-Object System.Drawing.Size(200,20)
    $script:textBoxSAMAccountName.Visible = $true

    $labelSite.Location = New-Object System.Drawing.Point(500,20)
    $labelSite.Size = New-Object System.Drawing.Size(200,22)
    $labelSite.Text = "2. Choisir le site"
    $labelSite.Visible = $true

    $script:comboBoxSite.Location = New-Object System.Drawing.Point(500,45)
    $script:comboBoxSite.Size = New-Object System.Drawing.Size(200,22)
    $script:comboBoxSite.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
    $script:comboBoxSite.Visible = $true

    $labelFormation.Location = New-Object System.Drawing.Point(705,20)
    $labelFormation.Size = New-Object System.Drawing.Size(200,22)
    $labelFormation.Text = "3. Choisir la formation"
    $labelFormation.Visible = $false
    
    $script:comboBoxFormation.Location = New-Object System.Drawing.Point(705,45)
    $script:comboBoxFormation.Size = New-Object System.Drawing.Size(200,22)
    $script:comboBoxFormation.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
    $script:comboBoxFormation.Visible = $false

    $ButtonRetour = New-Object System.Windows.Forms.Button
    $ButtonRetour.Location = New-Object System.Drawing.Point(20,580)
    $ButtonRetour.Size = New-Object System.Drawing.Size(150,60)
    $ButtonRetour.Text = "Retour"
    $ButtonRetour.Add_Click({$listForm.Close()})
    # la touche echap est mappée sur retour
    $listForm.CancelButton = $ButtonRetour

    $script:buttonImporter.Location = New-Object System.Drawing.Point(815,580)
    $script:buttonImporter.Size = New-Object System.Drawing.Size(150,60)
    $script:buttonImporter.Text = "Importer"
    $script:buttonImporter.Add_Click({ImporterCSV; $listForm.Close()})
    $script:buttonImporter.Visible = $false
    # la touche entrée est mappée sur importer
    $listForm.AcceptButton = $script:buttonImporter

    $listForm.Controls.Add($labelSite)
    $listForm.Controls.Add($script:comboBoxSite)
    $listForm.Controls.Add($labelFormation)
    $listForm.Controls.Add($script:comboBoxFormation)
    $listForm.Controls.Add($ButtonRetour)
    $listForm.Controls.Add($script:buttonImporter)
    $listForm.Controls.Add($script:LabelNom)
    $listForm.Controls.Add($script:LabelPrenom)
    $listForm.Controls.Add($script:LabelDateNaissance)
    $listForm.Controls.Add($script:Labeldebutde)
    $listForm.Controls.Add($script:LabeldateFin)
    $listForm.Controls.Add($script:LabelCodePlanning)
    $listForm.Controls.Add($script:LabelCodeFormation)
    $listForm.Controls.Add($script:LabelCodePromotion)
    $listForm.Controls.Add($script:LabelEmailCampus)
    $listForm.Controls.Add($script:LabelSAMAccountName)
    $listForm.Controls.Add($script:LabelCodeStagiaire)

    $listForm.Controls.Add($script:TextBoxCodeStagiaire)
    $listForm.Controls.Add($script:TextBoxNom)
    $listForm.Controls.Add($script:TextBoxPrenom)
    $listForm.Controls.Add($script:TextBoxDateNaissance)
    $listForm.Controls.Add($script:TextBoxdebutde)
    $listForm.Controls.Add($script:TextBoxdateFin)
    $listForm.Controls.Add($script:TextBoxCodePlanning)
    $listForm.Controls.Add($script:TextBoxCodeFormation)
    $listForm.Controls.Add($script:TextBoxCodePromotion)
    $listForm.Controls.Add($script:TextBoxEmailCampus)
    $listForm.Controls.Add($script:TextBoxSAMAccountName)

    # Afficher la fenetre
    $listForm.ShowDialog()
}