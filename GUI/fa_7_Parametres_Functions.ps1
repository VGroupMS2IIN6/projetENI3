Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$ListBoxAffichage = New-Object System.Windows.Forms.ListBox

$textBoxAdURL = New-Object System.Windows.Forms.TextBox
$textBoxAdUser = New-Object System.Windows.Forms.TextBox
$textBoxAdMDP = New-Object System.Windows.Forms.TextBox
    
$ComboBoxPlateformes = New-Object System.Windows.Forms.ComboBox
$textBoxURL = New-Object System.Windows.Forms.TextBox
$textBoxMail = New-Object System.Windows.Forms.TextBox
$textBoxUser = New-Object System.Windows.Forms.TextBox
$textBoxMdp = New-Object System.Windows.Forms.TextBox
$textBoxRegexMdp = New-Object System.Windows.Forms.TextBox
$checkBoxObligatoire = New-Object System.Windows.Forms.CheckBox

$ComboBoxProfil = New-Object System.Windows.Forms.ComboBox

$ComboBoxUtilisateur = New-Object System.Windows.Forms.ComboBox

function RetreiveRow($rows, $field, $filter) {
    # on parcourt les lignes une part une, pour trouver celle qui correspond
    foreach($row in $rows)
    {
        if($row.$field -eq $filter)
        {
            return $row
        }
    }
}

function FillComboBox([System.Windows.Forms.ComboBox] $comboBox, $elems, $nomCol) {
    # creation de la datatable
    $table = New-Object system.Data.DataTable
		
    # definition des colonnes
    $colId = New-Object system.Data.DataColumn "id",([string])
    $colLib = New-Object system.Data.DataColumn $nomCol,([string])
 
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

Function ModifyAd {
    # on cr�� le r�pertoire s'il n'existe pas
    New-Item -ItemType Directory -Force -Path '..\config\'
    # on enregistre les 3 champs dans un fichier
    "url=" + $script:textBoxAdURL.Text > '..\config\ad.properties'
    "user=" + $script:textBoxAdUser.Text >> '..\config\ad.properties'
    "pass=" + $script:textBoxAdMDP.Text >> '..\config\ad.properties'
}

Function MakeMenuAd {
    $labelTitreAd = New-Object System.Windows.Forms.Label
    $labelTitreAd.Location = New-Object System.Drawing.Point(10,10)
    $labelTitreAd.Size = New-Object System.Drawing.Size(200,20)
    $labelTitreAd.Text = "Configuration Active Directory"
    $labelTitreAd.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes

    $labelAdURL = New-Object System.Windows.Forms.Label
    $labelAdURL.Location = New-Object System.Drawing.Point(10,50)
    $labelAdURL.Size = New-Object System.Drawing.Size(200,20)
    $labelAdURL.Text = "Adresse IP ou nom du serveur"
    $labelAdURL.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes

    $script:textBoxAdURL.Location = New-Object System.Drawing.Point(220,50)
    $script:textBoxAdURL.Size = New-Object System.Drawing.Size(200,22)

    $labelAdUser = New-Object System.Windows.Forms.Label
    $labelAdUser.Location = New-Object System.Drawing.Point(10,90)
    $labelAdUser.Size = New-Object System.Drawing.Size(200,20)
    $labelAdUser.Text = "Nom d'utilisateur"
    $labelAdUser.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes

    $script:textBoxAdUser.Location = New-Object System.Drawing.Point(220,90)
    $script:textBoxAdUser.Size = New-Object System.Drawing.Size(200,22)
    
    $labelAdMDP = New-Object System.Windows.Forms.Label
    $labelAdMDP.Location = New-Object System.Drawing.Point(10,130)
    $labelAdMDP.Size = New-Object System.Drawing.Size(200,20)
    $labelAdMDP.Text = "Mot de passe"
    $labelAdMDP.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes

    $script:textBoxAdMDP.Location = New-Object System.Drawing.Point(220,130)
    $script:textBoxAdMDP.Size = New-Object System.Drawing.Size(200,22)

    $buttonEnregistrerAd = New-Object System.Windows.Forms.Button
    $buttonEnregistrerAd.Location = New-Object System.Drawing.Point(220,10)
    $buttonEnregistrerAd.Size = New-Object System.Drawing.Size(70,22)
    $buttonEnregistrerAd.Text = "Enregistrer"
    $buttonEnregistrerAd.Add_Click({ModifyAd})

    $script:listBoxAffichage.Controls.clear();
    $script:listBoxAffichage.Controls.Add($labelTitreAd)
    $script:listBoxAffichage.Controls.Add($buttonEnregistrerAd)
    $script:listBoxAffichage.Controls.Add($labelAdURL)
    $script:listBoxAffichage.Controls.Add($script:textBoxAdURL)
    $script:listBoxAffichage.Controls.Add($labelAdUser)
    $script:listBoxAffichage.Controls.Add($script:textBoxAdUser)
    $script:listBoxAffichage.Controls.Add($labelAdMDP)
    $script:listBoxAffichage.Controls.Add($script:textBoxAdMDP)

    # si le fichier existe, on charge les donn�es
    if(Test-Path '..\config\ad.properties') {
        $adprop = ConvertFrom-StringData (Get-Content '..\config\ad.properties' -raw)
        $script:textBoxAdURL.Text = $adprop.'url'
        $script:textBoxAdUser.Text = $adprop.'user'
        $script:textBoxAdMDP.Text = $adprop.'pass'
    }
}

Function FillPlateforme {
    $plateforme = RetreiveRow $script:plateformes "id" $script:ComboBoxPlateformes.SelectedItem.id
    $script:textBoxURL.Text = $plateforme.URL
    $script:textBoxMail.Text = $plateforme.mail
    $script:textBoxUser.Text = $plateforme.identifiant
    $script:textBoxMdp.Text = $plateforme.MDP
    $script:textBoxRegexMdp.Text = $plateforme.regexMDP
    $script:checkBoxObligatoire.Checked = $plateforme.obligatoire
}

Function AddPlateforme {
    # on v�rifie qu'on essaie pas d'ins�rer une entr�e d�j� existante
    if($script:ComboBoxPlateformes.SelectedIndex -eq -1 -and -not [string]::IsNullOrEmpty($script:ComboBoxPlateformes.Text)) {
        $reqInsert = "insert into plateforme(nom, "
        $reqValues = " values('" + $script:ComboBoxPlateformes.Text + "',"
        if(-not [string]::IsNullOrEmpty($script:textBoxURL.Text)) {
            $reqInsert += "URL,"
            $reqValues += "'" + $script:textBoxURL.Text + "',"
        }
        if(-not [string]::IsNullOrEmpty($script:textBoxMail.Text)) {
            $reqInsert += "mail,"
            $reqValues += "'" + $script:textBoxMail.Text + "',"
        }
        if(-not [string]::IsNullOrEmpty($script:textBoxUser.Text)) {
            $reqInsert += "identifiant,"
            $reqValues += "'" + $script:textBoxUser.Text + "',"
        }
         if(-not [string]::IsNullOrEmpty($script:textBoxMDP.Text)) {
            $reqInsert += "MDP,"
            $reqValues += "'" + $script:textBoxMDP.Text + "',"
        }
        if(-not [string]::IsNullOrEmpty($script:textBoxRegexMdp.Text)) {
            $reqInsert += "regexMDP,"
            $reqValues += "'" + $script:textBoxRegexMdp.Text + "',"
        }
        $reqValues += "" + $script:checkBoxObligatoire.Checked + ")"

        $reqInsert += "obligatoire)" + $reqValues
        MakeRequest $reqInsert

        # last_insert_id() permet de r�cup�rer le dernier auto_increment de la connexion courante
        # c'est donc valide m�me dans le cas de plusieurs clients en parall�le
        $idNewPlateforme = MakeRequest "select last_insert_id() as id"

        # on ajoute les droits pour les plateformes
        $reqInsertDroitsPlateformes = "INSERT INTO ass_droit_plateforme (droit, plateforme)"
        $reqInsertDroitsPlateformes += " select droit.ID, " + $idNewPlateforme.id + " from droit"
        MakeRequest $reqInsertDroitsPlateformes

        # on ajoute les droits pour les plateformes
        $reqInsertProfilDroitsPlateformes = "INSERT INTO ass_profil_droit_plateforme(profil, droit_plateforme, accord)"
        $reqInsertProfilDroitsPlateformes += " select profil.ID, ass_droit_plateforme.ID, 0 from profil, ass_droit_plateforme"
        $reqInsertProfilDroitsPlateformes += " where ass_droit_plateforme.plateforme = " + $idNewPlateforme.id
        MakeRequest $reqInsertProfilDroitsPlateformes

        # on recharge les infos
        $script:plateformes = MakeRequest "SELECT * FROM plateforme"
        FillComboBox $script:ComboBoxPlateformes $script:plateformes "nom"
    }
}

Function ModifyPlateforme {
    # on v�rifie qu'on essaie pas de modifier une nouvelle entr�e pas encore ins�r�e
    if($script:ComboBoxPlateformes.SelectedIndex -ne -1) {
        $reqUpdate = "update plateforme set"
        $reqUpdate += " URL='" + $script:textBoxURL.Text + "',"
        $reqUpdate += " mail='" + $script:textBoxMail.Text + "',"
        $reqUpdate += " identifiant='" + $script:textBoxUser.Text + "',"
        $reqUpdate += " MDP='" + $script:textBoxMdp.Text + "',"
        $reqUpdate += " RegexMDP='" + $script:textBoxRegexMdp.Text + "',"
        $reqUpdate += " obligatoire=" + $script:checkBoxObligatoire.Checked
        $reqUpdate += " where id=" + $script:ComboBoxPlateformes.SelectedItem.id
        MakeRequest $reqUpdate

        # on recharge les infos
        $script:plateformes = MakeRequest "SELECT * FROM plateforme"
    }
}

Function DeletePlateforme([System.Windows.Forms.ComboBox] $script:ComboBoxPlateformes) {
    # on v�rifie qu'on essaie pas de supprimer une nouvelle entr�e pas encore ins�r�e
    if($script:ComboBoxPlateformes.SelectedIndex -ne -1) {
        $idPlateforme = $script:ComboBoxPlateformes.SelectedItem.id

        $reqDeleteProfilDroitsPlateformes = "delete from ass_profil_droit_plateforme"
        $reqDeleteProfilDroitsPlateformes += " where droit_plateforme in "
        $reqDeleteProfilDroitsPlateformes += "  (select ID from ass_droit_plateforme where plateforme = " + $idPlateforme + ")"
        MakeRequest $reqDeleteProfilDroitsPlateformes

        $reqDeleteDroitsPlateformes = "delete from ass_droit_plateforme"
        $reqDeleteDroitsPlateformes += " where plateforme = " + $idPlateforme
        MakeRequest $reqDeleteDroitsPlateformes

        $reqDelete = "delete from plateforme where id = " + $idPlateforme
        MakeRequest $reqDelete

        # on recharge les infos
        $script:plateformes = MakeRequest "SELECT * FROM plateforme"
        FillComboBox $script:ComboBoxPlateformes $script:plateformes "nom"
    }
}

Function MakeMenuPlateformes {
    $labelURL = New-Object System.Windows.Forms.Label
    $labelURL.Location = New-Object System.Drawing.Point(10,50)
    $labelURL.Size = New-Object System.Drawing.Size(200,20)
    $labelURL.Text = "Adresse IP ou nom du serveur"
    $labelURL.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes

    $script:textBoxURL.Location = New-Object System.Drawing.Point(220,50)
    $script:textBoxURL.Size = New-Object System.Drawing.Size(200,22)

    $labelMail = New-Object System.Windows.Forms.Label
    $labelMail.Location = New-Object System.Drawing.Point(10,90)
    $labelMail.Size = New-Object System.Drawing.Size(200,20)
    $labelMail.Text = "Adresse mail destinataire"
    $labelMail.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes

    $script:textBoxMail.Location = New-Object System.Drawing.Point(220,90)
    $script:textBoxMail.Size = New-Object System.Drawing.Size(200,22)
    
    $labelUser = New-Object System.Windows.Forms.Label
    $labelUser.Location = New-Object System.Drawing.Point(10,130)
    $labelUser.Size = New-Object System.Drawing.Size(200,20)
    $labelUser.Text = "Nom d'utilisateur"
    $labelUser.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes

    $script:textBoxUser.Location = New-Object System.Drawing.Point(220,130)
    $script:textBoxUser.Size = New-Object System.Drawing.Size(200,22)

    $labelMdp = New-Object System.Windows.Forms.Label
    $labelMdp.Location = New-Object System.Drawing.Point(10,170)
    $labelMdp.Size = New-Object System.Drawing.Size(200,20)
    $labelMdp.Text = "Mot de passe"
    $labelMdp.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes

    $script:textBoxMdp.Location = New-Object System.Drawing.Point(220,170)
    $script:textBoxMdp.Size = New-Object System.Drawing.Size(200,22)

    $labelRegexMdp = New-Object System.Windows.Forms.Label
    $labelRegexMdp.Location = New-Object System.Drawing.Point(10,210)
    $labelRegexMdp.Size = New-Object System.Drawing.Size(200,20)
    $labelRegexMdp.Text = "Regex de g�n�ration du mot de passe"
    $labelRegexMdp.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes

    $script:textBoxRegexMdp.Location = New-Object System.Drawing.Point(220,210)
    $script:textBoxRegexMdp.Size = New-Object System.Drawing.Size(200,22)
    
    $labelObligatoire = New-Object System.Windows.Forms.Label
    $labelObligatoire.Location = New-Object System.Drawing.Point(10,250)
    $labelObligatoire.Size = New-Object System.Drawing.Size(200,20)
    $labelObligatoire.Text = "Compte obligatoire"
    $labelObligatoire.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes

    $script:checkBoxObligatoire.Location = New-Object System.Drawing.Point(220,250)
    $script:checkBoxObligatoire.Size = New-Object System.Drawing.Size(200,22)
    
    $script:ComboBoxPlateformes.Location = New-Object System.Drawing.Point(10,10)
    $script:ComboBoxPlateformes.Size = New-Object System.Drawing.Size(200,20)
    $script:ComboBoxPlateformes.add_SelectedIndexChanged({FillPlateforme})
    FillComboBox $script:ComboBoxPlateformes $script:plateformes "nom"

    $buttonAjouter = New-Object System.Windows.Forms.Button
    $buttonAjouter.Location = New-Object System.Drawing.Point(220,10)
    $buttonAjouter.Size = New-Object System.Drawing.Size(70,22)
    $buttonAjouter.Text = "Ajouter"
    $buttonAjouter.Add_Click({AddPlateforme})

    $buttonEnregistrer = New-Object System.Windows.Forms.Button
    $buttonEnregistrer.Location = New-Object System.Drawing.Point(295,10)
    $buttonEnregistrer.Size = New-Object System.Drawing.Size(70,22)
    $buttonEnregistrer.Text = "Enregistrer"
    $buttonEnregistrer.Add_Click({ModifyPlateforme})

    $buttonSupprimer = New-Object System.Windows.Forms.Button
    $buttonSupprimer.Location = New-Object System.Drawing.Point(370,10)
    $buttonSupprimer.Size = New-Object System.Drawing.Size(70,22)
    $buttonSupprimer.Text = "Supprimer"
    $buttonSupprimer.Add_Click({DeletePlateforme})

    $script:ListBoxAffichage.Controls.clear();
    $script:ListBoxAffichage.Controls.Add($script:ComboBoxPlateformes)
    $script:ListBoxAffichage.Controls.Add($buttonAjouter)
    $script:ListBoxAffichage.Controls.Add($buttonEnregistrer)
    $script:ListBoxAffichage.Controls.Add($buttonSupprimer)
    $script:ListBoxAffichage.Controls.Add($labelURL)
    $script:ListBoxAffichage.Controls.Add($script:textBoxURL)
    $script:ListBoxAffichage.Controls.Add($labelMail)
    $script:ListBoxAffichage.Controls.Add($script:textBoxMail)
    $script:ListBoxAffichage.Controls.Add($labelUser)
    $script:ListBoxAffichage.Controls.Add($script:textBoxUser)
    $script:ListBoxAffichage.Controls.Add($labelMdp)
    $script:ListBoxAffichage.Controls.Add($script:textBoxMdp)
    $script:ListBoxAffichage.Controls.Add($labelRegexMdp)
    $script:ListBoxAffichage.Controls.Add($script:textBoxRegexMdp)
    $script:ListBoxAffichage.Controls.Add($labelObligatoire)
    $script:ListBoxAffichage.Controls.Add($script:checkBoxObligatoire)

    # alimentation des champs pour la plateforme selectionnee
    FillPlateforme
}

Function FillProfilFormSite {
    #afficher les droits de cr�ation et r�initialisation de compte en lien avec le profil et en fonction du nombre de plateformes

    # creation de la datatable
    $table = New-Object system.Data.DataTable
		
    # definition des colonnes
    $colId = New-Object system.Data.DataColumn "id",([string])
    $colDroit = New-Object system.Data.DataColumn "nom",([string])
 
    # table des colonnes � la datatable
    $table.Columns.Add($colId)
    $table.Columns.Add($colDroit)

    # alimentation de la datatable avec les plateformes
    $reqSel = "select pdu.ID, du.nom, pdu.accord from ass_profil_droits_utilisateurs pdu join profil p on pdu.profil = p.ID"
    $reqSel += " join droits_utilisateur du on du.ID = pdu.droit where p.ID = " + $script:ComboBoxProfil.SelectedItem.id + " order by p.ID;"
    $DroitsFormsSites = MakeRequest $reqSel
    foreach($DroitFormSite in $DroitsFormsSites) {
        $ligne = $table.NewRow()
        $ligne.id = $DroitFormSite.id
        $ligne.nom = $DroitFormSite.nom
        $table.Rows.Add($ligne)
    }

    $script:listBoxDroitFormSite.DisplayMember = "nom"
    $script:listBoxDroitFormSite.ValueMember = "id"
    $script:listBoxDroitFormSite.DataSource = $table    

    # on d�sactive la gestion de la sauvegarde quand on coche les cases
    $script:saveEnabled = $false
    # on coche les cases en fonction des donn�es en base
    for($i=0;$i -lt $script:listBoxDroitFormSite.Items.Count; $i++) {
        $dp = RetreiveRow $DroitsFormsSites "id" $script:listBoxDroitFormSite.Items[$i].id
        $script:listBoxDroitFormSite.SetItemChecked($i, $dp.accord)
    }
    # on r�active la gestion de la sauvegarde quand on coche les cases
    $script:saveEnabled = $true
}

Function FillProfilPlateforme {
    #afficher les droits de cr�ation et r�initialisation de compte en lien avec le profil et en fonction du nombre de plateformes

    # creation de la datatable
    $table = New-Object system.Data.DataTable
		
    # definition des colonnes
    $colId = New-Object system.Data.DataColumn "id",([string])
    $colDroit = New-Object system.Data.DataColumn "droit",([string])
 
    # table des colonnes � la datatable
    $table.Columns.Add($colId)
    $table.Columns.Add($colDroit)

    # alimentation de la datatable avec les plateformes
    $reqSel = "select pdp.ID, d.nom as nomdroit, pl.nom as nomplateforme, pdp.accord from ass_profil_droit_plateforme pdp join profil p on pdp.profil = p.ID"
    $reqSel += " join ass_droit_plateforme dp on pdp.droit_plateforme = dp.ID join droit d on dp.droit = d.ID"
    $reqSel += " join plateforme pl on dp.plateforme = pl.ID where p.ID = " + $script:ComboBoxProfil.SelectedItem.id + " order by d.nom, pl.nom;"
    $DroitsPlateformes = MakeRequest $reqSel
    foreach($DroitPlateforme in $DroitsPlateformes) {
        $ligne = $table.NewRow()
        $ligne.id = $DroitPlateforme.id
        $ligne.droit = $DroitPlateforme.nomdroit + " " + $DroitPlateforme.nomplateforme
        $table.Rows.Add($ligne)
    }

    $script:listBoxDroitPlateforme.DisplayMember = "droit"
    $script:listBoxDroitPlateforme.ValueMember = "id"
    $script:listBoxDroitPlateforme.DataSource = $table    

    # on d�sactive la gestion de la sauvegarde quand on coche les cases
    $script:saveEnabled = $false
    # on coche les cases en fonction des donn�es en base
    for($i=0;$i -lt $script:listBoxDroitPlateforme.Items.Count; $i++) {
        $dp = RetreiveRow $DroitsPlateformes "id" $script:listBoxDroitPlateforme.Items[$i].id
        $script:listBoxDroitPlateforme.SetItemChecked($i, $dp.accord)
    }
    # on r�active la gestion de la sauvegarde quand on coche les cases
    $script:saveEnabled = $true
    FillProfilFormSite
}

Function ModifyProfilDroitsPlateforme {
    if($script:saveEnabled) {
        # la case n'est pas encore d�coch�e quand l'�v�nement est d�clench�, d'o� le -not
        $accord = -not $script:listBoxDroitPlateforme.GetItemChecked($script:listBoxDroitPlateforme.SelectedIndex)
        $reqUpdate = "update ass_profil_droit_plateforme set accord = " + $accord
        $reqUpdate += " where id = " + $script:listBoxDroitPlateforme.SelectedItem.id
        MakeRequest $reqUpdate
    }
}

Function ModifyProfilDroitsFormSite {
    if($script:saveEnabled) {
        # la case n'est pas encore d�coch�e quand l'�v�nement est d�clench�, d'o� le -not
        $accord = -not $script:listBoxDroitFormSite.GetItemChecked($script:listBoxDroitFormSite.SelectedIndex)
        $reqUpdate = "update ass_profil_droits_utilisateurs set accord = " + $accord
        $reqUpdate += " where id = " + $script:listBoxDroitFormSite.SelectedItem.id
        MakeRequest $reqUpdate
    }
}

Function AddProfil {
    # on v�rifie qu'on essaie pas d'ins�rer une entr�e d�j� existante
    if($script:ComboBoxProfil.SelectedIndex -eq -1 -and -not [string]::IsNullOrEmpty($script:ComboBoxProfil.Text)) {
        # on cr�e le nouveau profil
        $reqInsertProfil = "insert into profil(nom) values('" + $script:ComboBoxProfil.Text + "')"
        MakeRequest $reqInsertProfil
        $reqSelect = "select last_insert_id() as id"
        # last_insert_id() permet de r�cup�rer le dernier auto_increment de la connexion courante
        # c'est donc valide m�me dans le cas de plusieurs clients en parall�le
        $idNewProfil = MakeRequest $reqSelect
        
        # on cr�e les droits plateformes avec accord � 0
        $reqInsertDroitsPlateformes = "insert into ass_profil_droit_plateforme(profil,droit_plateforme,accord)"
        $reqInsertDroitsPlateformes += " select " + $idNewProfil.id + ", ass_droit_plateforme.ID, 0 from ass_droit_plateforme"
        MakeRequest $reqInsertDroitsPlateformes

        # on cr�e les droits formation et site avec accord � 0
        $reqInsertDroitsFormSite = "insert into ass_profil_droits_utilisateurs(droit,profil,accord)"
        $reqInsertDroitsFormSite += " select droits_utilisateur.ID, " + $idNewProfil.id + ", 0 from droits_utilisateur"
        MakeRequest $reqInsertDroitsFormSite

        # on recharge les infos
        $script:profils = MakeRequest "SELECT * FROM profil"
        FillComboBox $script:ComboBoxProfil $script:profils "nom"
    }
}

Function DeleteProfil {
    # on v�rifie qu'on essaie pas de supprimer une nouvelle entr�e pas encore ins�r�e
    if($script:ComboBoxProfil.SelectedIndex -ne -1) {
        # on supprime d'abord les droits plateformes
        $reqDeleteDroitsPlateformes = "delete from ass_profil_droit_plateforme where profil="
        $reqDeleteDroitsPlateformes += $script:ComboBoxProfil.SelectedItem.id
        MakeRequest $reqDeleteDroitsPlateformes

        # on supprime d'abord les droits formation et site
        $reqDeleteDroitsPlateformes = "delete from ass_profil_droits_utilisateurs where profil="
        $reqDeleteDroitsPlateformes += $script:ComboBoxProfil.SelectedItem.id
        MakeRequest $reqDeleteDroitsPlateformes
        
        # puis le profil en lui-m�me
        $reqDeleteProfil = "delete from profil where id="
        $reqDeleteProfil += $script:ComboBoxProfil.SelectedItem.id
        MakeRequest $reqDeleteProfil

        # on recharge les infos
        $script:profils = MakeRequest "SELECT * FROM profil"
        FillComboBox $script:ComboBoxProfil $script:profils "nom"
    }
}

Function MakeMenuDefProfils {
    $buttonAjouter = New-Object System.Windows.Forms.Button
    $buttonAjouter.Location = New-Object System.Drawing.Point(220,10)
    $buttonAjouter.Size = New-Object System.Drawing.Size(70,22)
    $buttonAjouter.Text = "Ajouter"
    $buttonAjouter.Add_Click({AddProfil})

    $buttonSupprimer = New-Object System.Windows.Forms.Button
    $buttonSupprimer.Location = New-Object System.Drawing.Point(295,10)
    $buttonSupprimer.Size = New-Object System.Drawing.Size(70,22)
    $buttonSupprimer.Text = "Supprimer"
    $buttonSupprimer.Add_Click({DeleteProfil})

    $labelcreation = New-Object System.Windows.Forms.Label
    $labelcreation.Location = New-Object System.Drawing.Point(10,50)
    $labelcreation.Size = New-Object System.Drawing.Size(200,20)
    $labelcreation.Text = "Cr�ation de comptes"
    $labelcreation.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes

    $labelFormSite = New-Object System.Windows.Forms.Label
    $labelFormSite.Location = New-Object System.Drawing.Point(400,50)
    $labelFormSite.Size = New-Object System.Drawing.Size(200,20)
    $labelFormSite.Text = "droits formations et sites"
    $labelFormSite.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes

    $script:ComboBoxProfil.Location = New-Object System.Drawing.Point(10,10)
    $script:ComboBoxProfil.Size = New-Object System.Drawing.Size(200,20)
    $script:ComboBoxProfil.add_SelectedIndexChanged({FillProfilPlateforme})
    FillComboBox $script:ComboBoxProfil $profils "nom"

    $script:ListBoxAffichage.Controls.clear();
    $script:ListBoxAffichage.Controls.Add($buttonAjouter)
    $script:ListBoxAffichage.Controls.Add($buttonSupprimer)
    $script:ListBoxAffichage.Controls.Add($labelCreation)
    $script:ListBoxAffichage.Controls.Add($labelFormSite)
    $script:ListBoxAffichage.Controls.Add($script:listBoxDroitPlateforme)
    $script:ListBoxAffichage.Controls.Add($script:listBoxDroitFormSite)
    $script:ListBoxAffichage.Controls.Add($FormLabelTextDefProfils1)
    $script:ListBoxAffichage.Controls.Add($script:ComboBoxProfil)

    # alimentation des champs pour le profil selectionne
    FillProfilPlateforme
    # rustine d�gueu en attendant de comprendre
    FillProfilPlateforme
}

Function FillProfilUtilisateur {
    #afficher les droits de cr�ation et r�initialisation de compte en lien avec le profil et en fonction du nombre de plateformes

    # creation de la datatable
    $table = New-Object system.Data.DataTable
		
    # definition des colonnes
    $colId = New-Object system.Data.DataColumn "id",([string])
    $colProfil = New-Object system.Data.DataColumn "nom",([string])
 
    # table des colonnes � la datatable
    $table.Columns.Add($colId)
    $table.Columns.Add($colProfil)

    # alimentation de la datatable avec les plateformes
    $reqSel = "select pu.id, p.nom , pu.accord from ass_profil_utilisateur pu"
    $reqSel += " join profil p on p.id = pu.profil where pu.utilisateur = " + $script:ComboBoxUtilisateur.SelectedItem.id + " order by pu.profil;"

    $listProfils = MakeRequest $reqSel
    foreach($listProfil in $listProfils) {
        $ligne = $table.NewRow()
        $ligne.id = $listProfil.id
        $ligne.nom = $listProfil.nom
        $table.Rows.Add($ligne)
    }

    $script:listBoxProfils.DisplayMember = "nom"
    $script:listBoxProfils.ValueMember = "id"
    $script:listBoxProfils.DataSource = $table    

    # on d�sactive la gestion de la sauvegarde quand on coche les cases
    $script:saveEnabled = $false
    # on coche les cases en fonction des donn�es en base
    for($i=0;$i -lt $script:listBoxProfils.Items.Count; $i++) {
        $dp = RetreiveRow $listProfils "id" $script:listBoxProfils.Items[$i].id
        $script:listBoxProfils.SetItemChecked($i, $dp.accord)
    }

    # on r�active la gestion de la sauvegarde quand on coche les cases
    $script:saveEnabled = $true
}

Function ModifyProfilUtilisateur {
    if($script:saveEnabled) {
        # la case n'est pas encore d�coch�e quand l'�v�nement est d�clench�, d'o� le -not
        $accord = -not $script:listBoxProfils.GetItemChecked($script:listBoxProfils.SelectedIndex)
        $reqUpdate = "update ass_profil_utilisateur set accord = " + $accord
        $reqUpdate += " where id = " + $script:listBoxProfils.SelectedItem.id
        MakeRequest $reqUpdate
    }
}

Function MakeMenuAssProfils {
    #afficher tous les comptes pour un profil s�lectionn� + checkbox pour s�lectionner les users (en fonction du nombre de users dans la base
    $script:ComboBoxUtilisateur.Location = New-Object System.Drawing.Point(10,10)
    $script:ComboBoxUtilisateur.Size = New-Object System.Drawing.Size(200,20)
    $script:ComboBoxUtilisateur.add_SelectedIndexChanged({FillProfilUtilisateur})
    FillComboBox $script:ComboBoxUtilisateur $utilisateurs "login"

    $script:ListBoxAffichage.Controls.clear();
    $script:ListBoxAffichage.Controls.Add($script:ComboBoxUtilisateur)
    $script:ListBoxAffichage.Controls.Add($script:listBoxProfils)

    # alimentation des champs pour le profil selectionne
    FillProfilUtilisateur
    FillProfilUtilisateur
}

Function MakeForm {
    $listForm = New-Object System.Windows.Forms.Form
    $listForm.Text = "Param�trage"
    $listForm.Size = New-Object System.Drawing.Size(1000,700)
    $listForm.StartPosition = "CenterScreen"

    $script:ListBoxAffichage.Location = New-Object System.Drawing.Size(255,30)
    $script:ListBoxAffichage.Size = New-Object System.Drawing.Size(700,530)

    $ButtonADAdmin = New-Object System.Windows.Forms.Button
    $ButtonADAdmin.Location = New-Object System.Drawing.Point(40,40)
    $ButtonADAdmin.Size = New-Object System.Drawing.Size(200,50)
    $ButtonADAdmin.Text = "Active Directory administratif"
    $ButtonADAdmin.Add_Click({MakeMenuAd})
    
    $ButtonPlateformes = New-Object System.Windows.Forms.Button
    $ButtonPlateformes.Location = New-Object System.Drawing.Point(40,100)
    $ButtonPlateformes.Size = New-Object System.Drawing.Size(200,50)
    $ButtonPlateformes.Text = "Plateformes"
    $ButtonPlateformes.Add_Click({MakeMenuPlateformes})

    $ButtonDefProfils = New-Object System.Windows.Forms.Button
    $ButtonDefProfils.Location = New-Object System.Drawing.Point(40,160)
    $ButtonDefProfils.Size = New-Object System.Drawing.Size(200,50)
    $ButtonDefProfils.Text = "D�fnition des profils"
    $ButtonDefProfils.Add_Click({makeMenuDefProfils})

    $ButtonAssProfils = New-Object System.Windows.Forms.Button
    $ButtonAssProfils.Location = New-Object System.Drawing.Point(40,220)
    $ButtonAssProfils.Size = New-Object System.Drawing.Size(200,50)
    $ButtonAssProfils.Text = "Assignation des profils"
    $ButtonAssProfils.Add_Click({makeMenuAssProfils})

    $ButtonRetour = New-Object System.Windows.Forms.Button
    $ButtonRetour.Location = New-Object System.Drawing.Point(30,580)
    $ButtonRetour.Size = New-Object System.Drawing.Size(150,60)
    $ButtonRetour.Text = "Retour"
    $ButtonRetour.Add_Click({$listForm.Close()})
    # la touche echap est mapp�e sur retour
    $listForm.CancelButton = $ButtonRetour

    $ListBoxMenu = New-Object System.Windows.Forms.ListBox 
    $ListBoxMenu.Location = New-Object System.Drawing.Size(30,30) 
    $ListBoxMenu.Size = New-Object System.Drawing.Size(220,530) 
    
    $listForm.Controls.Add($ButtonADAdmin) 
    $listForm.Controls.Add($ButtonPlateformes)
    $listForm.Controls.Add($ButtonDefProfils)
    $listForm.Controls.Add($ButtonAssProfils)
    $listForm.Controls.Add($ButtonRetour)
    $listForm.Controls.Add($ListBoxMenu)
    $listForm.Controls.Add($script:ListBoxAffichage)

    # Afficher la fenetre
    $listForm.ShowDialog()
}