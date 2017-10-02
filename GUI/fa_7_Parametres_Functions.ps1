Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing


$parametres = @{
    "nom_domaine_ENI_Groupe" = "Nom domaine ENI Group";
    "login_domaine_ENI_Group" = "Login domaine ENI Group";
    "password_domaine_ENI_Group" = "Mot de passe domaine ENI Group";
    "smtp_ip" = "IP SMTP";
    "smtp_port" = "Port SMTP";
    "smtp_expediteur" = "Expediteur SMTP"
}

$ListBoxAffichage = New-Object System.Windows.Forms.ListBox

$dataGridParametres = New-Object System.Windows.Forms.DataGridView
        
$ComboBoxPlateformes = New-Object System.Windows.Forms.ComboBox
$textBoxNom = New-Object System.Windows.Forms.TextBox
$textBoxURL = New-Object System.Windows.Forms.TextBox
$textBoxDomaine = New-Object System.Windows.Forms.TextBox
$textBoxMail = New-Object System.Windows.Forms.TextBox
$textBoxUser = New-Object System.Windows.Forms.TextBox
$textBoxMdp = New-Object System.Windows.Forms.TextBox
$textBoxRegexMdp = New-Object System.Windows.Forms.TextBox
$checkBoxObligatoire = New-Object System.Windows.Forms.CheckBox

$ComboBoxProfil = New-Object System.Windows.Forms.ComboBox
$textBoxProfil = New-Object System.Windows.Forms.TextBox

$buttonAjouterPlateforme = New-Object System.Windows.Forms.Button
$clickAddPlateformeAdded = $false
$buttonEnregistrerPlateforme = New-Object System.Windows.Forms.Button
$clickModifyPlateformeAdded = $false
$buttonSupprimerPlateforme = New-Object System.Windows.Forms.Button
$clickDeletePlateformeAdded = $false

$buttonAjouterProfil = New-Object System.Windows.Forms.Button
$clickAddProfilAdded = $false
$buttonEnregistrerProfil = New-Object System.Windows.Forms.Button
$clickModifyProfilAdded = $false
$buttonSupprimerProfil = New-Object System.Windows.Forms.Button
$clickDeleteProfilAdded = $false

$buttonAjouterUtilisateur = New-Object System.Windows.Forms.Button
$clickAddUtilisateurAdded = $false
$buttonEnregistrerUtilisateur = New-Object System.Windows.Forms.Button
$clickModifyUtilisateurAdded = $false
$buttonSupprimerUtilisateur = New-Object System.Windows.Forms.Button
$clickDeleteUtilisateurAdded = $false

$ComboBoxUtilisateur = New-Object System.Windows.Forms.ComboBox
$textBoxUtilisateur = New-Object System.Windows.Forms.TextBox

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

Function ModifyParametres {
    # on parcourt les parametres pour les enregistrer
    for($i = 0;$i -lt $script:dataGridParametres.RowCount;$i++) {
        $cle = $script:dataGridParametres.Rows[$i].Cells[0].Value
        $valeur = $script:dataGridParametres.Rows[$i].Cells[2].Value

        $reqSel = "select id from parametres where nom = '" + $cle + "'"
        $param = MakeRequest $reqSel
        if($param.id -ne $null) {
            # le paramètre existe déjà, on le met à jour
            $reqUpdate = "update parametres set param = '" + $valeur + "'"
            $reqUpdate += " where id = " + $param.id
            MakeRequest $reqUpdate
        } else {
            # le paramètre n'existe pas, on l'ajoute
            $reqInsert = "insert into parametres(nom,param)"
            $reqInsert += " values('" + $cle + "','" + $valeur + "')"
            MakeRequest $reqInsert
        }
    }
}

Function MakeMenuParametres {
    $labelTitreParametres = New-Object System.Windows.Forms.Label
    $labelTitreParametres.Location = New-Object System.Drawing.Point(10,10)
    $labelTitreParametres.Size = New-Object System.Drawing.Size(200,20)
    $labelTitreParametres.Text = "Paramètres"

    $script:dataGridParametres.Location = New-Object System.Drawing.Point(10,50)
    $script:dataGridParametres.Size = New-Object System.Drawing.Size(655,450)
    $script:dataGridParametres.BackgroundColor = [System.Drawing.Color]::GhostWhite
    $script:dataGridParametres.AllowUserToAddRows = $false
    $script:dataGridParametres.AllowUserToDeleteRows = $false
    $script:dataGridParametres.MultiSelect = $false
    $script:dataGridParametres.RowHeadersVisible = $false
    $script:dataGridParametres.Rows.Clear()
    $script:dataGridParametres.Columns.Clear()

    # on ajoute une repmière colonne qui ne sera pas affichée
    $colCle = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
    $colCle.Name = "Cle"
    $colCle.Visible = $false
    $script:dataGridParametres.Columns.Add($colCle)

    # on ajoute la colonne nom en lecture seule
    $colNom = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
    $colNom.Width = 300
    $colNom.Name = "Nom"
    $colNom.ReadOnly = $true
    $script:dataGridParametres.Columns.Add($colNom)

    # on ajoute la colonne valeur
    $colValeur = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
    $colValeur.Width = 350
    $colValeur.Name = "Valeur"
    $script:dataGridParametres.Columns.Add($colValeur)

    # on alimente la table
    foreach($key in $parametres.Keys) {
        $reqSel = "select * from parametres where nom = '" + $key + "'"
        $param = MakeRequest $reqSel
        $script:dataGridParametres.Rows.Add($key, $parametres[$key], $param.param)
    }

    $buttonEnregistrerParam = New-Object System.Windows.Forms.Button
    $buttonEnregistrerParam.Location = New-Object System.Drawing.Point(220,10)
    $buttonEnregistrerParam.Size = New-Object System.Drawing.Size(70,22)
    $buttonEnregistrerParam.Text = "Enregistrer"
    $buttonEnregistrerParam.Add_Click({ModifyParametres})

    $script:listBoxAffichage.Controls.clear();
    $script:listBoxAffichage.Controls.Add($labelTitreParametres)
    $script:listBoxAffichage.Controls.Add($dataGridParametres)
    $script:listBoxAffichage.Controls.Add($buttonEnregistrerParam)
}

Function FillPlateforme {
    if($script:ComboBoxPlateformes.SelectedIndex -ne -1) {
        $plateforme = RetreiveRow $script:plateformes "id" $script:ComboBoxPlateformes.SelectedItem.id
        $script:textBoxDomaine.Text = $plateforme.domaine
        $script:textBoxURL.Text = $plateforme.URL
        $script:textBoxMail.Text = $plateforme.mail
        $script:textBoxUser.Text = $plateforme.identifiant
        $script:textBoxMdp.Text = $plateforme.MDP
        $script:textBoxRegexMdp.Text = $plateforme.regexMDP
        $script:checkBoxObligatoire.Checked = $plateforme.obligatoire
    }
}

Function AddPlateforme {
    if($script:buttonAjouterPlateforme.Text -eq "Ajouter") {
        # on passe en ajout, on modifie le texte du bouton ajouter pour permettre l'annulation
        $script:buttonAjouterPlateforme.Text = "Annuler"
        
        # on efface tous les champs
        $script:textBoxNom.Text = ""
        $script:textBoxDomaine.Text = ""
        $script:textBoxURL.Text = ""
        $script:textBoxMail.Text = ""
        $script:textBoxUser.Text = ""
        $script:textBoxMDP.Text = ""
        $script:textBoxRegexMdp.Text = ""
        $script:checkBoxObligatoire.Checked = $true

        # on cache le bouton supprimer
        $script:buttonSupprimerPlateforme.Visible = $false

         # on cache la combo-box et on affiche le champ
        $script:ComboBoxPlateformes.Visible = $false
        $script:textBoxNom.Visible = $true
    } else {
        # on annule l'ajout, on rétablit le texte du bouton ajouter
        $script:buttonAjouterPlateforme.Text = "Ajouter"
        
        # on vide le champ nom et on le cache, on affiche la combo-box
        $script:textBoxNom.Text = ""
        $script:textBoxNom.Visible = $false
        $script:ComboBoxPlateformes.Visible = $true

        # on affiche le bouton supprimer
        $script:buttonSupprimerPlateforme.Visible = $true

        # on recharge les infos
        $script:plateformes = MakeRequest "SELECT * FROM plateforme"
        FillComboBox $script:ComboBoxPlateformes $script:plateformes "nom"
    }
}

Function ModifyPlateforme {
    # on regarde si on est en ajout ou en modification
    if($script:textBoxNom.Visible) {
           # on est en ajout, on vérifie que le champ nom est renseigné
           if($script.textBoxNom.Text -ne "") {
           $reqInsert = "insert into plateforme(nom, "
            $reqValues = " values('" + $script:textBoxNom.Text + "',"
            if(-not [string]::IsNullOrEmpty($script:textBoxDomaine.Text)) {
                $reqInsert += "domaine,"
                $reqValues += "'" + $script:textBoxDomaine.Text + "',"
            }
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

            # last_insert_id() permet de récupérer le dernier auto_increment de la connexion courante
            # c'est donc valide même dans le cas de plusieurs clients en parallèle
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

            # on ajoute les droits pour les plateformes
            $reqInsertPlateformesFormations = "INSERT INTO ass_plateforme_formation(plateforme, formation, defaut)"
            $reqInsertPlateformesFormations += " select " + $idNewPlateforme.id + ", formation.ID, 0 from formation"
            MakeRequest $reqInsertPlateformesFormations

            # on cache le champ nom et on affiche la combo-box
            $script:textBoxNom.Visible = $false
            $script:ComboBoxPlateformes.Visible = $true

            # on affiche le bouton supprimer
            $script:buttonSupprimerPlateforme.Visible = $true

            # on rétablit le texte du bouton ajouter
            $script:buttonAjouterPlateforme.Text = "Ajouter"

            # on recharge les infos
            $script:plateformes = MakeRequest "SELECT * FROM plateforme"
            FillComboBox $script:ComboBoxPlateformes $script:plateformes "nom"

            # on sélectionne le dernier élément de la combo, c'est en principe le dernier ajouté
            $script:ComboBoxPlateformes.SelectedIndex = $script:ComboBoxPlateformes.Items.Count - 1
        }
    } else {
        # on est en modification
        $reqUpdate = "update plateforme set"
        $reqUpdate += " domaine='" + $script:textBoxDomaine.Text + "',"
        $reqUpdate += " URL='" + $script:textBoxURL.Text + "',"
        $reqUpdate += " mail='" + $script:textBoxMail.Text + "',"
        $reqUpdate += " identifiant='" + $script:textBoxUser.Text + "',"
        $reqUpdate += " MDP='" + $script:textBoxMdp.Text + "',"
        $reqUpdate += " RegexMDP='" + $script:textBoxRegexMdp.Text + "',"
        $reqUpdate += " obligatoire=" + $script:checkBoxObligatoire.Checked
        $reqUpdate += " where id=" + $script:ComboBoxPlateformes.SelectedItem.id
        MakeRequest $reqUpdate
    }
}

Function DeletePlateforme {
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

Function MakeMenuPlateformes {
    $script:ComboBoxPlateformes.Location = New-Object System.Drawing.Point(10,10)
    $script:ComboBoxPlateformes.Size = New-Object System.Drawing.Size(200,20)
    $script:ComboBoxPlateformes.add_SelectedIndexChanged({FillPlateforme})
    $script:ComboBoxPlateformes.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
    $script:ComboBoxPlateformes.Visible = $true
    FillComboBox $script:ComboBoxPlateformes $script:plateformes "nom"

    # le champ nom est caché par défaut, c'est la combo-box qui est visible
    $script:textBoxNom.Location = New-Object System.Drawing.Point(10,10)
    $script:textBoxNom.Size = New-Object System.Drawing.Size(200,20)
    $script:textBoxNom.Visible = $false

    $labelDomaine = New-Object System.Windows.Forms.Label
    $labelDomaine.Location = New-Object System.Drawing.Point(10,50)
    $labelDomaine.Size = New-Object System.Drawing.Size(200,20)
    $labelDomaine.Text = "Domaine"
    $labelDomaine.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes

    $script:textBoxDomaine.Location = New-Object System.Drawing.Point(220,50)
    $script:textBoxDomaine.Size = New-Object System.Drawing.Size(200,22)

    $labelURL = New-Object System.Windows.Forms.Label
    $labelURL.Location = New-Object System.Drawing.Point(10,90)
    $labelURL.Size = New-Object System.Drawing.Size(200,20)
    $labelURL.Text = "Adresse IP ou nom du serveur"
    $labelURL.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes

    $script:textBoxURL.Location = New-Object System.Drawing.Point(220,90)
    $script:textBoxURL.Size = New-Object System.Drawing.Size(200,22)

    $labelMail = New-Object System.Windows.Forms.Label
    $labelMail.Location = New-Object System.Drawing.Point(10,130)
    $labelMail.Size = New-Object System.Drawing.Size(200,20)
    $labelMail.Text = "Adresse mail destinataire"
    $labelMail.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes

    $script:textBoxMail.Location = New-Object System.Drawing.Point(220,130)
    $script:textBoxMail.Size = New-Object System.Drawing.Size(200,22)
    
    $labelUser = New-Object System.Windows.Forms.Label
    $labelUser.Location = New-Object System.Drawing.Point(10,170)
    $labelUser.Size = New-Object System.Drawing.Size(200,20)
    $labelUser.Text = "Nom d'utilisateur"
    $labelUser.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes

    $script:textBoxUser.Location = New-Object System.Drawing.Point(220,170)
    $script:textBoxUser.Size = New-Object System.Drawing.Size(200,22)

    $labelMdp = New-Object System.Windows.Forms.Label
    $labelMdp.Location = New-Object System.Drawing.Point(10,210)
    $labelMdp.Size = New-Object System.Drawing.Size(200,20)
    $labelMdp.Text = "Mot de passe"
    $labelMdp.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes

    $script:textBoxMdp.Location = New-Object System.Drawing.Point(220,210)
    $script:textBoxMdp.Size = New-Object System.Drawing.Size(200,22)
    $script:textBoxMdp.PasswordChar = '•'

    $labelRegexMdp = New-Object System.Windows.Forms.Label
    $labelRegexMdp.Location = New-Object System.Drawing.Point(10,250)
    $labelRegexMdp.Size = New-Object System.Drawing.Size(200,20)
    $labelRegexMdp.Text = "Regex de génération du mot de passe"
    $labelRegexMdp.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes

    $script:textBoxRegexMdp.Location = New-Object System.Drawing.Point(220,250)
    $script:textBoxRegexMdp.Size = New-Object System.Drawing.Size(200,22)
    
    $labelObligatoire = New-Object System.Windows.Forms.Label
    $labelObligatoire.Location = New-Object System.Drawing.Point(10,290)
    $labelObligatoire.Size = New-Object System.Drawing.Size(200,20)
    $labelObligatoire.Text = "Compte obligatoire"
    $labelObligatoire.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes

    $script:checkBoxObligatoire.Location = New-Object System.Drawing.Point(220,290)
    $script:checkBoxObligatoire.Size = New-Object System.Drawing.Size(200,22)
    
    $script:buttonAjouterPlateforme.Location = New-Object System.Drawing.Point(220,10)
    $script:buttonAjouterPlateforme.Size = New-Object System.Drawing.Size(70,22)
    $script:buttonAjouterPlateforme.Text = "Ajouter"
    if(-not $script:clickAddPlateformeAdded) {
        $script:clickAddPlateformeAdded = $true
        $script:buttonAjouterPlateforme.Add_Click({AddPlateforme})
    }
    $toolTipAjouter = New-Object System.Windows.Forms.ToolTip
    $toolTipAjouter.SetToolTip($script:buttonAjouterPlateforme, "Pour ajouter une plateforme, cliquer sur Ajouter, renseigner les différents champs puis cliquer sur Enregistrer")

    $script:buttonEnregistrerPlateforme.Location = New-Object System.Drawing.Point(295,10)
    $script:buttonEnregistrerPlateforme.Size = New-Object System.Drawing.Size(70,22)
    $script:buttonEnregistrerPlateforme.Text = "Enregistrer"
    if(-not $script:clickModifyPlateformeAdded) {
        $script:clickModifyPlateformeAdded = $true
        $script:buttonEnregistrerPlateforme.Add_Click({ModifyPlateforme})
    }

    $script:buttonSupprimerPlateforme.Location = New-Object System.Drawing.Point(370,10)
    $script:buttonSupprimerPlateforme.Size = New-Object System.Drawing.Size(70,22)
    $script:buttonSupprimerPlateforme.Text = "Supprimer"
    $script:buttonSupprimerPlateforme.Visible = $true
    if(-not $script:clickDeletePlateformeAdded) {
        $script:clickDeletePlateformeAdded = $true
        $script:buttonSupprimerPlateforme.Add_Click({DeletePlateforme})
    }

    $script:ListBoxAffichage.Controls.clear();
    $script:ListBoxAffichage.Controls.Add($script:ComboBoxPlateformes)
    $script:ListBoxAffichage.Controls.Add($script:textBoxNom)
    $script:ListBoxAffichage.Controls.Add($labelDomaine)
    $script:ListBoxAffichage.Controls.Add($script:textBoxDomaine)
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
    $script:ListBoxAffichage.Controls.Add($script:buttonAjouterPlateforme)
    $script:ListBoxAffichage.Controls.Add($script:buttonEnregistrerPlateforme)
    $script:ListBoxAffichage.Controls.Add($script:buttonSupprimerPlateforme)
    
    # alimentation des champs pour la plateforme selectionnee
    FillPlateforme
}

Function FillProfilFormSite {
    #afficher les droits de création et réinitialisation de compte en lien avec le profil et en fonction du nombre de plateformes

    # creation de la datatable
    $table = New-Object system.Data.DataTable
		
    # definition des colonnes
    $colId = New-Object system.Data.DataColumn "id",([int])
    $colDroit = New-Object system.Data.DataColumn "nom",([string])
 
    # table des colonnes à la datatable
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

    # on désactive la gestion de la sauvegarde quand on coche les cases
    $script:saveEnabled = $false
    # on coche les cases en fonction des données en base
    for($i=0;$i -lt $script:listBoxDroitFormSite.Items.Count; $i++) {
        $dp = RetreiveRow $DroitsFormsSites "id" $script:listBoxDroitFormSite.Items[$i].id
        $script:listBoxDroitFormSite.SetItemChecked($i, $dp.accord)
    }
    # on réactive la gestion de la sauvegarde quand on coche les cases
    $script:saveEnabled = $true
}

Function FillProfilPlateforme {
    if($script:ComboBoxProfil.SelectedIndex -ne -1) {
        #afficher les droits de création et réinitialisation de compte en lien avec le profil et en fonction du nombre de plateformes

        # creation de la datatable
        $table = New-Object system.Data.DataTable
		
        # definition des colonnes
        $colId = New-Object system.Data.DataColumn "id",([int])
        $colDroit = New-Object system.Data.DataColumn "droit",([string])
 
        # table des colonnes à la datatable
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

        # on désactive la gestion de la sauvegarde quand on coche les cases
        $script:saveEnabled = $false
        # on coche les cases en fonction des données en base
        for($i=0;$i -lt $script:listBoxDroitPlateforme.Items.Count; $i++) {
            $dp = RetreiveRow $DroitsPlateformes "id" $script:listBoxDroitPlateforme.Items[$i].id
            $script:listBoxDroitPlateforme.SetItemChecked($i, $dp.accord)
        }
        # on réactive la gestion de la sauvegarde quand on coche les cases
        $script:saveEnabled = $true
        FillProfilFormSite
    }
}

Function ModifyProfilDroitsPlateforme {
    if($script:saveEnabled) {
        # la case n'est pas encore décochée quand l'événement est déclenché, d'où le -not
        $accord = -not $script:listBoxDroitPlateforme.GetItemChecked($script:listBoxDroitPlateforme.SelectedIndex)
        $reqUpdate = "update ass_profil_droit_plateforme set accord = " + $accord
        $reqUpdate += " where id = " + $script:listBoxDroitPlateforme.SelectedItem.id
        MakeRequest $reqUpdate
    }
}

Function ModifyProfilDroitsFormSite {
    if($script:saveEnabled) {
        # la case n'est pas encore décochée quand l'événement est déclenché, d'où le -not
        $accord = -not $script:listBoxDroitFormSite.GetItemChecked($script:listBoxDroitFormSite.SelectedIndex)
        $reqUpdate = "update ass_profil_droits_utilisateurs set accord = " + $accord
        $reqUpdate += " where id = " + $script:listBoxDroitFormSite.SelectedItem.id
        MakeRequest $reqUpdate
    }
}

Function AddProfil {
    if($script:buttonAjouterProfil.Text -eq "Ajouter") {
        # on passe en ajout, on modifie le texte du bouton ajouter pour permettre l'annulation
        $script:buttonAjouterProfil.Text = "Annuler"

        # on cache la combo-box et on affiche le champ à vide
        $script:textBoxProfil.Text = ""
        $script:ComboBoxProfil.Visible = $false
        $script:textBoxProfil.Visible = $true
        
        # on cache le button supprimer et on affiche le button Enregistrer
        $script:buttonSupprimerProfil.Visible = $false
        $script:buttonEnregistrerProfil.Visible = $true
    } else {
        # on annule l'ajout, on rétablit le texte du bouton ajouter
        $script:buttonAjouterProfil.Text = "Ajouter"

        # on affiche la combo-box, on vide le champ profil et on le cache
        $script:textBoxProfil.Text = ""
        $script:ComboBoxProfil.Visible = $true
        $script:textBoxProfil.Visible = $false

        # on cache le bouton enregistrer et on affiche le bouton supprimer
        $script:buttonSupprimerProfil.Visible = $true
        $script:buttonEnregistrerProfil.Visible = $false
        
        # on recharge les infos
        $script:profils = MakeRequest "SELECT * FROM profil"
        FillComboBox $script:ComboBoxProfil $script:profils "nom"
    }
}

Function ModifyProfil {
    if($script:textBoxProfil.Text -ne "") {
        # on crée le nouveau profil
        $reqInsertProfil = "insert into profil(nom) values('" + $script:textBoxProfil.Text + "')"
        MakeRequest $reqInsertProfil
        $reqSelect = "select last_insert_id() as id"
        # last_insert_id() permet de récupérer le dernier auto_increment de la connexion courante
        # c'est donc valide même dans le cas de plusieurs clients en parallèle
        $idNewProfil = MakeRequest $reqSelect
        
        # on crée les droits plateformes avec accord à 0
        $reqInsertDroitsPlateformes = "insert into ass_profil_droit_plateforme(profil,droit_plateforme,accord)"
        $reqInsertDroitsPlateformes += " select " + $idNewProfil.id + ", ass_droit_plateforme.ID, 0 from ass_droit_plateforme"
        MakeRequest $reqInsertDroitsPlateformes

        # on crée les droits formation et site avec accord à 0
        $reqInsertDroitsFormSite = "insert into ass_profil_droits_utilisateurs(droit,profil,accord)"
        $reqInsertDroitsFormSite += " select droits_utilisateur.ID, " + $idNewProfil.id + ", 0 from droits_utilisateur"
        MakeRequest $reqInsertDroitsFormSite

        # on affiche la combo-box, on vide le champ profil et on le cache
        $script:textBoxProfil.Text = ""
        $script:ComboBoxProfil.Visible = $true
        $script:textBoxProfil.Visible = $false

        # on cache le bouton Enregistrer et on affiche le bouton supprimer
        $script:buttonSupprimerProfil.Visible = $true
        $script:buttonEnregistrerProfil.Visible = $false

        
        # on rétablit le texte du bouton ajouter
        $script:buttonAjouterProfil.Text = "Ajouter"

        # on recharge les infos
        $script:profils = MakeRequest "SELECT * FROM profil"
        FillComboBox $script:ComboBoxProfil $script:profils "nom"

        # on sélectionne le dernier élément de la combo, c'est en principe le dernier ajouté
        $script:ComboBoxProfil.SelectedIndex = $script:ComboBoxProfil.Items.Count - 1
    }
}

Function DeleteProfil {
    # on supprime d'abord les droits plateformes
    $reqDeleteDroitsPlateformes = "delete from ass_profil_droit_plateforme where profil="
    $reqDeleteDroitsPlateformes += $script:ComboBoxProfil.SelectedItem.id
    MakeRequest $reqDeleteDroitsPlateformes

    # on supprime d'abord les droits formation et site
    $reqDeleteDroitsPlateformes = "delete from ass_profil_droits_utilisateurs where profil="
    $reqDeleteDroitsPlateformes += $script:ComboBoxProfil.SelectedItem.id
    MakeRequest $reqDeleteDroitsPlateformes
        
    # puis le profil en lui-même
    $reqDeleteProfil = "delete from profil where id="
    $reqDeleteProfil += $script:ComboBoxProfil.SelectedItem.id
    MakeRequest $reqDeleteProfil

    # on recharge les infos
    $script:profils = MakeRequest "SELECT * FROM profil"
    FillComboBox $script:ComboBoxProfil $script:profils "nom"
}

Function MakeMenuDefProfils {
    $script:ComboBoxProfil.Location = New-Object System.Drawing.Point(10,10)
    $script:ComboBoxProfil.Size = New-Object System.Drawing.Size(200,20)
    $script:ComboBoxProfil.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
    $script:ComboBoxProfil.Visible = $true
    $script:ComboBoxProfil.add_SelectedIndexChanged({FillProfilPlateforme})
    FillComboBox $script:ComboBoxProfil $profils "nom"
    
    $script:textBoxProfil.Location = New-Object System.Drawing.Point(10,10)
    $script:textBoxProfil.Size = New-Object System.Drawing.Size(200,20)
    $script:textBoxProfil.Visible = $false

    $script:buttonAjouterProfil.Location = New-Object System.Drawing.Point(220,10)
    $script:buttonAjouterProfil.Size = New-Object System.Drawing.Size(70,22)
    $script:buttonAjouterProfil.Text = "Ajouter"
    if(-not $script:clickAddProfilAdded) {
        $script:clickAddProfilAdded = $true
        $script:buttonAjouterProfil.Add_Click({AddProfil})
    }
    $toolTipAjouter = New-Object System.Windows.Forms.ToolTip
    $toolTipAjouter.SetToolTip($script:buttonAjouterProfil, "Pour ajouter un profil, cliquer sur Ajouter, renseigner le nom, puis cliquer sur Enregistrer")

    $script:buttonEnregistrerProfil.Location = New-Object System.Drawing.Point(295,10)
    $script:buttonEnregistrerProfil.Size = New-Object System.Drawing.Size(70,22)
    $script:buttonEnregistrerProfil.Text = "Enregistrer"
    $script:buttonEnregistrerProfil.Visible = $false
    if(-not $script:clickModifyProfilAdded) {
        $script:clickModifyProfilAdded = $true
        $script:buttonEnregistrerProfil.Add_Click({ModifyProfil})
    }

    $script:buttonSupprimerProfil.Location = New-Object System.Drawing.Point(295,10)
    $script:buttonSupprimerProfil.Size = New-Object System.Drawing.Size(70,22)
    $script:buttonSupprimerProfil.Text = "Supprimer"
    $script:buttonSupprimerProfil.Visible = $true
    if(-not $script:clickDeleteProfilAdded) {
        $script:clickDeleteProfilAdded = $true
        $script:buttonSupprimerProfil.Add_Click({DeleteProfil})
    }

    $labelcreation = New-Object System.Windows.Forms.Label
    $labelcreation.Location = New-Object System.Drawing.Point(10,50)
    $labelcreation.Size = New-Object System.Drawing.Size(200,20)
    $labelcreation.Text = "Création de comptes"
    $labelcreation.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes

    $labelFormSite = New-Object System.Windows.Forms.Label
    $labelFormSite.Location = New-Object System.Drawing.Point(400,50)
    $labelFormSite.Size = New-Object System.Drawing.Size(200,20)
    $labelFormSite.Text = "droits formations et sites"
    $labelFormSite.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes

    $script:ListBoxAffichage.Controls.clear();
    $script:ListBoxAffichage.Controls.Add($script:ComboBoxProfil)
    $script:ListBoxAffichage.Controls.Add($script:textBoxProfil)
    $script:ListBoxAffichage.Controls.Add($labelCreation)
    $script:ListBoxAffichage.Controls.Add($labelFormSite)
    $script:ListBoxAffichage.Controls.Add($script:listBoxDroitPlateforme)
    $script:ListBoxAffichage.Controls.Add($script:listBoxDroitFormSite)
    $script:ListBoxAffichage.Controls.Add($FormLabelTextDefProfils1)
    $script:ListBoxAffichage.Controls.Add($script:buttonAjouterProfil)
    $script:ListBoxAffichage.Controls.Add($script:buttonEnregistrerProfil)
    $script:ListBoxAffichage.Controls.Add($script:buttonSupprimerProfil)
    
    # alimentation des champs pour le profil selectionne
    FillProfilPlateforme
    # rustine dégueu en attendant de comprendre
    FillProfilPlateforme
}

Function FillProfilUtilisateur {
    if($script:ComboBoxUtilisateur.SelectedIndex -ne -1) {
        #afficher les droits de création et réinitialisation de compte en lien avec le profil et en fonction du nombre de plateformes

        # creation de la datatable
        $table = New-Object system.Data.DataTable
		
        # definition des colonnes
        $colId = New-Object system.Data.DataColumn "id",([int])
        $colProfil = New-Object system.Data.DataColumn "nom",([string])
 
        # table des colonnes à la datatable
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

        # on désactive la gestion de la sauvegarde quand on coche les cases
        $script:saveEnabled = $false
        # on coche les cases en fonction des données en base
        for($i=0;$i -lt $script:listBoxProfils.Items.Count; $i++) {
            $dp = RetreiveRow $listProfils "id" $script:listBoxProfils.Items[$i].id
            $script:listBoxProfils.SetItemChecked($i, $dp.accord)
        }

        # on réactive la gestion de la sauvegarde quand on coche les cases
        $script:saveEnabled = $true
    }
}

Function ModifyProfilUtilisateur {
    if($script:saveEnabled) {
        # la case n'est pas encore décochée quand l'événement est déclenché, d'où le -not
        $accord = -not $script:listBoxProfils.GetItemChecked($script:listBoxProfils.SelectedIndex)
        $reqUpdate = "update ass_profil_utilisateur set accord = " + $accord
        $reqUpdate += " where id = " + $script:listBoxProfils.SelectedItem.id
        MakeRequest $reqUpdate
    }
}

Function MakeMenuAssProfils {
    #afficher tous les comptes pour un profil sélectionné + checkbox pour sélectionner les users (en fonction du nombre de users dans la base
    $script:ComboBoxUtilisateur.Location = New-Object System.Drawing.Point(10,10)
    $script:ComboBoxUtilisateur.Size = New-Object System.Drawing.Size(200,20)
    $script:ComboBoxUtilisateur.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
    $script:ComboBoxUtilisateur.add_SelectedIndexChanged({FillProfilUtilisateur})
    FillComboBox $script:ComboBoxUtilisateur $utilisateurs "login"

    $script:textBoxUtilisateur.Location = New-Object System.Drawing.Point(10,10)
    $script:textBoxUtilisateur.Size = New-Object System.Drawing.Size(200,20)
    $script:textBoxUtilisateur.Visible = $false

    $script:buttonAjouterUtilisateur.Location = New-Object System.Drawing.Point(220,10)
    $script:buttonAjouterUtilisateur.Size = New-Object System.Drawing.Size(70,22)
    $script:buttonAjouterUtilisateur.Text = "Ajouter"
    if(-not $script:clickAddUtilisateurAdded) {
        $script:clickAddUtilisateurAdded = $true
        $script:buttonAjouterUtilisateur.Add_Click({AddUtilisateur})
    }
    $toolTipAjouter = New-Object System.Windows.Forms.ToolTip
    $toolTipAjouter.SetToolTip($script:buttonAjouterUtilisateur, "Pour ajouter un utilisateur, cliquer sur Ajouter, renseigner le login, puis cliquer sur Enregistrer")

    $script:buttonEnregistrerUtilisateur.Location = New-Object System.Drawing.Point(295,10)
    $script:buttonEnregistrerUtilisateur.Size = New-Object System.Drawing.Size(70,22)
    $script:buttonEnregistrerUtilisateur.Text = "Enregistrer"
    $script:buttonEnregistrerUtilisateur.Visible = $false
    if(-not $script:clickModifyUtilisateurAdded) {
        $script:clickModifyUtilisateurAdded = $true
        $script:buttonEnregistrerUtilisateur.Add_Click({ModifyUtilisateur})
    }

    $script:buttonSupprimerUtilisateur.Location = New-Object System.Drawing.Point(295,10)
    $script:buttonSupprimerUtilisateur.Size = New-Object System.Drawing.Size(70,22)
    $script:buttonSupprimerUtilisateur.Text = "Supprimer"
    $script:buttonSupprimerUtilisateur.Visible = $true
    if(-not $script:clickDeleteUtilisateurAdded) {
        $script:clickDeleteUtilisateurAdded = $true
        $script:buttonSupprimerUtilisateur.Add_Click({DeleteUtilisateur})
    }

    $script:ListBoxAffichage.Controls.clear();
    $script:ListBoxAffichage.Controls.Add($script:ComboBoxUtilisateur)
    $script:ListBoxAffichage.Controls.Add($script:listBoxProfils)
    $script:ListBoxAffichage.Controls.Add($script:textBoxUtilisateur)
    $script:ListBoxAffichage.Controls.Add($labelCreation)
    $script:ListBoxAffichage.Controls.Add($script:buttonAjouterUtilisateur)
    $script:ListBoxAffichage.Controls.Add($script:buttonEnregistrerUtilisateur)
    $script:ListBoxAffichage.Controls.Add($script:buttonSupprimerUtilisateur)

    # alimentation des champs pour le profil selectionne
    FillProfilUtilisateur
    FillProfilUtilisateur
}

Function AddUtilisateur {
    if($script:buttonAjouterUtilisateur.Text -eq "Ajouter") {
        # on passe en ajout, on modifie le texte du bouton ajouter pour permettre l'annulation
        $script:buttonAjouterUtilisateur.Text = "Annuler"

        # on cache la combo-box et on affiche le champ à vide
        $script:textBoxUtilisateur.Text = ""
        $script:ComboBoxUtilisateur.Visible = $false
        $script:textBoxUtilisateur.Visible = $true
        
        # on cache le button supprimer et on affiche le button Enregistrer
        $script:buttonSupprimerUtilisateur.Visible = $false
        $script:buttonEnregistrerUtilisateur.Visible = $true
    } else {
        # on annule l'ajout, on rétablit le texte du bouton ajouter
        $script:buttonAjouterUtilisateur.Text = "Ajouter"

        # on affiche la combo-box, on vide le champ profil et on le cache
        $script:textBoxUtilisateur.Text = ""
        $script:ComboBoxUtilisateur.Visible = $true
        $script:textBoxUtilisateur.Visible = $false

        # on cache le bouton enregistrer et on affiche le bouton supprimer
        $script:buttonSupprimerUtilisateur.Visible = $true
        $script:buttonEnregistrerUtilisateur.Visible = $false
        
        # on recharge les infos
        $script:utilisateurs = MakeRequest "SELECT * FROM utilisateur"
        FillComboBox $script:ComboBoxUtilisateur $script:utilisateurs "login"
    }
}

Function DeleteUtilisateur {
    # on supprime d'abord les droits plateformes
    $reqDeleteProfilUtilisateur = "delete from ass_profil_utilisateur where utilisateur="
    $reqDeleteProfilUtilisateur += $script:ComboBoxUtilisateur.SelectedItem.id
    MakeRequest $reqDeleteProfilUtilisateur
        
    # puis le profil en lui-même
    $reqDeleteUtilisateur = "delete from utilisateur where id="
    $reqDeleteUtilisateur += $script:ComboBoxUtilisateur.SelectedItem.id
    MakeRequest $reqDeleteUtilisateur

    # on recharge les infos
    $script:utilisateurs = MakeRequest "SELECT * FROM utilisateur"
    FillComboBox $script:ComboBoxUtilisateur $script:utilisateurs "login"
}

Function ModifyUtilisateur {
    if($script:textBoxUtilisateur.Text -ne "") {
        # on crée le nouveau profil
        $reqInsertUtilisateur = "insert into utilisateur(login) values('" + $script:textBoxUtilisateur.Text + "')"
        MakeRequest $reqInsertUtilisateur
        $reqSelect = "select last_insert_id() as id"
        # last_insert_id() permet de récupérer le dernier auto_increment de la connexion courante
        # c'est donc valide même dans le cas de plusieurs clients en parallèle
        $idNewUtilisateur = MakeRequest $reqSelect
        
        # on crée les droits plateformes avec accord à 0
        $reqInsertProfilUtilisateur = "insert into ass_profil_utilisateur(profil,utilisateur,accord)"
        $reqInsertProfilUtilisateur += " select profil.ID, " + $idNewUtilisateur.id + ", 0 from profil"
        MakeRequest $reqInsertProfilUtilisateur

        # on affiche la combo-box, on vide le champ profil et on le cache
        $script:textBoxUtilisateur.Text = ""
        $script:ComboBoxUtilisateur.Visible = $true
        $script:textBoxUtilisateur.Visible = $false

        # on cache le bouton Enregistrer et on affiche le bouton supprimer
        $script:buttonSupprimerUtilisateur.Visible = $true
        $script:buttonEnregistrerUtilisateur.Visible = $false

        
        # on rétablit le texte du bouton ajouter
        $script:buttonAjouterUtilisateur.Text = "Ajouter"

        # on recharge les infos
        $script:utilisateurs = MakeRequest "SELECT * FROM utilisateur"
        FillComboBox $script:ComboBoxUtilisateur $script:utilisateurs "login"

        # on sélectionne le dernier élément de la combo, c'est en principe le dernier ajouté
        $script:ComboBoxUtilisateur.SelectedIndex = $script:ComboBoxUtilisateur.Items.Count - 1
    }
}

Function MakeForm {
    $listForm = New-Object System.Windows.Forms.Form
    $listForm.Text = "Paramétrage"
    $listForm.Size = New-Object System.Drawing.Size(1000,700)
    $listForm.StartPosition = "CenterScreen"

    $script:ListBoxAffichage.Location = New-Object System.Drawing.Size(255,30)
    $script:ListBoxAffichage.Size = New-Object System.Drawing.Size(700,530)

    $ButtonADAdmin = New-Object System.Windows.Forms.Button
    $ButtonADAdmin.Location = New-Object System.Drawing.Point(40,40)
    $ButtonADAdmin.Size = New-Object System.Drawing.Size(200,50)
    $ButtonADAdmin.Text = "Paramètres divers"
    $ButtonADAdmin.Add_Click({MakeMenuParametres})
    $toolTipButtonADAdmin = New-Object System.Windows.Forms.ToolTip
    $toolTipButtonADAdmin.SetToolTip($ButtonADAdmin, "Paramétrage de la connexion à l'annuaire Active Directory")
    
    $ButtonPlateformes = New-Object System.Windows.Forms.Button
    $ButtonPlateformes.Location = New-Object System.Drawing.Point(40,100)
    $ButtonPlateformes.Size = New-Object System.Drawing.Size(200,50)
    $ButtonPlateformes.Text = "Plateformes"
    $ButtonPlateformes.Add_Click({MakeMenuPlateformes})
    $toolTipButtonPlateformes = New-Object System.Windows.Forms.ToolTip
    $toolTipButtonPlateformes.SetToolTip($ButtonPlateformes, "Paramétrage et ajout des plateformes")

    $ButtonDefProfils = New-Object System.Windows.Forms.Button
    $ButtonDefProfils.Location = New-Object System.Drawing.Point(40,160)
    $ButtonDefProfils.Size = New-Object System.Drawing.Size(200,50)
    $ButtonDefProfils.Text = "profils"
    $ButtonDefProfils.Add_Click({MakeMenuDefProfils})
    $toolTipButtonDefProfils = New-Object System.Windows.Forms.ToolTip
    $toolTipButtonDefProfils.SetToolTip($ButtonDefProfils, "création des profils et assignation des droits")

    $ButtonAssProfils = New-Object System.Windows.Forms.Button
    $ButtonAssProfils.Location = New-Object System.Drawing.Point(40,220)
    $ButtonAssProfils.Size = New-Object System.Drawing.Size(200,50)
    $ButtonAssProfils.Text = "utilisateurs"
    $ButtonAssProfils.Add_Click({MakeMenuAssProfils})
    $toolTipButtonAssProfils = New-Object System.Windows.Forms.ToolTip
    $toolTipButtonAssProfils.SetToolTip($ButtonAssProfils, "création des comptes utilisateurs et assignation des profils")

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