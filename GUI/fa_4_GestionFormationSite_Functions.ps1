Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$ListBoxAffichage = New-Object System.Windows.Forms.ListBox
$ComboBoxSites = New-Object System.Windows.Forms.ComboBox
$ComboBoxFormations = New-Object System.Windows.Forms.ComboBox


Function MakeMenuFormations {
    $buttonAjouter = New-Object System.Windows.Forms.Button
    $buttonAjouter.Location = New-Object System.Drawing.Point(220,10)
    $buttonAjouter.Size = New-Object System.Drawing.Size(70,22)
    $buttonAjouter.Text = "Ajouter"
    $buttonAjouter.Add_Click({AddFormation})

    $buttonSupprimer = New-Object System.Windows.Forms.Button
    $buttonSupprimer.Location = New-Object System.Drawing.Point(295,10)
    $buttonSupprimer.Size = New-Object System.Drawing.Size(70,22)
    $buttonSupprimer.Text = "Supprimer"
    $buttonSupprimer.Add_Click({DeleteFormation})

    #afficher tous les comptes pour un profil sélectionné + checkbox pour sélectionner les users (en fonction du nombre de users dans la base
    $script:ComboBoxFormations.Location = New-Object System.Drawing.Point(10,10)
    $script:ComboBoxFormations.Size = New-Object System.Drawing.Size(200,20)
    $script:ComboBoxFormations.add_SelectedIndexChanged({FillPlateformes})
    FillComboBox $script:ComboBoxFormations $formations "nom"

    $script:ListBoxAffichage.Controls.clear();
    $script:ListBoxAffichage.Controls.Add($script:ComboBoxFormations)
    $script:ListBoxAffichage.Controls.Add($script:listBoxPlateformes)
    $script:ListBoxAffichage.Controls.Add($buttonAjouter)
    $script:ListBoxAffichage.Controls.Add($buttonSupprimer)

    # alimentation des champs pour le profil selectionne
    FillPlateformes
    FillPlateformes
}

Function AddFormation {
    # on vérifie qu'on essaie pas d'insérer une entrée déjà existante
    if($script:ComboBoxFormations.SelectedIndex -eq -1 -and -not [string]::IsNullOrEmpty($script:ComboBoxFormations.Text)) {
        # on crée le nouveau profil
        $reqInsertFormation = "insert into formation(nom) values('" + $script:ComboBoxFormations.Text + "')"
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

        # on recharge les infos
        $script:formations = MakeRequest "SELECT * FROM formation"
        FillComboBox $script:ComboBoxFormations $script:formations "nom"
    }
}

Function DeleteFormation {
    # on vérifie qu'on essaie pas de supprimer une nouvelle entrée pas encore insérée
    if($script:ComboBoxFormations.SelectedIndex -ne -1) {
        # on supprime d'abord les droits plateformes
        $reqDeleteFormationSite = "delete from ass_formation_site where formation="
        $reqDeleteFormationSite += $script:ComboBoxFormations.SelectedItem.id
        MakeRequest $reqDeleteFormationSite

        # on supprime d'abord les droits formation et site
        $reqDeletePlateformeFormation = "delete from ass_plateforme_formation where formation="
        $reqDeletePlateformeFormation += $script:ComboBoxFormations.SelectedItem.id
        MakeRequest $reqDeletePlateformeFormation
        
        # puis le profil en lui-même
        $reqDeleteFormation = "delete from formation where id="
        $reqDeleteFormation += $script:ComboBoxFormations.SelectedItem.id
        MakeRequest $reqDeleteFormation

        # on recharge les infos
        $script:formations = MakeRequest "SELECT * FROM formation"
        FillComboBox $script:ComboBoxFormations $script:formations "nom"
    }
}

Function MakeMenuSites {
    $buttonAjouter = New-Object System.Windows.Forms.Button
    $buttonAjouter.Location = New-Object System.Drawing.Point(220,10)
    $buttonAjouter.Size = New-Object System.Drawing.Size(70,22)
    $buttonAjouter.Text = "Ajouter"
    $buttonAjouter.Add_Click({AddSite})

    $buttonSupprimer = New-Object System.Windows.Forms.Button
    $buttonSupprimer.Location = New-Object System.Drawing.Point(295,10)
    $buttonSupprimer.Size = New-Object System.Drawing.Size(70,22)
    $buttonSupprimer.Text = "Supprimer"
    $buttonSupprimer.Add_Click({DeleteSite})

    #afficher tous les comptes pour un profil sélectionné + checkbox pour sélectionner les users (en fonction du nombre de users dans la base
    $script:ComboBoxSites.Location = New-Object System.Drawing.Point(10,10)
    $script:ComboBoxSites.Size = New-Object System.Drawing.Size(200,20)
    $script:ComboBoxSites.add_SelectedIndexChanged({FillFormations})
    FillComboBox $script:ComboBoxSites $sites "nom"

    $script:ListBoxAffichage.Controls.clear();
    $script:ListBoxAffichage.Controls.Add($script:ComboBoxSites)
    $script:ListBoxAffichage.Controls.Add($script:listBoxFormations)
    $script:ListBoxAffichage.Controls.Add($buttonAjouter)
    $script:ListBoxAffichage.Controls.Add($buttonSupprimer)

    # alimentation des champs pour le profil selectionne
    FillFormations
    FillFormations
}

Function AddSite {
    # on vérifie qu'on essaie pas d'insérer une entrée déjà existante
    if($script:ComboBoxSites.SelectedIndex -eq -1 -and -not [string]::IsNullOrEmpty($script:ComboBoxSites.Text)) {
        # on crée le nouveau profil
        $reqInsertSite = "insert into site(nom) values('" + $script:ComboBoxSites.Text + "')"
        MakeRequest $reqInsertSite
        $reqSelect = "select last_insert_id() as id"
        # last_insert_id() permet de récupérer le dernier auto_increment de la connexion courante
        # c'est donc valide même dans le cas de plusieurs clients en parallèle
        $idNewSite = MakeRequest $reqSelect

        # on crée les droits plateformes avec accord à 0
        $reqInsertFormationSite = "insert into ass_formation_site(formation,site,existe)"
        $reqInsertFormationSite += " select formation.ID ," + $idNewSite.id + ", 0 from formation"
        MakeRequest $reqInsertFormationSite

        # on recharge les infos
        $script:sites = MakeRequest "SELECT * FROM site"
        FillComboBox $script:ComboBoxSites $script:sites "nom"
    }
}

Function DeleteSite {
    # on vérifie qu'on essaie pas de supprimer une nouvelle entrée pas encore insérée
    if($script:ComboBoxSites.SelectedIndex -ne -1) {
        # on supprime d'abord les droits plateformes
        $reqDeleteFormationSite = "delete from ass_formation_site where site="
        $reqDeleteFormationSite += $script:ComboBoxSites.SelectedItem.id
        MakeRequest $reqDeleteFormationSite
        
        # puis le profil en lui-même
        $reqDeleteSite = "delete from site where id="
        $reqDeleteSite += $script:ComboBoxSites.SelectedItem.id
        MakeRequest $reqDeleteSite

        # on recharge les infos
        $script:site = MakeRequest "SELECT * FROM site"
        FillComboBox $script:ComboBoxSites $script:site "nom"
    }
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
        # la case n'est pas encore décochée quand l'événement est déclenché, d'où le -not
        $defaut = -not $script:listBoxPlateformes.GetItemChecked($script:listBoxPlateformes.SelectedIndex)
        $reqUpdate = "update ass_plateforme_formation set defaut = " + $defaut
        $reqUpdate += " where id = " + $script:listBoxPlateformes.SelectedItem.id
        MakeRequest $reqUpdate
    }
}

Function FillFormations {
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
    $reqSel += " join formation f on f.id = fs.formation where fs.site = " + $script:ComboBoxSites.SelectedItem.id + " order by fs.formation ;"

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

Function FillPlateformes {
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
    $reqSel += " join plateforme p on p.id = pf.plateforme where pf.formation = " + $script:ComboBoxFormations.SelectedItem.id + " order by pf.formation ;"

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

    $ButtonFormations = New-Object System.Windows.Forms.Button
    $ButtonFormations.Location = New-Object System.Drawing.Point(40,100)
    $ButtonFormations.Size = New-Object System.Drawing.Size(200,50)
    $ButtonFormations.Text = "Formations"
    $ButtonFormations.Add_Click({MakeMenuFormations})

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