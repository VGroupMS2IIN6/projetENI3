Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

. "../ps/droits.ps1"
. "../ps/fg_1-1_DBUtils.ps1"

OpenDB

if ($ADusername -eq $NULL)
{
    exit
}

# Creation des composants dont on aura besoin plus tard
$listForm = New-Object System.Windows.Forms.Form
$ListBoxAffichage = New-Object System.Windows.Forms.ListBox 
$dataGridHisto = New-Object System.Windows.Forms.DataGridView

Function MakeMenuCreationCsv {
    $labelTitreCreationCsv = New-Object System.Windows.Forms.Label
    $labelTitreCreationCsv.Location = New-Object System.Drawing.Point(10,10)
    $labelTitreCreationCsv.Size = New-Object System.Drawing.Size(200,20)
    $labelTitreCreationCsv.Text = "Création de comptes"
    $labelTitreCreationCsv.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes
    
    $script:ListBoxAffichage.Controls.clear();
    $script:ListBoxAffichage.Controls.Add($labelTitreCreationCsv)
}

Function MakeMenuUnit {
    $labelTitreUnit = New-Object System.Windows.Forms.Label
    $labelTitreUnit.Location = New-Object System.Drawing.Point(10,10)
    $labelTitreUnit.Size = New-Object System.Drawing.Size(200,20)
    $labelTitreUnit.Text = "Création de compte unitaire"
    $labelTitreUnit.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes
    
    $script:ListBoxAffichage.Controls.clear();
    $script:ListBoxAffichage.Controls.Add($labelTitreUnit)
}

Function MakeMenuResetPWD {
    $labelTitreResetPWD = New-Object System.Windows.Forms.Label
    $labelTitreResetPWD.Location = New-Object System.Drawing.Point(10,10)
    $labelTitreResetPWD.Size = New-Object System.Drawing.Size(200,20)
    $labelTitreResetPWD.Text = "Réinitialisation de mots de passe"
    $labelTitreResetPWD.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes
    
    $script:ListBoxAffichage.Controls.clear();
    $script:ListBoxAffichage.Controls.Add($labelTitreResetPWD)
}

Function MakeMenuHistorique {
    $labelTitreHistorique = New-Object System.Windows.Forms.Label
    $labelTitreHistorique.Location = New-Object System.Drawing.Point(10,10)
    $labelTitreHistorique.Size = New-Object System.Drawing.Size(200,20)
    $labelTitreHistorique.Text = "Historique"
    $labelTitreHistorique.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes
    
    $script:ListBoxAffichage.Controls.clear();
    $script:ListBoxAffichage.Controls.Add($labelTitreHistorique)
}

Function MakeMenuFormSite {

    
    $script:ListBoxAffichage.Controls.clear();
    $script:ListBoxAffichage.Controls.Add($labelTitreFormSite)
}

Function MakeMenuParametres {
    $labelTitreParametres = New-Object System.Windows.Forms.Label
    $labelTitreParametres.Location = New-Object System.Drawing.Point(10,10)
    $labelTitreParametres.Size = New-Object System.Drawing.Size(200,20)
    $labelTitreParametres.Text = "Paramètres"
    $labelTitreParametres.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes
    
    $script:ListBoxAffichage.Controls.clear();
    $script:ListBoxAffichage.Controls.Add($labelTitreParametres)
}

Function MakeMenuAPropos {
    $labelTitreAPropos = New-Object System.Windows.Forms.Label
    $labelTitreAPropos.Location = New-Object System.Drawing.Point(10,10)
    $labelTitreAPropos.Size = New-Object System.Drawing.Size(200,20)
    $labelTitreAPropos.Text = "A Propos"
    $labelTitreAPropos.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes
    
    $script:ListBoxAffichage.Controls.clear();
    $script:ListBoxAffichage.Controls.Add($labelTitreAPropos)
}

Function MakeDataGrid {
    $script:dataGridHisto.Location = New-Object System.Drawing.Point(0,0)
    $script:dataGridHisto.Size = New-Object System.Drawing.Size(916,429)
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
    $colRecap.Width = 508
    $colRecap.Name = "Récapitulatif"
    $tmp = $script:dataGridHisto.Columns.Add($colRecap)

    # récupération de l'historique
    $reqSel = "select h.timestamp, u.login, h.action, h.statut, st.nomStagiaire, st.prenomStagiaire,"
    $reqSel += " p.nom as nomPlateforme, s.nom as nomSite, f.nom as nomFormation"
    $reqSel += " from historique h join utilisateur u on h.utilisateur = u.ID"
    $reqSel += " join stagiaire st on h.stagiaire = st.ID"
    $reqSel += " join plateforme p on h.typeCompte = p.ID"
    $reqSel += " join site s on h.site = s.ID"
    $reqSel += " join formation f on h.formation = f.ID"
    $reqSel += " order by h.timestamp desc limit 10"
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
    $script:listForm.Text = "Accueil"
    $script:listForm.Size = New-Object System.Drawing.Size(1000,700)
    $script:listForm.StartPosition = "CenterScreen"
    
    $position = 30
    $largeur = 140
    $ecart = 5

    $ButtonCreationCSV = New-Object System.Windows.Forms.Button
    $ButtonCreationCSV.Location = New-Object System.Drawing.Point($position,30)
    $ButtonCreationCSV.Size = New-Object System.Drawing.Size($largeur,60)
    $position += $largeur + $ecart
    $ButtonCreationCSV.Text = "Creation Comptes CSV"
    $ButtonCreationCSV.add_Click({.\fa_3_CreationComptesCSV.ps1})
    $toolTipButtonCreationCSV = New-Object System.Windows.Forms.ToolTip
    $toolTipButtonCreationCSV.SetToolTip($ButtonCreationCSV, "création des comptes stagiaires à partir d'un CSV")

    $ButtonUnit = New-Object System.Windows.Forms.Button
    $ButtonUnit.Location = New-Object System.Drawing.Point($position,30)
    $ButtonUnit.Size = New-Object System.Drawing.Size($largeur,60)
    $position += $largeur + $ecart
    $ButtonUnit.Text = "Creation Compte Unitaire"
    $ButtonUnit.add_Click({.\CreationUnitaire.ps1})

    $toolTipButtonUnit = New-Object System.Windows.Forms.ToolTip
    $toolTipButtonUnit.SetToolTip($ButtonUnit, "création d'un compte stagiaire")

    $ButtonResetPWD = New-Object System.Windows.Forms.Button
    $ButtonResetPWD.Location = New-Object System.Drawing.Point($position,30)
    $ButtonResetPWD.Size = New-Object System.Drawing.Size($largeur,60)
    $position += $largeur + $ecart
    $ButtonResetPWD.Text = "Réinisialisation MDP"
    $ButtonResetPWD.add_Click({MakeMenuResetPWD})
    $ButtonResetPWD_Click = {
	    $FenetreAccueil.Visible = $false
	    $FenetreResetPWD.ShowDialog()
    }
    $toolTipButtonResetPWD = New-Object System.Windows.Forms.ToolTip
    $toolTipButtonResetPWD.SetToolTip($ButtonResetPWD, "réinitialisation de mots de passe stagiaire")

    $ButtonHistorique = New-Object System.Windows.Forms.Button
    $ButtonHistorique.Location = New-Object System.Drawing.Point($position,30)
    $ButtonHistorique.Size = New-Object System.Drawing.Size($largeur,60)
    $position += $largeur + $ecart
    $ButtonHistorique.Text = 'Historique'
    $ButtonHistorique.add_Click({.\fa_6_historique.ps1})
    $toolTipButtonHistorique = New-Object System.Windows.Forms.ToolTip
    $toolTipButtonHistorique.SetToolTip($ButtonHistorique, "Consulter l'historique de création de comptes")

    $nomDroit = 'gestion des sites et formations'
    $resultFormSite = checkDroitParametrage
        if ($resultFormSite -ne 0) {
        $ButtonGestionFormation = New-Object System.Windows.Forms.Button
        $ButtonGestionFormation.Location = New-Object System.Drawing.Point($position,30)
        $ButtonGestionFormation.Size = New-Object System.Drawing.Size($largeur,60)
        $position += $largeur + $ecart
        $ButtonGestionFormation.Text = "Gestion des sites et formations"
        $ButtonGestionFormation.add_Click({..\GUI\fa_4_GestionFormationSite.ps1})
        $toolTipButtonGestionFormation = New-Object System.Windows.Forms.ToolTip
        $toolTipButtonGestionFormation.SetToolTip($ButtonGestionFormation, "Gérer les formations et les sites")
    }

    $nomDroit = 'paramétrage administration'
    $resultDroitParametres = checkDroitParametrage
    if($resultDroitParametres -ne 0) {
        $ButtonParametres = New-Object System.Windows.Forms.Button
        $ButtonParametres.Location = New-Object System.Drawing.Point($position,30)
        $ButtonParametres.Size = New-Object System.Drawing.Size($largeur,60)
        $position += $largeur + $ecart
        $ButtonParametres.Text = "Paramètres"
        $ButtonParametres.add_Click({.\fa_7_Parametres.ps1})
        $toolTipButtonParametres = New-Object System.Windows.Forms.ToolTip
        $toolTipButtonParametres.SetToolTip($ButtonParametres, "Paramètres de l'application")
    }

    $ListBoxAffichage.Location = New-Object System.Drawing.Size(30,120) 
    $ListBoxAffichage.Size = New-Object System.Drawing.Size(920,440)

    $ButtonAPropos = New-Object System.Windows.Forms.Button
    $ButtonAPropos.Location = '30,580'
    $ButtonAPropos.Size = '150,60'
    $ButtonAPropos.Text = "A propos"
    $ButtonAPropos.add_Click({MakeMenuAPropos})
    $ButtonAPropos_CLick = {
	    $FenetreAccueil.Visible = $false
	    $FenetreAPropos.ShowDialog()
    }

    $ButtonRetour = New-Object System.Windows.Forms.Button
    $ButtonRetour.Location = New-Object System.Drawing.Point(800,580)
    $ButtonRetour.Size = New-Object System.Drawing.Size(150,60)
    $ButtonRetour.Text = "Retour"
    $ButtonRetour.Add_Click({$script:listForm.Close()})
    # la touche echap est mappée sur retour
    $script:listForm.CancelButton = $ButtonRetour

    # définition du tableau pour l'historique
    MakeDataGrid
    
    $script:ListBoxAffichage.Controls.Add($script:dataGridHisto)

    $script:listForm.Controls.Add($ButtonCreationCSV) 
    $script:listForm.Controls.Add($ButtonUnit)
    $script:listForm.Controls.Add($ButtonResetPWD)
    $script:listForm.Controls.Add($ButtonHistorique)
    $script:listForm.Controls.Add($ButtonGestionFormation)
    $script:listForm.Controls.Add($ButtonParametres)
    $script:listForm.Controls.Add($ButtonAPropos)
    $script:listForm.Controls.Add($ButtonRetour)
    $script:listForm.Controls.Add($script:ListBoxAffichage)

    # Afficher la fenetre
    $script:listForm.ShowDialog()
}

##############################################
### LANCEMENT DE L'APPLI (FENETRE ACCUEIL) ###
##############################################

makeForm
CloseDB