Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

. "../ps/fg_1-1_DBUtils.ps1"

if ($ADusername -eq $NULL)
{
    exit
}

$dataGridHisto = New-Object System.Windows.Forms.DataGridView
$pickerDateHeure = New-Object System.Windows.Forms.DateTimePicker
$textBoxUser = New-Object System.Windows.Forms.TextBox
$textBoxAction = New-Object System.Windows.Forms.TextBox
$textBoxStagiaire = New-Object System.Windows.Forms.TextBox

Function FillDataGrid {
    # construction du filtre
    $filtre = " where h.timestamp > '" + $script:pickerDateHeure.Value.ToString("yyyy-MM-dd HH:mm:ss") + "'"
    if($script:textBoxUser.Text.Length -gt 0) {
        $filtre += " and h.utilisateur like '%" + $script:textBoxUser.Text + "%'"
    }
    if($script:textBoxAction.Text.Length -gt 0) {
        $filtre += " and h.action like '%" + $script:textBoxAction.Text + "%'"
    }
    if($script:textBoxStagiaire.Text.Length -gt 0) {
        $filtre += " and h.stagiaire like '%" + $script:textBoxStagiaire.Text + "%'"
    }

    # récupération de l'historique
    $reqSel = "select h.timestamp, h.utilisateur, h.action, h.statut, h.stagiaire, h.typeCompte, h.site, h.formation from historique h"
    $reqSel += $filtre
    $reqSel += " order by h.timestamp desc limit 100"
    $historiques = MakeRequest $reqSel

    # alimentation des lignes
    $script:dataGridHisto.Rows.Clear()
    foreach($histo in $historiques) {
        $recap = $histo.action + " du compte " + $histo.typeCompte
        $recap += " sur le site de " + $histo.site + " pour la formation " + $histo.formation
        $tmp =$script:dataGridHisto.Rows.Add($histo.timestamp, $histo.utilisateur, $histo.action, $histo.statut, $histo.stagiaire, $recap)
    }
}

Function MakeForm {
    $listForm = New-Object System.Windows.Forms.Form
    $listForm.Text = "Historique des actions"
    $listForm.Size = New-Object System.Drawing.Size(1000,700)
    $listForm.StartPosition = "CenterScreen"
    
    # ajout des filtres
    $labelDateHeure = New-Object System.Windows.Forms.Label
    $labelDateHeure.Location = New-Object System.Drawing.Point(20,20)
    $labelDateHeure.Size = New-Object System.Drawing.Size(60,20)
    $labelDateHeure.Text = "A partir de"

    $script:pickerDateHeure.Location = New-Object System.Drawing.Point(80,18)
    $script:pickerDateHeure.Size = New-Object System.Drawing.Size(130,20)
    $script:pickerDateHeure.Format = [System.Windows.Forms.DateTimePickerFormat]::Custom
    $script:pickerDateHeure.CustomFormat = "dd/MM/yy HH:mm:ss"
    $script:pickerDateHeure.Value = [System.DateTime]::Today.AddMonths(-1)

    $labelUser = New-Object System.Windows.Forms.Label
    $labelUser.Location = New-Object System.Drawing.Point(215,20)
    $labelUser.Size = New-Object System.Drawing.Size(55,20)
    $labelUser.Text = "Utilisateur"

    $script:textBoxUser.Location = New-Object System.Drawing.Point(275,18)
    $script:textBoxUser.Size = New-Object System.Drawing.Size(70,20)

    $labelAction = New-Object System.Windows.Forms.Label
    $labelAction.Location = New-Object System.Drawing.Point(350,20)
    $labelAction.Size = New-Object System.Drawing.Size(40,20)
    $labelAction.Text = "Action"

    $script:textBoxAction.Location = New-Object System.Drawing.Point(395,18)
    $script:textBoxAction.Size = New-Object System.Drawing.Size(70,20)

    $labelStagiaire = New-Object System.Windows.Forms.Label
    $labelStagiaire.Location = New-Object System.Drawing.Point(470,20)
    $labelStagiaire.Size = New-Object System.Drawing.Size(50,20)
    $labelStagiaire.Text = "Stagiaire"

    $script:textBoxStagiaire.Location = New-Object System.Drawing.Point(525,18)
    $script:textBoxStagiaire.Size = New-Object System.Drawing.Size(70,20)

    # ajout du bouton pour filtrer
    $boutonFiltre = New-Object System.Windows.Forms.Button
    $boutonFiltre.Location = New-Object System.Drawing.Point(600,18)
    $boutonFiltre.Size = New-Object System.Drawing.Size(70,20)
    $boutonFiltre.Text = "Filtrer"
    $boutonFiltre.Add_Click({FillDataGrid})

    # définition du tableau
    $script:dataGridHisto.Location = New-Object System.Drawing.Point(20,50)
    $script:dataGridHisto.Size = New-Object System.Drawing.Size(940,510)
    $script:dataGridHisto.RowHeadersVisible = $false
    $script:dataGridHisto.AllowUserToAddRows = $false
    $script:dataGridHisto.ReadOnly = $true
    $script:dataGridHisto.BackgroundColor = [System.Drawing.Color]::GhostWhite

    # ajout des colonnes date-heure, utilisateur, action, statut, stagiaire et récap
    $colDateHeure = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
    $colDateHeure.Width = 115
    $colDateHeure.Name = "Date et heure"
    $tmp = $script:dataGridHisto.Columns.Add($colDateHeure)

    $colUser = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
    $colUser.Width = 100
    $colUser.Name = "Utilisateur"
    $tmp = $script:dataGridHisto.Columns.Add($colUser)

    $colAction = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
    $colAction.Width = 50
    $colAction.Name = "Action"
    $tmp = $script:dataGridHisto.Columns.Add($colAction)

    $colStatut = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
    $colStatut.Width = 40
    $colStatut.Name = "Statut"
    $tmp = $script:dataGridHisto.Columns.Add($colStatut)

    $colStagiaire = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
    $colStagiaire.Width = 100
    $colStagiaire.Name = "Stagiaire"
    $tmp = $script:dataGridHisto.Columns.Add($colStagiaire)

    $colRecap = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
    $colRecap.Width = 530
    $colRecap.Name = "Récapitulatif"
    $tmp = $script:dataGridHisto.Columns.Add($colRecap)

    FillDataGrid

    $ButtonRetour = New-Object System.Windows.Forms.Button
    $ButtonRetour.Location = New-Object System.Drawing.Point(20,580)
    $ButtonRetour.Size = New-Object System.Drawing.Size(150,60)
    $ButtonRetour.Text = "Retour"
    $ButtonRetour.Add_Click({$listForm.Close()})
    # la touche echap est mappée sur retour
    $listForm.CancelButton = $ButtonRetour

    $listForm.Controls.Add($labelDateHeure)
    $listForm.Controls.Add($script:pickerDateHeure)
    $listForm.Controls.Add($labelUser)
    $listForm.Controls.Add($script:textBoxUser)
    $listForm.Controls.Add($labelAction)
    $listForm.Controls.Add($script:textBoxAction)
    $listForm.Controls.Add($labelStagiaire)
    $listForm.Controls.Add($script:textBoxStagiaire)
    $listForm.Controls.Add($labelNomStagiaire)
    $listForm.Controls.Add($script:textBoxNomStagiaire)
    $listForm.Controls.Add($boutonFiltre)
    $listform.Controls.Add($script:dataGridHisto) 
    $listForm.Controls.Add($ButtonRetour)

    # Afficher la fenetre
    $listForm.ShowDialog()
}

OpenDB

MakeForm

CloseDB