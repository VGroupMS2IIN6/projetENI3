Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$textBoxFichier = New-Object System.Windows.Forms.TextBox
$labelFormation = New-Object System.Windows.Forms.Label
$comboBoxFormation = New-Object System.Windows.Forms.ComboBox
$labelSite = New-Object System.Windows.Forms.Label
$comboBoxSite = New-Object System.Windows.Forms.ComboBox
$dataGridView = New-Object System.Windows.Forms.DataGridView
$buttonImporter = New-Object System.Windows.Forms.Button

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

Function FillDataGrid {
    $script:dataGridView.Rows.Clear()
    $script:dataGridView.Columns.Clear()
    $script:dataGridView.Visible = $false
    $script:buttonImporter.Visible = $false

    if($script:comboBoxFormation.SelectedIndex -ne -1) {
        # on affiche la datagrid et le bouton importer
        $script:dataGridView.Visible = $true
        $script:buttonImporter.Visible = $true

        # ajoute les colonnes nom et prénom
        $colCheckLigne = New-Object System.Windows.Forms.DataGridViewCheckBoxColumn
        $colCheckLigne.Width = 70
        $script:dataGridView.Columns.Add($colCheckLigne)
        $colNom = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
        $colNom.Width = 120
        $colNom.Name = "Nom"
        $colNom.ReadOnly = $true
        $script:dataGridView.Columns.Add($colNom)
        $colPrenom = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
        $colPrenom.Width = 120
        $colPrenom.Name = "Prénom"
        $colPrenom.ReadOnly = $true
        $script:dataGridView.Columns.Add($colPrenom)
    
        # ajout des colonnes à partir de la liste des plateformes
        foreach($plateforme in $plateformes) {
            $col = New-Object System.Windows.Forms.DataGridViewCheckBoxColumn
            $col.Width = 70
            $col.Name = $plateforme.nom
            $script:dataGridView.Columns.Add($col)
        }

        # on ajoute une première ligne pour permettre de cocher les colonnes
        $script:dataGridView.Rows.Add($false,"","")

        # on récupère la liste des plateformes filtrées en fonction de la formation sélectionnée
        $reqSel = "select p.* from plateforme p"
        $reqSel += " join ass_plateforme_formation pf on pf.plateforme = p.id"
        $reqSel += " where pf.defaut = 1"
        $reqSel += " and pf.formation = " + $script:comboBoxFormation.SelectedItem.id
        $plateformesDefaut = MakeRequest $reqSel

        #conversion du CSV en unicode pour traitement et import
        Get-Content $script:textBoxFichier.Text -encoding string | Out-File -FilePath ..\temp\import.csv -Encoding Unicode
        # retrait des doublons
        Import-Csv ..\temp\import.csv | Sort-Object CodeStagiaire -Unique | Sort-Object Nom | Export-Csv ..\temp\import_traite.csv -NoTypeInformation -encoding "unicode"
        # lecture du fichier csv
        $fichier = Import-Csv ..\temp\import_traite.csv
        rm ..\temp\import.csv
        foreach($row in $fichier) {
            $script:dataGridView.Rows.Add($false, $row.nom, $row.prenom)
        
            foreach($plateformeDefault in $plateformesDefaut) {
                for($i=0;$i -lt $script:dataGridView.ColumnCount;$i++) {
                    if($script:dataGridView.Columns[$i].Name -eq $plateformeDefault.nom) {
                        $script:dataGridView.Rows[$script:dataGridView.Rows.Count - 1].Cells[$i].Value = $true
                    }
                }
            }
        }
        rm ..\temp\import_traite.csv

        # on ajoute un event click
        $dataGridView.Add_CurrentCellDirtyStateChanged({
            param($Sender,$EventArgs)

            if($Sender.IsCurrentCellDirty){
                $Sender.CommitEdit([System.Windows.Forms.DataGridViewDataErrorContexts]::Commit)
            }
        })
        $dataGridView.Add_CellValueChanged({
            param($Sender,$EventArgs)

            $etat = $script:dataGridView.Rows[$EventArgs.RowIndex].Cells[$EventArgs.ColumnIndex].Value

            if($EventArgs.RowIndex -eq 0 -and $EventArgs.ColumnIndex -gt 2) {
                # on veut modifier l'état de toute une colonne
                for($i = 1;$i -lt $script:dataGridView.RowCount;$i++) {
                    $script:dataGridView.Rows[$i].Cells[$EventArgs.ColumnIndex].Value = $etat
                }
            }
            if($EventArgs.ColumnIndex -eq 0 -and $EventArgs.RowIndex -gt 0) {
                # on veut modifier l'état de toute une ligne
                for($j = 3;$j -lt $script:dataGridView.ColumnCount;$j++) {
                    $script:dataGridView.Rows[$EventArgs.RowIndex].Cells[$j].Value = $etat
                }
            }
        })
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
    $script:comboBoxFormation.add_SelectedIndexChanged({FillDataGrid})
}

Function ImporterCSV {
    #TODO : réaliser les différentes moulinettes

    $typeBouton = [System.Windows.Forms.MessageBoxButtons]::OK
    $typeIcone = [System.Windows.Forms.MessageBoxIcon]::Information
    [System.Windows.Forms.MessageBox]::Show("L'import est terminé", "Information", $typeBouton, $typeIcone)
}

Function Parcourir {
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Filter = "CSV (*.csv)| *.csv"
    $openFileDialog.ShowDialog()

    # on récupère le nom du fichier pour l'afficher dans le champ
    $script:textBoxFichier.Text = $openFileDialog.filename

    # on affiche la sélection du site
    $script:labelSite.Visible = $true
    $script:comboBoxSite.Visible = $true
    FillComboBox $script:comboBoxSite $script:sites "nom"
    $script:comboBoxSite.SelectedIndex = -1
    $script:comboBoxSite.add_SelectedIndexChanged({FillFormation})
}

Function MakeForm {
    $listForm = New-Object System.Windows.Forms.Form
    $listForm.Text = "Création de comptes stagiaires"
    $listForm.Size = New-Object System.Drawing.Size(1000,700)
    $listForm.StartPosition = "CenterScreen"
    
    $labelFichier = New-Object System.Windows.Forms.Label
    $labelFichier.Location = New-Object System.Drawing.Point(20,20)
    $labelFichier.Size = New-Object System.Drawing.Size(400,22)
    $labelFichier.Text = "1. Sélectionner le CSV provenant du CRM de l'ENI"

    $ButtonParcourir = New-Object System.Windows.Forms.Button
    $ButtonParcourir.Location = New-Object System.Drawing.Point(20,45)
    $ButtonParcourir.Size = New-Object System.Drawing.Size(70,22)
    $ButtonParcourir.Text = 'Parcourir'
    $ButtonParcourir.add_Click({Parcourir})

    $script:textBoxFichier.Location = New-Object System.Drawing.Point(95,45)
    $script:textBoxFichier.Size = New-Object System.Drawing.Size(400,22)
    
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

    $script:dataGridView.Location = New-Object System.Drawing.Point(20,80)
    $script:dataGridView.Size = New-Object System.Drawing.Size(940,485)
    $script:dataGridView.MultiSelect = $false
    $script:dataGridView.ColumnHeadersVisible = $true
    $script:dataGridView.RowHeadersVisible = $true
    $script:dataGridView.Visible = $false
    $script:dataGridView.AllowUserToAddRows = $false
    $script:dataGridView.AllowUserToDeleteRows = $false

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

    $listForm.Controls.Add($labelFichier)
    $listForm.Controls.Add($script:textBoxFichier)
    $listForm.Controls.Add($ButtonParcourir)
    $listForm.Controls.Add($labelSite)
    $listForm.Controls.Add($script:comboBoxSite)
    $listForm.Controls.Add($labelFormation)
    $listForm.Controls.Add($script:comboBoxFormation)
    $listForm.Controls.Add($script:dataGridView)
    $listForm.Controls.Add($ButtonRetour)
    $listForm.Controls.Add($script:buttonImporter)

    # Afficher la fenetre
    $listForm.ShowDialog()
}