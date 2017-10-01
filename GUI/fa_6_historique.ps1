Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

. "../ps/fg_1-1_DBUtils.ps1"

Function MakeForm {
    $listForm = New-Object System.Windows.Forms.Form
    $listForm.Text = "Historique des actions"
    $listForm.Size = New-Object System.Drawing.Size(1000,700)
    $listForm.StartPosition = "CenterScreen"
    
    $dataGridHisto = New-Object System.Windows.Forms.DataGridView
    $dataGridHisto.Location = New-Object System.Drawing.Point(20,20)
    $dataGridHisto.Size = New-Object System.Drawing.Size(940,540)
    $dataGridHisto.RowHeadersVisible = $false
    $dataGridHisto.AllowUserToAddRows = $false
    $dataGridHisto.ReadOnly = $true

    # ajout des colonnes date-heure, utilisateur, action, statut et récap
    $colDateHeure = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
    $colDateHeure.Width = 115
    $colDateHeure.Name = "Date et heure"
    $dataGridHisto.Columns.Add($colDateHeure)

    $colUser = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
    $colUser.Width = 100
    $colUser.Name = "Utilisateur"
    $dataGridHisto.Columns.Add($colUser)

    $colAction = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
    $colAction.Width = 50
    $colAction.Name = "Action"
    $dataGridHisto.Columns.Add($colAction)

    $colStatut = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
    $colStatut.Width = 40
    $colStatut.Name = "Statut"
    $dataGridHisto.Columns.Add($colStatut)

    $colStagiaire = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
    $colStagiaire.Width = 100
    $colStagiaire.Name = "Stagiaire"
    $dataGridHisto.Columns.Add($colStagiaire)

    $colRecap = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
    $colRecap.Width = 400
    $colRecap.Name = "Récapitulatif"
    $dataGridHisto.Columns.Add($colRecap)

    # récupération de l'historique
    #TODO : réfléchir à une limite
    OpenDB
    $reqSel = "select h.timestamp, u.login, h.action, h.statut, st.nomStagiaire, st.prenomStagiaire,"
    $reqSel += " p.nom as nomPlateforme, s.nom as nomSite, f.nom as nomFormation"
    $reqSel += " from historique h join utilisateur u on h.utilisateur = u.ID"
    $reqSel += " join stagiaire st on h.stagiaire = st.ID"
    $reqSel += " join plateforme p on h.typeCompte = p.ID"
    $reqSel += " join site s on h.site = s.ID"
    $reqSel += " join formation f on h.formation = f.ID"
    $historiques = MakeRequest $reqSel
    CloseDB

    # alimentation des lignes
    foreach($histo in $historiques) {
        $stagiaire = $histo.prenomStagiaire + " " + $histo.nomStagiaire
        $recap = $histo.action + " du compte " + $histo.nomPlateforme
        $recap += " sur le site de " + $histo.nomSite + " pour la formation " + $histo.nomFormation
        $dataGridHisto.Rows.Add($histo.timestamp, $histo.login, $histo.action, $histo.statut, $stagiaire, $recap)
    }

    $ButtonRetour = New-Object System.Windows.Forms.Button
    $ButtonRetour.Location = New-Object System.Drawing.Point(20,580)
    $ButtonRetour.Size = New-Object System.Drawing.Size(150,60)
    $ButtonRetour.Text = "Retour"
    $ButtonRetour.Add_Click({$listForm.Close()})
    # la touche echap est mappée sur retour
    $listForm.CancelButton = $ButtonRetour

    $listForm.Controls.Add($ButtonRetour)
    $listform.Controls.Add($dataGridHisto) 

    # Afficher la fenetre
    $listForm.ShowDialog()
}

MakeForm