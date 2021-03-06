Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$textBoxFichier = New-Object System.Windows.Forms.TextBox
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
 
    # table des colonnes � la datatable
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

        # ajoute les colonnes nom et pr�nom
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
        $colPrenom.Name = "Pr�nom"
        $colPrenom.ReadOnly = $true
        $script:dataGridView.Columns.Add($colPrenom)
        $colInformation = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
        $colInformation.Width = 120
        $colInformation.Name = "information"
        $colInformation.ReadOnly = $true
        $colInformation.Visible = $true
        $script:dataGridView.Columns.Add($colInformation)
        $colCodeStagiaire = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
        $colCodeStagiaire.Width = 120
        $colCodeStagiaire.Name = "CodeStagiaire"
        $colCodeStagiaire.ReadOnly = $true
        $colCodeStagiaire.Visible = $false
        $script:dataGridView.Columns.Add($colCodeStagiaire)
        $colDateNaissance = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
        $colDateNaissance.Width = 120
        $colDateNaissance.Name = "DateNaissance"
        $colDateNaissance.ReadOnly = $true
        $colDateNaissance.Visible = $false
        $script:dataGridView.Columns.Add($colDateNaissance)
        $colDebutFormation = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
        $colDebutFormation.Width = 120
        $colDebutFormation.Name = "DebutFormation"
        $colDebutFormation.ReadOnly = $true
        $colDebutFormation.Visible = $false
        $script:dataGridView.Columns.Add($colDebutFormation)
        $colFinFormation = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
        $colFinFormation.Width = 120
        $colFinFormation.Name = "FinFormation"
        $colFinFormation.ReadOnly = $true
        $colFinFormation.Visible = $false
        $script:dataGridView.Columns.Add($colFinFormation)
        $colCodePromotion = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
        $colCodePromotion.Width = 120
        $colCodePromotion.Name = "formation"
        $colCodePromotion.ReadOnly = $true
        $colCodePromotion.Visible = $true
        $script:dataGridView.Columns.Add($colCodePromotion)
        $ColEmail = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
        $ColEmail.Width = 120
        $ColEmail.Name = "Email"
        $ColEmail.ReadOnly = $true
        $ColEmail.Visible = $false
        $script:dataGridView.Columns.Add($ColEmail)
        $colSamAccountName = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
        $colSamAccountName.Width = 120
        $colSamAccountName.Name = "SamAccountName"
        $colSamAccountName.ReadOnly = $true
        $colSamAccountName.Visible = $false
        $script:dataGridView.Columns.Add($colSamAccountName)
    
        # ajout des colonnes � partir de la liste des plateformes
        foreach($plateforme in $plateformes) {
            $col = New-Object System.Windows.Forms.DataGridViewCheckBoxColumn
            $col.Width = 100
            $col.Name = $plateforme.nom
            $script:dataGridView.Columns.Add($col)
        }

        # on ajoute une premi�re ligne pour permettre de cocher les colonnes
        $script:dataGridView.Rows.Add($false,"","")

        #on requ�te pour relever les plateformes par d�faut
        $reqsel = "select p.*, f.nom nomformation, pf.formation idformation, pf.defaut"
        $reqsel += " from plateforme p"
        $reqsel += " join ass_plateforme_formation pf on pf.plateforme = p.id"
        $reqsel += " join formation f on f.id = pf.formation"
        $plateformesDefaut = MakeRequest $reqSel
        #conversion du CSV en unicode pour traitement et import
        Get-Content $script:textBoxFichier.Text -encoding string | Out-File -FilePath ..\temp\import.csv -Encoding Unicode
        # retrait des doublons
        Import-Csv ..\temp\import.csv | Sort-Object CodeStagiaire -Unique | Sort-Object Nom | Sort-Object CodePromotion | Export-Csv ..\temp\import_traite.csv -NoTypeInformation -encoding "unicode"
        # lecture du fichier csv
        $fichier = Import-Csv ..\temp\import_traite.csv
        rm ..\temp\import.csv
        $reqsel = "select nom from formation"
        $result = makeRequest $reqsel
        $script:formations = $result.nom
        # pour chaque ligne dans le CSV
        foreach($row in $fichier) {
            $script:formationValide = "non valide"
            # pour chaque formation
            foreach ($script:formation in $script:formations)
            {
                # on v�rifie la longueur du champ CodePromotion dans le CSV
                if ($row.CodeFormation.length -eq 0)
                {
                    $script:formationValide = "aucune formation"
                }
                # on v�rifie que la formation du CSV existe dans l'application
                elseif ($row.CodeFormation -like "*" + $script:formation + "*")
                {
                    # formation reconnue
                    $script:formationValide = "$script:formation"
                }
                # si la formation du CSV n'est pas reconnue
                elseif ($script:formationValide -eq "non valide")
                {
                    $script:formationValide = "formation inconnue"
                }
            }

            # on cr�� les variables pour pr�parer l'import du CSV
            $script:Nom = $row.nom
            $script:NomSSCaratSpec = Remove-StringDiacritic $Nom
            $script:Prenom = $row.prenom
            $script:PrenomSSCaratSpec = Remove-StringDiacritic $Prenom
            $script:CodeStagiaire = $row.CodeStagiaire
            $script:DateNaissance = $row.DateNaissance
            $script:DebutFormation = $row.debutde
            $script:FinFormation = $row.dateFin
            $script:formation = $formationValide
            $script:Email = $row.EmailCampus
            $script:annee = get-date -Format yyyy
            if ($script:Email -eq '')
            {
                $reqsel = "select domaine from plateforme where nom = 'Active Directory';"
                $script:domaine = makeRequest $reqsel
                $script:email = $($script:PrenomSSCaratSpec.Substring(0,1).ToLower() + "." + $script:NomSSCaratSpec.ToLower() + $script:annee + "@" + $script:domaine.domaine)
            }
            
            $script:SamAccountName = $script:PrenomSSCaratSpec.ToLower().Substring(0,1) + $script:NomSSCaratSpec.ToLower()
            If ($script:SamAccountName.length -ge 14) 
            {
                $script:SamAccountName=$script:SamAccountName.Substring(0,14) 
            }
            $script:SamAccountName = $script:SamAccountName + $script:annee
            $script:UserPrincipalName = $script:PrenomSSCaratSpec + "." + $script:NomSSCaratSpec + $script:annee + "@" + $script:NomDomainStag
            $script:UserPrincipalName = $script:email
            $script:result = makeRequest ("Select * FROM plateforme WHERE nom = 'active directory';")
            $script:domaine = $script:result.domaine
            verification_active_directory
            if ($script:Email -ne $script:UserPrincipalName){
                $script:Email = $script:UserPrincipalName
            }
            #on ajoute les valeurs de chaque stagiaire dans la datagridview
            $information = ""
            if($script:creationAD -eq $false){
                $information = "compte AD existant"
            }
            $script:dataGridView.Rows.Add($false, $script:nom, $script:prenom, $information, $script:CodeStagiaire, $script:DateNaissance, $script:DebutFormation, $script:FinFormation, $script:formationValide, $script:Email, $script:SAMAccountName)
            # pour chaque plateforme
            foreach($plateformeDefault in $plateformesDefaut) {
                # on parcourt les colonnes de la datagridview qui contiennent les plateformes
                for($i=10;$i -lt $script:dataGridView.ColumnCount;$i++) {
                    # si la formation n'est pas connue, on emp�che de cr�er les comptes d'une plateforme.
                    if($formationValide -eq "aucune formation" -or $formationValide -eq "formation inconnue" )
                    {
                        $script:dataGridView.Rows[$script:dataGridView.Rows.Count - 1].Cells[$i].Value = $false
                        $script:dataGridView.Rows[$script:dataGridView.Rows.Count - 1].Cells[$i].ReadOnly = $true
                    }
                    elseif($script:creationTotale -eq $false){
                        $script:dataGridView.Rows[$script:dataGridView.Rows.Count - 1].Cells[$i].Value = $false
                        $script:dataGridView.Rows[$script:dataGridView.Rows.Count - 1].Cells[$i].ReadOnly = $true
                    }
                    else
                    {
                        # on v�rifie que le nom de la colonne correspond a la plateforme
                        if($script:dataGridView.Columns[$i].Name -eq $plateformeDefault.nom -and $plateformeDefault.nomformation -eq $formationValide)
                        {
                        # si le nom de formation est une formation valide et que la plateforme est une plateforme par d�faut
                            if ($plateformeDefault.defaut -eq $true) 
                            {
                            # on s'occupe des formations valides en cochant les plateformes par d�faut
                                $script:dataGridView.Rows[$script:dataGridView.Rows.Count - 1].Cells[$i].Value = $true
                                $script:dataGridView.Rows[$script:dataGridView.Rows.Count - 1].Cells[$i].ReadOnly = $false
                            }
                            # si la plateforme est not�e comme obligatoire, on force les plateformes obligatoires avec impossibilit� de d�cocher.
                            if ($plateformeDefault.obligatoire -eq $true)
                            {
                               if($plateformeDefault.nom -eq "active directory" -and $script:creationAD -eq $false){
                                    $script:dataGridView.Rows[$script:dataGridView.Rows.Count - 1].Cells[$i].Value = $false
                                    $script:dataGridView.Rows[$script:dataGridView.Rows.Count - 1].Cells[$i].ReadOnly = $true
                                }else{
                                    $script:dataGridView.Rows[$script:dataGridView.Rows.Count - 1].Cells[$i].Value = $true
                                    $script:dataGridView.Rows[$script:dataGridView.Rows.Count - 1].Cells[$i].ReadOnly = $true
                                }
                            }
                        }
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
                # on veut modifier l'�tat de toute une colonne
                for($i = 1;$i -lt $script:dataGridView.RowCount;$i++) {
                    if($script:dataGridView.Rows[$i].Cells[$EventArgs.ColumnIndex].ReadOnly -eq $false)
                    {
                        $script:dataGridView.Rows[$i].Cells[$EventArgs.ColumnIndex].Value = $etat
                    }
                }
            }
            if($EventArgs.ColumnIndex -eq 0 -and $EventArgs.RowIndex -gt 0) {
                # on veut modifier l'�tat de toute une ligne
                for($j = 10;$j -lt $script:dataGridView.ColumnCount;$j++) {
                    $script:dataGridView.Rows[$EventArgs.RowIndex].Cells[$j].Value = $etat
                }
            }
        })
    }
}

Function ImporterCSV {
    # pour chaque plateforme existante
    $script:creationTotale = $true
    $script:creationAD = $true
    foreach ($plateforme in $dataGridView.Columns)
    {
        # si il s'agit d'une colonne avec le nom d'une plateforme
        if ($plateforme.name -ne '' -and $plateforme.name -ne 'Nom' -and $plateforme.name -ne 'Pr�nom' -and $plateforme.name -ne 'information' -and $plateforme.name -ne 'CodeStagiaire' -and $plateforme.name -ne 'DateNaissance' -and $plateforme.name -ne 'DebutFormation' -and $plateforme.name -ne 'FinFormation' -and $plateforme.name -ne 'CodePromotion' -and $plateforme.name -ne 'Email' -and $plateforme.name -ne 'SamAccountName' -and $plateforme.name -ne 'Formation')
        {
            $scriptCreationPlateforme = "creation_" + $plateforme.name -replace " ","_"
            # pour chaque stagiaire dans dans la datagridview
            for($i = 1;$i -lt $script:dataGridView.RowCount;$i++) {
            # mise en forme initiale des variables
                $vide = $NULL
                $script:Nom = $script:dataGridView.Rows[$i].Cells[1].Value
                $script:NomSSCaratSpec = Remove-StringDiacritic $Nom
                $script:Prenom = $script:dataGridView.Rows[$i].Cells[2].Value
                $script:PrenomSSCaratSpec = Remove-StringDiacritic $Prenom
                $script:CodeStagiaire = $script:dataGridView.Rows[$i].Cells[4].Value
                $script:DateNaissance = $script:dataGridView.Rows[$i].Cells[5].Value
                $script:DebutFormation = $script:dataGridView.Rows[$i].Cells[6].Value
                $script:FinFormation = $script:dataGridView.Rows[$i].Cells[7].Value
                $script:formation = $script:dataGridView.Rows[$i].Cells[8].Value
                $script:Email = $script:dataGridView.Rows[$i].Cells[9].Value
                $script:SamAccountName = $script:dataGridView.Rows[$i].Cells[10].Value
                $script:UserPrincipalName = $script:email
                $script:creation = $script:dataGridView.Rows[$i].Cells[$plateforme.index].Value
                $script:site = $comboBoxSite.Text
                $result = makeRequest ("Select * FROM plateforme WHERE nom = 'active directory';")
                $script:domaine = $result.domaine
                # G�n�ration SAMAcount NAme
                
                # on ajoute les infos du stagiaire dans la base de donn�es
                $reqinsert = "INSERT INTO projet_eni.stagiaire (nomStagiaire, prenomStagiaire, mailStagiaire, identifiantCrm)"
                $reqinsert += " VALUES('" + $script:NomSSCaratSpec + "', '" + $script:PrenomSSCaratSpec + "', '" + $script:Email + "', '" + $script:CodeStagiaire + "');"
                makeRequest $reqinsert
                
                if ($script:creation -eq $true)
                {
                    $script:plateformeBase = $plateforme.name
                    $password = GenerationMdpTemp
                    &"$scriptCreationPlateforme"
                }
                
            }
            $vide = $true
            &"$scriptCreationPlateforme"

        }
    }
    $typeBouton = [System.Windows.Forms.MessageBoxButtons]::OK
    $typeIcone = [System.Windows.Forms.MessageBoxIcon]::Information
    [System.Windows.Forms.MessageBox]::Show("L'import est termin�", "Information", $typeBouton, $typeIcone)
}

Function Parcourir {
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Filter = "CSV (*.csv)| *.csv"
    $openFileDialog.ShowDialog()

    # on r�cup�re le nom du fichier pour l'afficher dans le champ
    $script:textBoxFichier.Text = $openFileDialog.filename

    # on affiche la s�lection du site
    if($script:textBoxFichier.Text.Length -gt 0) {
        $script:labelSite.Visible = $true
        $script:comboBoxSite.Visible = $true
        FillComboBox $script:comboBoxSite $script:sites "nom"
        $script:comboBoxSite.SelectedIndex = -1
        $script:comboBoxSite.add_SelectedIndexChanged({FillDataGrid})
    }
}

Function MakeForm {
    $listForm = New-Object System.Windows.Forms.Form
    $listForm.Text = "Cr�ation de comptes stagiaires"
    $listForm.Size = New-Object System.Drawing.Size(1000,700)
    $listForm.StartPosition = "CenterScreen"
    
    $labelFichier = New-Object System.Windows.Forms.Label
    $labelFichier.Location = New-Object System.Drawing.Point(20,20)
    $labelFichier.Size = New-Object System.Drawing.Size(400,22)
    $labelFichier.Text = "1. S�lectionner le CSV provenant du CRM de l'ENI"

    $ButtonParcourir = New-Object System.Windows.Forms.Button
    $ButtonParcourir.Location = New-Object System.Drawing.Point(20,43)
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
    # la touche echap est mapp�e sur retour
    $listForm.CancelButton = $ButtonRetour

    $script:buttonImporter.Location = New-Object System.Drawing.Point(815,580)
    $script:buttonImporter.Size = New-Object System.Drawing.Size(150,60)
    $script:buttonImporter.Text = "Importer"
    $script:buttonImporter.Add_Click({ImporterCSV; $listForm.Close()})
    $script:buttonImporter.Visible = $false
    # la touche entr�e est mapp�e sur importer
    $listForm.AcceptButton = $script:buttonImporter

    $listForm.Controls.Add($labelFichier)
    $listForm.Controls.Add($script:textBoxFichier)
    $listForm.Controls.Add($ButtonParcourir)
    $listForm.Controls.Add($labelSite)
    $listForm.Controls.Add($script:comboBoxSite)
    $listForm.Controls.Add($script:dataGridView)
    $listForm.Controls.Add($ButtonRetour)
    $listForm.Controls.Add($script:buttonImporter)

    # Afficher la fenetre
    $listForm.ShowDialog()
}