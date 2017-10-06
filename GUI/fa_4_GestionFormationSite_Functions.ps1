Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$ListBoxAffichage = New-Object System.Windows.Forms.ListBox
$ComboBoxSite = New-Object System.Windows.Forms.ComboBox
$ComboBoxFormation = New-Object System.Windows.Forms.ComboBox

$textBoxFormation = New-Object System.Windows.Forms.TextBox
$textBoxSite = New-Object System.Windows.Forms.TextBox

$buttonAjouterFormation = New-Object System.Windows.Forms.Button
$clickAddFormationAdded = $false
$buttonEnregistrerFormation = New-Object System.Windows.Forms.Button
$clickModifyFormationAdded = $false
$buttonSupprimerFormation = New-Object System.Windows.Forms.Button
$clickDeleteFormationAdded = $false

$buttonAjouterSite = New-Object System.Windows.Forms.Button
$clickAddSiteAdded = $false
$buttonEnregistrerSite = New-Object System.Windows.Forms.Button
$clickModifySiteAdded = $false
$buttonSupprimerSite = New-Object System.Windows.Forms.Button
$clickDeleteSiteAdded = $false

function FillComboBox([System.Windows.Forms.ComboBox] $comboBox, $elems, $nomCol) {
    # creation de la datatable
    $table = New-Object system.Data.DataTable
		
    # definition des colonnes
    $colId = New-Object system.Data.DataColumn "id",([int])
    $colLib = New-Object system.Data.DataColumn $nomCol,([string])
 
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

Function MakeMenuFormations {

    #afficher tous les comptes pour un profil sélectionné + checkbox pour sélectionner les users (en fonction du nombre de users dans la base
    $script:ComboBoxFormation.Location = New-Object System.Drawing.Point(10,10)
    $script:ComboBoxFormation.Size = New-Object System.Drawing.Size(200,20)
    $script:ComboBoxFormation.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
    $script:ComboBoxFormation.add_SelectedIndexChanged({FillPlateforme})
    FillComboBox $script:ComboBoxFormation $formations "nom"

    $script:textBoxFormation.Location = New-Object System.Drawing.Point(10,10)
    $script:textBoxFormation.Size = New-Object System.Drawing.Size(200,20)
    $script:textBoxFormation.Visible = $false

    $script:buttonAjouterFormation.Location = New-Object System.Drawing.Point(220,10)
    $script:buttonAjouterFormation.Size = New-Object System.Drawing.Size(70,22)
    $script:buttonAjouterFormation.Text = "Ajouter"
    if(-not $script:clickAddFormationAdded) {
        $script:clickAddFormationAdded = $true
        $script:buttonAjouterFormation.Add_Click({AddFormation})
    }
    $toolTipAjouter = New-Object System.Windows.Forms.ToolTip
    $toolTipAjouter.SetToolTip($script:buttonAjouterFormation, "Pour ajouter une formation, cliquer sur Ajouter, renseigner le nom de la formation puis cliquer sur Enregistrer")

    $script:buttonEnregistrerFormation.Location = New-Object System.Drawing.Point(295,10)
    $script:buttonEnregistrerFormation.Size = New-Object System.Drawing.Size(70,22)
    $script:buttonEnregistrerFormation.Text = "Enregistrer"
    $script:buttonEnregistrerFormation.Visible = $false
    if(-not $script:clickModifyFormationAdded) {
        $script:clickModifyFormationAdded = $true
        $script:buttonEnregistrerFormation.Add_Click({ModifyFormation})
    }

    $script:buttonSupprimerFormation.Location = New-Object System.Drawing.Point(295,10)
    $script:buttonSupprimerFormation.Size = New-Object System.Drawing.Size(70,22)
    $script:buttonSupprimerFormation.Text = "Supprimer"
    $script:buttonSupprimerFormation.Visible = $true
    if(-not $script:clickDeleteFormationAdded) {
        $script:clickDeleteFormationAdded = $true
        $script:buttonSupprimerFormation.Add_Click({DeleteFormation})
    }

    $script:ListBoxAffichage.Controls.clear();
    $script:ListBoxAffichage.Controls.Add($script:buttonAjouterFormation)
    $script:ListBoxAffichage.Controls.Add($script:buttonEnregistrerFormation)
    $script:ListBoxAffichage.Controls.Add($script:buttonSupprimerFormation)
    $script:ListBoxAffichage.Controls.Add($script:ComboBoxFormation)
    $script:ListBoxAffichage.Controls.Add($script:textBoxFormation)
    $script:ListBoxAffichage.Controls.Add($script:listBoxPlateformes)

    # alimentation des champs pour le profil selectionne
    FillPlateforme
    FillPlateforme
}

Function AddFormation {
    if($script:buttonAjouterFormation.Text -eq "Ajouter") {
        # on passe en ajout, on modifie le texte du bouton ajouter pour permettre l'annulation
        $script:buttonAjouterFormation.Text = "Annuler"

        # on cache la combo-box et on affiche le champ à vide
        $script:textBoxFormation.Text = ""
        $script:ComboBoxFormation.Visible = $false
        $script:textBoxFormation.Visible = $true
        
        # on cache le button supprimer et on affiche le button Enregistrer
        $script:buttonSupprimerFormation.Visible = $false
        $script:buttonEnregistrerFormation.Visible = $true
    } else {
        # on annule l'ajout, on rétablit le texte du bouton ajouter
        $script:buttonAjouterFormation.Text = "Ajouter"

        # on affiche la combo-box, on vide le champ profil et on le cache
        $script:textBoxFormation.Text = ""
        $script:ComboBoxFormation.Visible = $true
        $script:textBoxFormation.Visible = $false

        # on cache le bouton enregistrer et on affiche le bouton supprimer
        $script:buttonSupprimerFormation.Visible = $true
        $script:buttonEnregistrerFormation.Visible = $false
        
        # on recharge les infos
        $script:formations = MakeRequest "SELECT * FROM formation"
        FillComboBox $script:ComboBoxFormation $script:formations "nom"
    }
}

Function ModifyFormation {
    if($script:textBoxFormation.Text -ne "") {
        # on crée le nouveau profil
        $reqInsertFormation = "insert into formation(nom) values('" + $script:textBoxFormation.Text + "')"
        MakeRequest $reqInsertFormation
        $reqSelect = "select last_insert_id() as id"
        # last_insert_id() permet de récupérer le dernier auto_increment de la connexion courante
        # c'est donc valide même dans le cas de plusieurs clients en parallèle
        $idNewFormation = MakeRequest $reqSelect
        
               # on crée les droits plateformes avec accord à 0
        $reqInsertPlateformeFormation = "insert into ass_plateforme_formation(plateforme,formation,defaut)"
        $reqInsertPlateformeFormation += " select plateforme.ID, " + $idNewFormation.id + " , 0 from plateforme"
        MakeRequest $reqInsertPlateformeFormation

        # on crée les droits plateformes avec accord à 0
        $reqInsertFormationSite = "insert into ass_formation_site(formation,site,existe)"
        $reqInsertFormationSite += " select " + $idNewFormation.id + ", site.ID , 0 from site"
        MakeRequest $reqInsertFormationSite

        # on affiche la combo-box, on vide le champ profil et on le cache
        $script:textBoxFormation.Text = ""
        $script:ComboBoxFormation.Visible = $true
        $script:textBoxFormation.Visible = $false

        # on cache le bouton Enregistrer et on affiche le bouton supprimer
        $script:buttonSupprimerFormation.Visible = $true
        $script:buttonEnregistrerFormation.Visible = $false

        
        # on rétablit le texte du bouton ajouter
        $script:buttonAjouterFormation.Text = "Ajouter"

        # on recharge les infos
        $script:formations = MakeRequest "SELECT * FROM formation"
        FillComboBox $script:ComboBoxFormation $script:formations "nom"

        # on sélectionne le dernier élément de la combo, c'est en principe le dernier ajouté
        $script:ComboBoxFormation.SelectedIndex = $script:ComboBoxFormation.Items.Count - 1
    }
}

Function DeleteFormation {
    # on vérifie qu'on essaie pas de supprimer une nouvelle entrée pas encore insérée
    # on supprime d'abord les droits plateformes
    $reqDeleteFormationSite = "delete from ass_formation_site where formation="
    $reqDeleteFormationSite += $script:ComboBoxFormation.SelectedItem.id
    MakeRequest $reqDeleteFormationSite

    # on supprime d'abord les droits formation et site
    $reqDeletePlateformeFormation = "delete from ass_plateforme_formation where formation="
    $reqDeletePlateformeFormation += $script:ComboBoxFormation.SelectedItem.id
    MakeRequest $reqDeletePlateformeFormation
        
    # puis le profil en lui-même
    $reqDeleteFormation = "delete from formation where id="
    $reqDeleteFormation += $script:ComboBoxFormation.SelectedItem.id
    MakeRequest $reqDeleteFormation

    # on recharge les infos
    $script:formations = MakeRequest "SELECT * FROM formation"
    FillComboBox $script:ComboBoxFormation $script:formations "nom"
 
}

Function MakeMenuSites {
    #afficher tous les comptes pour un profil sélectionné + checkbox pour sélectionner les users (en fonction du nombre de users dans la base
    $script:ComboBoxSite.Location = New-Object System.Drawing.Point(10,10)
    $script:ComboBoxSite.Size = New-Object System.Drawing.Size(200,20)
    $script:ComboBoxSite.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
    $script:ComboBoxSite.add_SelectedIndexChanged({FillFormation})
    FillComboBox $script:ComboBoxSite $sites "nom"

    $script:textBoxSite.Location = New-Object System.Drawing.Point(10,10)
    $script:textBoxSite.Size = New-Object System.Drawing.Size(200,20)
    $script:textBoxSite.Visible = $false

    $script:buttonAjouterSite.Location = New-Object System.Drawing.Point(220,10)
    $script:buttonAjouterSite.Size = New-Object System.Drawing.Size(70,22)
    $script:buttonAjouterSite.Text = "Ajouter"
    if(-not $script:clickAddSiteAdded) {
        $script:clickAddSiteAdded = $true
        $script:buttonAjouterSite.Add_Click({AddSite})
    }
    $toolTipAjouter = New-Object System.Windows.Forms.ToolTip
    $toolTipAjouter.SetToolTip($script:buttonAjouterSite, "Pour ajouter un site, cliquer sur Ajouter, renseigner le nom du site puis cliquer sur Enregistrer")

    $script:buttonEnregistrerSite.Location = New-Object System.Drawing.Point(295,10)
    $script:buttonEnregistrerSite.Size = New-Object System.Drawing.Size(70,22)
    $script:buttonEnregistrerSite.Text = "Enregistrer"
    $script:buttonEnregistrerSite.Visible = $false
    if(-not $script:clickModifySiteAdded) {
        $script:clickModifySiteAdded = $true
        $script:buttonEnregistrerSite.Add_Click({ModifySite})
    }

    $script:buttonSupprimerSite.Location = New-Object System.Drawing.Point(295,10)
    $script:buttonSupprimerSite.Size = New-Object System.Drawing.Size(70,22)
    $script:buttonSupprimerSite.Text = "Supprimer"
    $script:buttonSupprimerSite.Visible = $true
    if(-not $script:clickDeleteSiteAdded) {
        $script:clickDeleteSiteAdded = $true
        $script:buttonSupprimerSite.Add_Click({DeleteSite})
    }
    $script:ListBoxAffichage.Controls.clear();
    $script:ListBoxAffichage.Controls.Add($script:ComboBoxSite)
    $script:ListBoxAffichage.Controls.Add($script:listBoxFormations)
    $script:ListBoxAffichage.Controls.Add($script:buttonAjouterSite)
    $script:ListBoxAffichage.Controls.Add($script:buttonEnregistrerSite)
    $script:ListBoxAffichage.Controls.Add($script:buttonSupprimerSite)
    $script:ListBoxAffichage.Controls.Add($script:textBoxSite)

    # alimentation des champs pour le profil selectionne
    FillFormation
    FillFormation
}

Function ModifySite {
    if($script:textBoxSite.Text -ne "") {
        # on crée le nouveau profil
        $reqInsertSite = "insert into site(nom) values('" + $script:textBoxSite.Text + "')"
        MakeRequest $reqInsertSite
        $reqSelect = "select last_insert_id() as id"
        # last_insert_id() permet de récupérer le dernier auto_increment de la connexion courante
        # c'est donc valide même dans le cas de plusieurs clients en parallèle
        $idNewSite = MakeRequest $reqSelect
        
        # on crée les droits plateformes avec accord à 0
        $reqInsertFormationSite = "insert into ass_formation_site(formation,site,existe)"
        $reqInsertFormationSite += " select formation.ID ," + $idNewSite.id + ", 0 from formation"
        MakeRequest $reqInsertFormationSite

        # on affiche la combo-box, on vide le champ profil et on le cache
        $script:textBoxSite.Text = ""
        $script:ComboBoxSite.Visible = $true
        $script:textBoxSite.Visible = $false

        # on cache le bouton Enregistrer et on affiche le bouton supprimer
        $script:buttonSupprimerSite.Visible = $true
        $script:buttonEnregistrerSite.Visible = $false

        
        # on rétablit le texte du bouton ajouter
        $script:buttonAjouterSite.Text = "Ajouter"

        # on recharge les infos
        $script:sites = MakeRequest "SELECT * FROM site"
        FillComboBox $script:ComboBoxSite $script:sites "nom"

        # on sélectionne le dernier élément de la combo, c'est en principe le dernier ajouté
        $script:ComboBoxSite.SelectedIndex = $script:ComboBoxSite.Items.Count - 1
    }
}

Function AddSite {
    if($script:buttonAjouterSite.Text -eq "Ajouter") {
        # on passe en ajout, on modifie le texte du bouton ajouter pour permettre l'annulation
        $script:buttonAjouterSite.Text = "Annuler"

        # on cache la combo-box et on affiche le champ à vide
        $script:textBoxSite.Text = ""
        $script:ComboBoxSite.Visible = $false
        $script:textBoxSite.Visible = $true
        
        # on cache le button supprimer et on affiche le button Enregistrer
        $script:buttonSupprimerSite.Visible = $false
        $script:buttonEnregistrerSite.Visible = $true
    } else {
        # on annule l'ajout, on rétablit le texte du bouton ajouter
        $script:buttonAjouterSite.Text = "Ajouter"

        # on affiche la combo-box, on vide le champ profil et on le cache
        $script:textBoxSite.Text = ""
        $script:ComboBoxSite.Visible = $true
        $script:textBoxSite.Visible = $false

        # on cache le bouton enregistrer et on affiche le bouton supprimer
        $script:buttonSupprimerSite.Visible = $true
        $script:buttonEnregistrerSite.Visible = $false
        
        # on recharge les infos
        $script:sites = MakeRequest "SELECT * FROM site"
        FillComboBox $script:ComboBoxSite $script:sites "nom"
    }
}

Function DeleteSite {
    # on vérifie qu'on essaie pas de supprimer une nouvelle entrée pas encore insérée
    # on supprime d'abord les droits plateformes
    $reqDeleteFormationSite = "delete from ass_formation_site where site="
    $reqDeleteFormationSite += $script:ComboBoxSite.SelectedItem.id
    MakeRequest $reqDeleteFormationSite
        
    # puis le profil en lui-même
    $reqDeleteSite = "delete from site where id="
    $reqDeleteSite += $script:ComboBoxSite.SelectedItem.id
    MakeRequest $reqDeleteSite

    # on recharge les infos
    $script:site = MakeRequest "SELECT * FROM site"
    FillComboBox $script:ComboBoxSite $script:site "nom"
}

Function ModifySiteFormations {
    if($script:saveEnabled) {
        # la case n'est pas encore décochée quand l'événement est déclenché, d'où le -not
        $existe = -not $script:listBoxFormations.GetItemChecked($script:listBoxFormations.SelectedIndex)
        $reqUpdate = "update ass_formation_site set existe = " + $existe
        $reqUpdate += " where id = " + $script:listBoxFormations.SelectedItem.id
        MakeRequest $reqUpdate
    }
}

Function ModifyFormationPlateformes {
    if($script:saveEnabled) {
        $plateforme = RetreiveRow $script:plateformes "nom" $script:listBoxPlateformes.Items[$script:listBoxPlateformes.SelectedIndex].nom
        if($plateforme.obligatoire -and $script:listBoxPlateformes.GetItemChecked($script:listBoxPlateformes.SelectedIndex)) {
            $_.NewValue = [System.Windows.Forms.CheckState]::Checked
        } else {
            # la case n'est pas encore décochée quand l'événement est déclenché, d'où le -not
            $defaut = -not $script:listBoxPlateformes.GetItemChecked($script:listBoxPlateformes.SelectedIndex)
            $reqUpdate = "update ass_plateforme_formation set defaut = " + $defaut
            $reqUpdate += " where id = " + $script:listBoxPlateformes.SelectedItem.id
            MakeRequest $reqUpdate
        }
    }
}

Function FillFormation {
    #afficher les droits de création et réinitialisation de compte en lien avec le profil et en fonction du nombre de plateformes

    # creation de la datatable
    $table = New-Object system.Data.DataTable
		
    # definition des colonnes
    $colId = New-Object system.Data.DataColumn "id",([string])
    $colFormation = New-Object system.Data.DataColumn "nom",([string])
 
    # table des colonnes à la datatable
    $table.Columns.Add($colId)
    $table.Columns.Add($colFormation)

    # alimentation de la datatable avec les plateformes
    $reqSel = "select fs.id, f.nom, fs.existe from ass_formation_site fs"
    $reqSel += " join formation f on f.id = fs.formation where fs.site = " + $script:ComboBoxSite.SelectedItem.id + " order by fs.formation ;"

    $listFormations = MakeRequest $reqSel
    foreach($listFormation in $listFormations) {
        $ligne = $table.NewRow()
        $ligne.id = $listFormation.id
        $ligne.nom = $listFormation.nom
        $table.Rows.Add($ligne)
    }

    $script:listBoxFormations.DisplayMember = "nom"
    $script:listBoxFormations.ValueMember = "id"
    $script:listBoxFormations.DataSource = $table    

    # on désactive la gestion de la sauvegarde quand on coche les cases
    $script:saveEnabled = $false
    # on coche les cases en fonction des données en base
    for($i=0;$i -lt $script:listBoxFormations.Items.Count; $i++) {
        $df = RetreiveRow $listFormations "id" $script:listBoxFormations.Items[$i].id
        $script:listBoxFormations.SetItemChecked($i, $df.existe)
    }

    # on réactive la gestion de la sauvegarde quand on coche les cases
    $script:saveEnabled = $true
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

    # on désactive la gestion de la sauvegarde quand on coche les cases
    $script:saveEnabled = $false
    # on coche les cases en fonction des données en base
    for($i=0;$i -lt $script:listBoxPlateformes.Items.Count; $i++) {
        $dp = RetreiveRow $listPlateformes "id" $script:listBoxPlateformes.Items[$i].id
        $script:listBoxPlateformes.SetItemChecked($i, $dp.defaut)
    }

    # on réactive la gestion de la sauvegarde quand on coche les cases
    $script:saveEnabled = $true
}

Function MakeForm {
    $listForm = New-Object System.Windows.Forms.Form
    $listForm.Text = "Formations et Sites"
    $listForm.Size = New-Object System.Drawing.Size(1000,700)
    $listForm.StartPosition = "CenterScreen"

    $script:ListBoxAffichage.Location = New-Object System.Drawing.Size(255,30)
    $script:ListBoxAffichage.Size = New-Object System.Drawing.Size(700,530)

    $ButtonSites = New-Object System.Windows.Forms.Button
    $ButtonSites.Location = New-Object System.Drawing.Point(40,40)
    $ButtonSites.Size = New-Object System.Drawing.Size(200,50)
    $ButtonSites.Text = "Sites"
    $ButtonSites.Add_Click({MakeMenuSites})
    $toolTipButtonSites = New-Object System.Windows.Forms.ToolTip
    $toolTipButtonSites.SetToolTip($ButtonSites, "Ajouter des sites et assigner les formations")

    $ButtonFormations = New-Object System.Windows.Forms.Button
    $ButtonFormations.Location = New-Object System.Drawing.Point(40,100)
    $ButtonFormations.Size = New-Object System.Drawing.Size(200,50)
    $ButtonFormations.Text = "Formations"
    $ButtonFormations.Add_Click({MakeMenuFormations})
    $toolTipButtonFormations = New-Object System.Windows.Forms.ToolTip
    $toolTipButtonFormations.SetToolTip($ButtonFormations, "Ajouter des formations et assigner les plateformes obligatoires")

    $ButtonRetour = New-Object System.Windows.Forms.Button
    $ButtonRetour.Location = New-Object System.Drawing.Point(30,580)
    $ButtonRetour.Size = New-Object System.Drawing.Size(150,60)
    $ButtonRetour.Text = "Retour"
    $ButtonRetour.Add_Click({$listForm.Close()})
    # la touche echap est mappée sur retour
    $listForm.CancelButton = $ButtonRetour

    $ListBoxMenu = New-Object System.Windows.Forms.ListBox 
    $ListBoxMenu.Location = New-Object System.Drawing.Size(30,30) 
    $ListBoxMenu.Size = New-Object System.Drawing.Size(220,530) 
    
    $listForm.Controls.Add($ButtonSites)
    $listForm.Controls.Add($ButtonFormations)
    $listForm.Controls.Add($ButtonRetour)
    $listForm.Controls.Add($ListBoxMenu)
    $listForm.Controls.Add($script:ListBoxAffichage)

    # Afficher la fenetre
    $listForm.ShowDialog()
}