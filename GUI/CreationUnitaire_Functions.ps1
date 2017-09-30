Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$labelData = New-Object System.Windows.Forms.Label
$labelDataNonValide = New-Object System.Windows.Forms.Label
$labelFormation = New-Object System.Windows.Forms.Label
$comboBoxFormation = New-Object System.Windows.Forms.ComboBox
$labelSite = New-Object System.Windows.Forms.Label
$comboBoxSite = New-Object System.Windows.Forms.ComboBox
$buttonCreerCompte = New-Object System.Windows.Forms.Button

$buttonValider = New-Object System.Windows.Forms.Button
$TextBoxCodeStagiaire = New-Object System.Windows.Forms.TextBox
$TextBoxNom = New-Object System.Windows.Forms.TextBox
$TextBoxPrenom = New-Object System.Windows.Forms.TextBox
$TextBoxDateNaissance = New-Object System.Windows.Forms.TextBox
$TextBoxdebutde = New-Object System.Windows.Forms.TextBox
$TextBoxdateFin = New-Object System.Windows.Forms.TextBox
$TextBoxEmailCampus = New-Object System.Windows.Forms.TextBox

$LabelCodeStagiaire = New-Object System.Windows.Forms.Label
$LabelNom = New-Object System.Windows.Forms.Label
$LabelPrenom = New-Object System.Windows.Forms.Label
$LabelDateNaissance = New-Object System.Windows.Forms.Label
$Labeldebutde = New-Object System.Windows.Forms.Label
$LabeldateFin = New-Object System.Windows.Forms.Label
$LabelEmailCampus = New-Object System.Windows.Forms.Label

$labelPlateformes = New-Object System.Windows.Forms.Label
$listBoxplateformes = New-Object System.Windows.Forms.checkedListBox

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

Function validerData {
    if ($TextBoxCodeStagiaire.TextLength -eq 0 -or $TextBoxNom.TextLength -eq 0 -or $script:TextBoxCodeStagiaire.TextLength -eq 0 -or $script:TextBoxNom.TextLength -eq 0 -or $script:TextBoxPrenom.TextLength -eq 0 -or $script:TextBoxDateNaissance.TextLength -eq 0 -or $script:TextBoxdebutde.TextLength -eq 0 -or $script:TextBoxdateFin.TextLength -eq 0 -or $script:TextBoxEmailCampus.TextLength -eq 0)
    {
        $erreur = 1
        $labelDataNonValide.visible = $true
    }
    else
    {
        $labelDataNonValide.visible = $false
        $script:labelSite.visible = $true
        $script:comboboxSite.Visible = $true
        FillComboBox $script:comboBoxSite $script:sites "nom"
        $script:comboBoxSite.SelectedIndex = -1
        $script:comboBoxSite.add_SelectedIndexChanged({FillFormation})
    }
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
    $script:comboBoxFormation.add_SelectedIndexChanged({$script:buttonCreerCompte.visible = $true;$script:listBoxPlateformes.visible = $true; $labelPlateformes.visible = $true ;FillPlateforme;FillPlateforme;})
}

Function FillPlateforme {
    #afficher les droits de création et réinitialisation de compte en lien avec le profil et en fonction du nombre de plateformes

    # creation de la datatable
    $table = New-Object system.Data.DataTable
		
    # definition des colonnes
    $colId = New-Object system.Data.DataColumn "id",([string])
    $colPlateforme = New-Object system.Data.DataColumn "nom",([string])
 
    # table des colonnes à la datatable
    $table.Columns.Add($colId)
    $table.Columns.Add($colPlateforme)

    # alimentation de la datatable avec les plateformes
    $reqSel = "select pf.id, p.nom, pf.defaut from ass_plateforme_formation pf"
    $reqSel += " join plateforme p on p.id = pf.plateforme where pf.formation = " + $script:ComboBoxFormation.SelectedItem.id + " order by pf.formation ;"

    $listPlateformes = MakeRequest $reqSel
    foreach($listPlateforme in $listPlateformes) {
        $ligne = $table.NewRow()
        $ligne.id = $listPlateforme.id
        $ligne.nom = $listPlateforme.nom
        $table.Rows.Add($ligne)
    }

    $script:listBoxPlateformes.DisplayMember = "nom"
    $script:listBoxPlateformes.ValueMember = "id"
    $script:listBoxPlateformes.DataSource = $table    

    for($i=0;$i -lt $script:listBoxPlateformes.Items.Count; $i++) {
        $dp = RetreiveRow $listPlateformes "id" $script:listBoxPlateformes.Items[$i].id
        $script:listBoxPlateformes.SetItemChecked($i, $dp.defaut)
    }
}

Function MakeForm {
    $listForm = New-Object System.Windows.Forms.Form
    $listForm.Text = "Création de comptes stagiaires"
    $listForm.Size = New-Object System.Drawing.Size(1000,700)
    $listForm.StartPosition = "CenterScreen"

    $placementHauteur = 20
    $placementLargeurLabel = 30
    $placementLargeurText = 140

    $labelData.Location = New-Object System.Drawing.Point($placementLargeurLabel,$placementHauteur)
    $labelData.Size = New-Object System.Drawing.Size(300,22)
    $labelData.Text = "1. Entrez les informations concernant le stagiaire"
    $labelData.Visible = $true

    $placementHauteur = $placementHauteur + 40
    
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

    $script:labelEmailCampus.Location = New-Object System.Drawing.Point($placementLargeurLabel,$placementHauteur)
    $script:labelEmailCampus.Size = New-Object System.Drawing.Size(100,22)
    $script:labelEmailCampus.text = "EmailCampus"
    $script:labelEmailCampus.Visible = $true

    $script:textBoxEmailCampus.Location = New-Object System.Drawing.Point($placementLargeurText,$placementHauteur)
    $script:textBoxEmailCampus.Size = New-Object System.Drawing.Size(200,20)
    $script:textBoxEmailCampus.Visible = $true

    $placementHauteur = $placementHauteur + 40
    $placementLargeurButton = $placementLargeurText + 130

    $script:buttonValider.Location = New-Object System.Drawing.Point($placementLargeurButton,$placementHauteur)
    $script:buttonValider.Size = New-Object System.Drawing.Size(70,22)
    $script:buttonValider.Text = "Valider"
    $script:buttonValider.Add_Click({validerData})
    $script:buttonValider.Visible = $true

    $placementHauteur = $placementHauteur + 40

    $labelDataNonValide.Location = New-Object System.Drawing.Point($placementLargeurLabel,$placementHauteur)
    $labelDataNonValide.Size = New-Object System.Drawing.Size(200,22)
    $labelDataNonValide.Text = "Erreur : Un champ est vide."
    $labelDataNonValide.Visible = $false

    $labelSite.Location = New-Object System.Drawing.Point(500,20)
    $labelSite.Size = New-Object System.Drawing.Size(200,22)
    $labelSite.Text = "2. Choisir le site"
    $labelSite.Visible = $false

    $script:comboBoxSite.Location = New-Object System.Drawing.Point(500,45)
    $script:comboBoxSite.Size = New-Object System.Drawing.Size(200,22)
    $script:comboBoxSite.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
    $script:comboBoxSite.Visible = $false

    $labelFormation.Location = New-Object System.Drawing.Point(705,20)
    $labelFormation.Size = New-Object System.Drawing.Size(200,22)
    $labelFormation.Text = "3. Choisir la formation"
    $labelFormation.Visible = $false
    
    $script:comboBoxFormation.Location = New-Object System.Drawing.Point(705,45)
    $script:comboBoxFormation.Size = New-Object System.Drawing.Size(200,22)
    $script:comboBoxFormation.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
    $script:comboBoxFormation.Visible = $false

    $labelPlateformes.Location = New-Object System.Drawing.Point(500,100)
    $labelPlateformes.Size = New-Object System.Drawing.Size(200,22)
    $labelPlateformes.Text = "4. Sélectionner les comptes a créer"
    $labelPlateformes.Visible = $false
    
    $script:listBoxplateformes.Location = New-Object System.Drawing.Point(500,125)
    $script:listBoxplateformes.Size = New-Object System.Drawing.Size(180,210)
    $script:listBoxplateformes.CheckOnClick = $true
    #$script:listBoxplateformes.Add_ItemCheck({ModifyFormationPlateformes})
    $script:listBoxplateformes.visible = $false

    $ButtonRetour = New-Object System.Windows.Forms.Button
    $ButtonRetour.Location = New-Object System.Drawing.Point(20,580)
    $ButtonRetour.Size = New-Object System.Drawing.Size(150,60)
    $ButtonRetour.Text = "Retour"
    $ButtonRetour.Add_Click({$listForm.Close()})
    # la touche echap est mappée sur retour
    $listForm.CancelButton = $ButtonRetour

    $script:buttonCreerCompte.Location = New-Object System.Drawing.Point(815,580)
    $script:buttonCreerCompte.Size = New-Object System.Drawing.Size(150,60)
    $script:buttonCreerCompte.Text = "Créer le compte"
    $script:buttonCreerCompte.Add_Click({SelectPlateformes; $listForm.Close()})
    $script:buttonCreerCompte.Visible = $false
    # la touche entrée est mappée sur importer
    $listForm.AcceptButton = $script:buttonCreerCompte

    # MonthCalendar
#$monthCal = New-Object System.Windows.Forms.MonthCalendar
#$monthCal.Location = "8,24"
#$monthCal.MinDate = New-Object System.DateTime(2013, 1, 1)
#$monthCal.MinDate = "01/01/2012"    # Minimum Date Dispalyed
#$monthCal.MaxDate = "12/31/2013"    # Maximum Date Dispalyed
#$monthCal.MaxSelectionCount = 1     # Max number of days that can be selected
#$monthCal.ShowToday = $false        # Show the Today Banner at bottom
#$monthCal.ShowTodayCircle = $true   # Circle Todays Date
#$monthCal.FirstDayOfWeek = "Sunday" # Which Day of the Week in the First Column
#$monthCal.ScrollChange = 1          # Move number of months at a time with arrows
#$monthCal.ShowWeekNumbers = $false  # Show week numbers to the left of each week

    $listForm.Controls.Add($labelSite)
    $listForm.Controls.Add($script:comboBoxSite)
    $listForm.Controls.Add($labelFormation)
    $listForm.Controls.Add($script:comboBoxFormation)
    $listForm.Controls.Add($ButtonRetour)
    $listForm.Controls.Add($script:buttonCreerCompte)

    $listForm.Controls.Add($labelData)
    $listForm.Controls.Add($labelDataNonValide)
    $listForm.Controls.Add($script:LabelCodeStagiaire)
    $listForm.Controls.Add($script:LabelNom)
    $listForm.Controls.Add($script:LabelPrenom)
    $listForm.Controls.Add($script:LabelDateNaissance)
    $listForm.Controls.Add($script:Labeldebutde)
    $listForm.Controls.Add($script:LabeldateFin)
    $listForm.Controls.Add($script:LabelEmailCampus)


    $listForm.Controls.Add($script:TextBoxCodeStagiaire)
    $listForm.Controls.Add($script:TextBoxNom)
    $listForm.Controls.Add($script:TextBoxPrenom)
    $listForm.Controls.Add($script:TextBoxDateNaissance)
    $listForm.Controls.Add($script:TextBoxdebutde)
    $listForm.Controls.Add($script:TextBoxdateFin)
    $listForm.Controls.Add($script:TextBoxEmailCampus)

    $listForm.Controls.Add($script:buttonValider)
    $listForm.Controls.Add($script:labelPlateformes)
    $listForm.Controls.Add($script:listBoxPlateformes)
    
    # Afficher la fenetre
    $listForm.ShowDialog()
}