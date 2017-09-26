Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Creation des composants dont on aura besoin plus tard
$listForm = New-Object System.Windows.Forms.Form
$listForm.Text = "Accueil"
$listForm.Size = New-Object System.Drawing.Size(1000,700)
$listForm.StartPosition = "CenterScreen"

$ListBoxAffichage = New-Object System.Windows.Forms.ListBox 
$ListBoxAffichage.Location = New-Object System.Drawing.Size(30,150) 
$ListBoxAffichage.Size = New-Object System.Drawing.Size(920,20)
$ListBoxAffichage.Height = 400


Function MakeForm {
    $ButtonCreationCSV = New-Object System.Windows.Forms.Button
    $ButtonCreationCSV.Location = '30,30'
    $ButtonCreationCSV.Size = '150,60'
    $ButtonCreationCSV.Text = "Creation Comptes CSV"
    $ButtonCreationCSV.add_Click({.\fa_3_CreationComptesCSV.ps1})
    $ButtonCreationCSV_Click = {
	    $FenetreAccueil.Visible = $false
	    $FenetreCreationCSV.ShowDialog()
    }

    $ButtonUnit = New-Object System.Windows.Forms.Button
    $ButtonUnit.Location = '190,30'
    $ButtonUnit.Size = '150,60'
    $ButtonUnit.Text = "Creation Compte Unitaire"
    $ButtonUnit.add_Click({MakeMenuUnit})
    $ButtonUnit_Click = {
	    $FenetreAccueil.Visible = $false
	    $FenetreCreationUnitaire.ShowDialog()
    }

    $ButtonResetPWD = New-Object System.Windows.Forms.Button
    $ButtonResetPWD.Location = '350,30'
    $ButtonResetPWD.Size = '150,60'
    $ButtonResetPWD.Text = "Réinisialisation MDP"
    $ButtonResetPWD.add_Click({MakeMenuResetPWD})
    $ButtonResetPWD_Click = {
	    $FenetreAccueil.Visible = $false
	    $FenetreResetPWD.ShowDialog()
    }

    $ButtonHistorique = New-Object System.Windows.Forms.Button
    $ButtonHistorique.Location = '510,30'
    $ButtonHistorique.Size = '150,60'
    $ButtonHistorique.Text = 'Historique'
    $ButtonHistorique.add_Click({MakeMenuHistorique})
    $ButtonHistorique_Click = {
	    $FenetreAccueil.Visible = $false
	    $FenetreHistorique.ShowDialog()
    }

    $ButtonGestionFormation = New-Object System.Windows.Forms.Button
    $ButtonGestionFormation.Location = '670,30'
    $ButtonGestionFormation.Size = '150,60'
    $ButtonGestionFormation.Text = "Gestion des sites et formations"
    $ButtonGestionFormation.add_Click({.\formsite.ps1})

    $ButtonParametres = New-Object System.Windows.Forms.Button
    $ButtonParametres.Location = '830,30'
    $ButtonParametres.Size = '150,60'
    $ButtonParametres.Text = "Paramètres"
    $ButtonParametres.add_Click({.\fa_7_Parametres.ps1})
    $ButtonParametres_Click = {
	    $FenetreAccueil.Visible = $false
	    $FenetreParametres.ShowDialog()
    }

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