Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

. "../ps/fg_1-1_DBUtils.ps1"

$dataGridHisto = New-Object System.Windows.Forms.DataGridView
$textBoxUser = New-Object System.Windows.Forms.TextBox
$textBoxAction = New-Object System.Windows.Forms.TextBox
$textBoxPrenomStagiaire = New-Object System.Windows.Forms.TextBox
$textBoxNomStagiaire = New-Object System.Windows.Forms.TextBox

Function FillDataGrid {
    # construction du filtre
    $filtre = " where"
    if($script:textBoxUser.Text.Length -gt 0) {
        $filtre += " u.login like '%" + $script:textBoxUser.Text + "%'"
    }
    if($script:textBoxAction.Text.Length -gt 0) {
        if($filtre -ne " where") {
            $filtre += " and"
        }
        $filtre += " h.action like '%" + $script:textBoxAction.Text + "%'"
    }
    if($script:textBoxPrenomStagiaire.Text.Length -gt 0) {
        if($filtre -ne " where") {
            $filtre += " and"
        }
        $filtre += " st.prenomStagiaire like '%" + $script:textBoxPrenomStagiaire.Text + "%'"
    }
    if($script:textBoxNomStagiaire.Text.Length -gt 0) {
        if($filtre -ne " where") {
            $filtre += " and"
        }
        $filtre += " st.nomStagiaire like '%" + $script:textBoxNomStagiaire.Text + "%'"
    }

    # récupération de l'historique
    $reqSel = "select h.timestamp, u.login, h.action, h.statut, st.nomStagiaire, st.prenomStagiaire,"
    $reqSel += " p.nom as nomPlateforme, s.nom as nomSite, f.nom as nomFormation"
    $reqSel += " from historique h join utilisateur u on h.utilisateur = u.ID"
    $reqSel += " join stagiaire st on h.stagiaire = st.ID"
    $reqSel += " join plateforme p on h.typeCompte = p.ID"
    $reqSel += " join site s on h.site = s.ID"
    $reqSel += " join formation f on h.formation = f.ID"
    if($filtre -ne " where") {
        $reqSel += $filtre
    }
    $reqSel += " limit 100"
    $historiques = MakeRequest $reqSel

    # alimentation des lignes
    $script:dataGridHisto.Rows.Clear()
    foreach($histo in $historiques) {
        $stagiaire = $histo.prenomStagiaire + " " + $histo.nomStagiaire
        $recap = $histo.action + " du compte " + $histo.nomPlateforme
        $recap += " sur le site de " + $histo.nomSite + " pour la formation " + $histo.nomFormation
        $tmp =$script:dataGridHisto.Rows.Add($histo.timestamp, $histo.login, $histo.action, $histo.statut, $stagiaire, $recap)
    }
}

Function MakeForm {
    $listForm = New-Object System.Windows.Forms.Form
    $listForm.Text = "Historique des actions"
    $listForm.Size = New-Object System.Drawing.Size(1000,700)
    $listForm.StartPosition = "CenterScreen"
    
    # ajout des filtres
    $labelUser = New-Object System.Windows.Forms.Label
    $labelUser.Location = New-Object System.Drawing.Point(20,20)
    $labelUser.Size = New-Object System.Drawing.Size(55,20)
    $labelUser.Text = "Utilisateur"

    $script:textBoxUser.Location = New-Object System.Drawing.Point(80,18)
    $script:textBoxUser.Size = New-Object System.Drawing.Size(70,20)

    $labelAction = New-Object System.Windows.Forms.Label
    $labelAction.Location = New-Object System.Drawing.Point(155,20)
    $labelAction.Size = New-Object System.Drawing.Size(40,20)
    $labelAction.Text = "Action"

    $script:textBoxAction.Location = New-Object System.Drawing.Point(200,18)
    $script:textBoxAction.Size = New-Object System.Drawing.Size(70,20)

    $labelPrenomStagiaire = New-Object System.Windows.Forms.Label
    $labelPrenomStagiaire.Location = New-Object System.Drawing.Point(275,20)
    $labelPrenomStagiaire.Size = New-Object System.Drawing.Size(90,20)
    $labelPrenomStagiaire.Text = "Prénom stagiaire"

    $script:textBoxPrenomStagiaire.Location = New-Object System.Drawing.Point(370,18)
    $script:textBoxPrenomStagiaire.Size = New-Object System.Drawing.Size(70,20)

    $labelNomStagiaire = New-Object System.Windows.Forms.Label
    $labelNomStagiaire.Location = New-Object System.Drawing.Point(445,20)
    $labelNomStagiaire.Size = New-Object System.Drawing.Size(75,20)
    $labelNomStagiaire.Text = "Nom stagiaire"

    $script:textBoxNomStagiaire.Location = New-Object System.Drawing.Point(525,18)
    $script:textBoxNomStagiaire.Size = New-Object System.Drawing.Size(70,20)

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
    $colRecap.Width = 400
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

    $listForm.Controls.Add($labelUser)
    $listForm.Controls.Add($script:textBoxUser)
    $listForm.Controls.Add($labelAction)
    $listForm.Controls.Add($script:textBoxAction)
    $listForm.Controls.Add($labelPrenomStagiaire)
    $listForm.Controls.Add($script:textBoxPrenomStagiaire)
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