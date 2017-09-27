Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Creation des composants dont on aura besoin plus tard
$listForm = New-Object System.Windows.Forms.Form
$listForm.Text = "Accueil"
$listForm.Size = New-Object System.Drawing.Size(1000,700)
$listForm.StartPosition = "CenterScreen"

$ListBoxAffichage = New-Object System.Windows.Forms.ListBox 
$ListBoxAffichage.Location = New-Object System.Drawing.Size(30,150) 
$ListBoxAffichage.Size = New-Object System.Drawing.Size(920,400)

Function MakeForm {
    $position = 30
    $largeur = 140
    $ecart = 5

    $ButtonCreationCSV = New-Object System.Windows.Forms.Button
    $ButtonCreationCSV.Location = New-Object System.Drawing.Point($position,30)
    $ButtonCreationCSV.Size = New-Object System.Drawing.Size($largeur,60)
    $position += $largeur + $ecart
    $ButtonCreationCSV.Text = "Creation Comptes CSV"
    $ButtonCreationCSV.add_Click({.\fa_3_CreationComptesCSV.ps1})
    $ButtonCreationCSV_Click = {
	    $FenetreAccueil.Visible = $false
	    $FenetreCreationCSV.ShowDialog()
    }
    $toolTipButtonCreationCSV = New-Object System.Windows.Forms.ToolTip
    $toolTipButtonCreationCSV.SetToolTip($ButtonCreationCSV, "création des comptes stagiaires à partir d'un CSV")

    $ButtonUnit = New-Object System.Windows.Forms.Button
    $ButtonUnit.Location = New-Object System.Drawing.Point($position,30)
    $ButtonUnit.Size = New-Object System.Drawing.Size($largeur,60)
    $position += $largeur + $ecart
    $ButtonUnit.Text = "Creation Compte Unitaire"
    $ButtonUnit.add_Click({MakeMenuUnit})
    $ButtonUnit_Click = {
	    $FenetreAccueil.Visible = $false
	    $FenetreCreationUnitaire.ShowDialog()
    }
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
    $ButtonHistorique.add_Click({MakeMenuHistorique})
    $ButtonHistorique_Click = {
	    $FenetreAccueil.Visible = $false
	    $FenetreHistorique.ShowDialog()
    }
    $toolTipButtonHistorique = New-Object System.Windows.Forms.ToolTip
    $toolTipButtonHistorique.SetToolTip($ButtonHistorique, "Consulter l'historique de création de comptes")

    #TODO : gérer l'interrogation des droits
    if($true) {
        $ButtonGestionFormation = New-Object System.Windows.Forms.Button
        $ButtonGestionFormation.Location = New-Object System.Drawing.Point($position,30)
        $ButtonGestionFormation.Size = New-Object System.Drawing.Size($largeur,60)
        $position += $largeur + $ecart
        $ButtonGestionFormation.Text = "Gestion des sites et formations"
        $ButtonGestionFormation.add_Click({.\fa_4_GestionFormationSite.ps1})
    }
    $toolTipButtonGestionFormation = New-Object System.Windows.Forms.ToolTip
    $toolTipButtonGestionFormation.SetToolTip($ButtonGestionFormation, "Gérer les formations et les sites")

    $ButtonParametres = New-Object System.Windows.Forms.Button
    $ButtonParametres.Location = New-Object System.Drawing.Point($position,30)
    $ButtonParametres.Size = New-Object System.Drawing.Size($largeur,60)
    $position += $largeur + $ecart
    $ButtonParametres.Text = "Paramètres"
    $ButtonParametres.add_Click({.\fa_7_Parametres.ps1})
    $ButtonParametres_Click = {
	    $FenetreAccueil.Visible = $false
	    $FenetreParametres.ShowDialog()
    }
    $toolTipButtonParametres = New-Object System.Windows.Forms.ToolTip
    $toolTipButtonParametres.SetToolTip($ButtonParametres, "Paramètres de l'application")

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
    $ButtonRetour.Location = New-Object System.Drawing.Point(30,580)
    $ButtonRetour.Size = New-Object System.Drawing.Size(150,60)
    $ButtonRetour.Text = "Retour"
    $ButtonRetour.Add_Click({$script:listForm.Close()})
    # la touche echap est mappée sur retour
    $script:listForm.CancelButton = $ButtonRetour

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

##############################################
### LANCEMENT DE L'APPLI (FENETRE ACCUEIL) ###
##############################################

makeForm