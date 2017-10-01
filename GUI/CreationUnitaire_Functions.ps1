Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$labelData = New-Object System.Windows.Forms.Label
$labelFormation = New-Object System.Windows.Forms.Label
$comboBoxFormation = New-Object System.Windows.Forms.ComboBox
$indexChangedFormationAdded = $false
$labelSite = New-Object System.Windows.Forms.Label
$comboBoxSite = New-Object System.Windows.Forms.ComboBox
$indexChangedSiteAdded = $false
$buttonCreerCompte = New-Object System.Windows.Forms.Button

$buttonValider = New-Object System.Windows.Forms.Button
$TextBoxCodeStagiaire = New-Object System.Windows.Forms.TextBox
$TextBoxNom = New-Object System.Windows.Forms.TextBox
$TextBoxPrenom = New-Object System.Windows.Forms.TextBox
$datePickerNaissance = New-Object System.Windows.Forms.DateTimePicker
$datePickerDebutContrat = New-Object System.Windows.Forms.DateTimePicker
$datePickerFinContrat = New-Object System.Windows.Forms.DateTimePicker

$LabelCodeStagiaire = New-Object System.Windows.Forms.Label
$LabelNom = New-Object System.Windows.Forms.Label
$LabelPrenom = New-Object System.Windows.Forms.Label
$LabelDateNaissance = New-Object System.Windows.Forms.Label
$labelDebutContrat = New-Object System.Windows.Forms.Label
$labelFinContrat = New-Object System.Windows.Forms.Label

$labelCodeNonValide = New-Object System.Windows.Forms.Label
$labelNomNonValide = New-Object System.Windows.Forms.Label
$labelPrenomNonValide = New-Object System.Windows.Forms.Label
$labelDateNonValide = New-Object System.Windows.Forms.Label

$labelPlateformes = New-Object System.Windows.Forms.Label
$listBoxplateformes = New-Object System.Windows.Forms.checkedListBox

function FillComboBox([System.Windows.Forms.ComboBox] $comboBox, $elems, $nomCol) {
    # creation de la datatable
    $table = New-Object System.Data.DataTable
		
    # definition des colonnes
    $colId = New-Object System.Data.DataColumn "id",([int])
    $colLib = New-Object System.Data.DataColumn $nomCol,([string])
 
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

Function SelectPlateformes {
# mise en forme des variables
    $CodeStagiaire = $TextBoxCodeStagiaire.Text
    $NomSSCaratSpec = Remove-StringDiacritic $TextBoxNom.Text
    $PrenomSSCaratSpec = Remove-StringDiacritic $TextBoxPrenom.Text
    $Nom = $TextBoxNom.Text
    $Prenom = $TextBoxPrenom.Text
    $Naissance = $datePickerNaissance.Text
    $DebutFormation = $datePickerDebutContrat.Text
    $FinFormation = $datePickerFinContrat.Text
    $formation = $comboBoxFormation.Text
    $site = $comboBoxSite.Text
    $annee = get-date -Format yyyy
    $reqsel = "select domaine from plateforme where nom = 'Active Directory';"
    $domaine = makeRequest $reqsel
    $email = $($PrenomSSCaratSpec.ToLower() + "." + $NomSSCaratSpec.ToLower() + $annee + "@" + $domaine.domaine)

    # on ajoute les infos du stagiaire dans la base de données
    $reqinsert = "INSERT INTO projet_eni.stagiaire (nomStagiaire, prenomStagiaire, mailStagiaire, identifiantCrm)"
    $reqinsert += " VALUES('" + $Nom + "', '" + $Prenom + "', '" + $email + "', '" + $CodeStagiaire + "');"
    makeRequest $reqinsert
    #TODO : création du compte avec vérification préalable de l'existence

    # on vérifie l'existence du rép temporaire
    $tempExist = test-path ../temp
    if ($tempExist -eq $false)
    {
        mkdir ../temp
    }
    # on parcourt la liste des plateformes cochées
    $vide = $null
    foreach($item in $script:listBoxplateformes.CheckedItems) {
        $plateforme = $item.nom -replace  ' ','_'
        $scriptCreationPlateforme = "creation_" + $plateforme
        #$Password = . "..\ps\fg_3-0_GenerationMdpTemp_PS.ps1" $Prenom $Nom $Naissance $plateforme
        $password = GenerationMdpTemp
        &"$scriptCreationPlateforme"
    }
    # on parcourt a nouveau les plateformes cochées pour générer les envois de mails
    $vide = $true
    foreach($item in $script:listBoxplateformes.CheckedItems) {
        $plateforme = $item.nom -replace  ' ','_'
        $scriptCreationPlateforme = "creation_" + $plateforme
        #$Password = . "..\ps\fg_3-0_GenerationMdpTemp_PS.ps1" $Prenom $Nom $Naissance $plateforme
        &"$scriptCreationPlateforme"
    }
}

Function validerData {
    $erreur = 0
    $largeur = $script:labelCodeNonValide.Location.X
    $hauteur = $script:labelCodeNonValide.Location.Y

    # on cache les labels d'erreur
    $script:labelCodeNonValide.visible = $false
    $script:labelNomNonValide.visible = $false
    $script:labelPrenomNonValide.visible = $false
    $script:labelDateNonValide.visible = $false

    # on cache les éléments qui seront affichés après
    $script:labelSite.visible = $false
    $script:comboboxSite.Visible = $false
    $script:labelFormation.Visible = $false
    $script:comboBoxFormation.Visible = $false
    $script:labelPlateformes.Visible = $false
    $script:listBoxplateformes.Visible = $false
    $script:buttonCreerCompte.Visible = $false

    if ($TextBoxCodeStagiaire.TextLength -eq 0) {
        $script:labelCodeNonValide.Text = "Erreur : Le champ code est vide."
        $script:labelCodeNonValide.visible = $true
        $hauteur += 20
        $erreur++
    }
    if($TextBoxNom.TextLength -eq 0) {
        $script:labelNomNonValide.Location = New-Object System.Drawing.Point($largeur,$hauteur)
        $script:labelNomNonValide.Text = "Erreur : Un champ nom est vide."
        $script:labelNomNonValide.visible = $true
        $hauteur += 20
        $erreur++
    }
    if($script:TextBoxPrenom.TextLength -eq 0) {
        $script:labelPrenomNonValide.Location = New-Object System.Drawing.Point($largeur,$hauteur)
        $script:labelPrenomNonValide.Text = "Erreur : Un champ prénom est vide."
        $script:labelPrenomNonValide.visible = $true
        $hauteur += 20
        $erreur++
    }
    if($script:datePickerDebutContrat.Value -gt $script:datePickerFinContrat.Value) {
        $script:labelDateNonValide.Location = New-Object System.Drawing.Point($largeur,$hauteur)
        $script:labelDateNonValide.Text = "Erreur : la date de début de contrat est postérieure à la date de fin de contrat."
        $script:labelDateNonValide.Visible = $true
        $erreur++
    }
    
    if($erreur -eq 0) {
        # aucune erreur
        $script:labelSite.visible = $true
        FillComboBox $script:comboBoxSite $script:sites "nom"
        $script:comboboxSite.Visible = $true
        $script:comboBoxSite.SelectedIndex = -1
        if(-not $indexChangedSiteAdded) {
            $indexChangedSiteAdded = $true
            $script:comboBoxSite.add_SelectedIndexChanged({FillFormation})
        }
    }
}

Function FillFormation {
    if($script:comboBoxSite.Visible -and $script:comboBoxSite.SelectedIndex -ne -1) {
        # on récupère la liste des formations filtrées en fonction du site sélectionné
        $reqSel = "select f.* from formation f"
        $reqSel += " join ass_formation_site fs on fs.formation = f.id"
        $reqSel += " where fs.existe = 1"
        $reqSel += " and fs.site = " + $script:comboBoxSite.SelectedItem.id
        $script:formations = MakeRequest $reqSel

        # on affiche la sélection du site
        $script:labelFormation.Visible = $true
        FillComboBox $script:comboBoxFormation $script:formations "nom"
        $script:comboBoxFormation.Visible = $true
        $script:comboBoxFormation.SelectedIndex = -1
        if(-not $indexChangedFormationAdded) {
            $indexChangedFormationAdded = $true
            $script:comboBoxFormation.add_SelectedIndexChanged({
                $script:buttonCreerCompte.visible = $true
                $script:listBoxPlateformes.visible = $true
                $script:labelPlateformes.visible = $true
                FillPlateforme
                FillPlateforme
            })
        }
    }
}

Function FillPlateforme {
    if($script:ComboBoxFormation.Visible -and $script:ComboBoxFormation.SelectedIndex -ne -1) {
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
        $reqSel = "select distinct pf.id, p.nom, pf.defaut from ass_plateforme_formation pf"
        $reqSel += " join plateforme p on p.id = pf.plateforme"
        $reqSel += " join ass_droit_plateforme dp on dp.plateforme = p.ID"
        $reqSel += " join ass_profil_droit_plateforme pdp on pdp.droit_plateforme = dp.ID and pdp.accord = 1"
        $reqSel += " join profil pl on pdp.profil = pl.ID"
        $reqSel += " join ass_profil_utilisateur pu on pu.profil = pl.ID and pu.accord = 1"
        $reqSel += " join utilisateur u on pu.utilisateur = u.ID"
        $reqSel += " where u.login = '" + $ADusername + "'"
        $reqSel += " and pf.formation = " + $script:ComboBoxFormation.SelectedItem.id
        $reqSel += " order by pf.formation"

        $listPlateformes = MakeRequest $reqSel
        foreach($Plateforme in $listPlateformes) {
                $ligne = $table.NewRow()
                $ligne.id = $Plateforme.id
                $ligne.nom = $Plateforme.nom
                $table.Rows.Add($ligne)
        }

        $script:listBoxPlateformes.DisplayMember = "nom"
        $script:listBoxPlateformes.ValueMember = "id"
        $script:listBoxPlateformes.DataSource = $table    

        for($i=0;$i -lt $script:listBoxPlateformes.Items.Count; $i++) {
            $dp = RetreiveRow $listPlateformes "id" $script:listBoxPlateformes.Items[$i].id
            $script:listBoxPlateformes.SetItemChecked($i, $dp.defaut)
        }
    }
}

Function MakeForm {
    $listForm = New-Object System.Windows.Forms.Form
    $listForm.Text = "Création de comptes stagiaires"
    $listForm.Size = New-Object System.Drawing.Size(1000,700)
    $listForm.StartPosition = "CenterScreen"

    $placementHauteur = 20
    $placementLargeurLabel = 30
    $placementLargeurText = 140
    $placementLargeurDate = $placementLargeurText + 100

    $labelData.Location = New-Object System.Drawing.Point($placementLargeurLabel,$placementHauteur)
    $labelData.Size = New-Object System.Drawing.Size(300,22)
    $labelData.Text = "1. Entrez les informations concernant le stagiaire"
    $labelData.Visible = $true

    $placementHauteur = $placementHauteur + 40
    
    $script:labelCodeStagiaire.Location = New-Object System.Drawing.Point($placementLargeurLabel,$placementHauteur)
    $script:labelCodeStagiaire.Size = New-Object System.Drawing.Size(100,22)
    $script:labelCodeStagiaire.text = "Code stagiaire"
    $script:labelCodeStagiaire.Visible = $true

    $script:textBoxCodeStagiaire.Location = New-Object System.Drawing.Point($placementLargeurText,$placementHauteur)
    $script:textBoxCodeStagiaire.Size = New-Object System.Drawing.Size(200,20)
    $script:textBoxCodeStagiaire.Visible = $true
    
    $placementHauteur = $placementHauteur + 40
    
    $script:labelNom.Location = New-Object System.Drawing.Point($placementLargeurLabel,$placementHauteur)
    $script:labelNom.Size = New-Object System.Drawing.Size(100,22)
    $script:labelNom.text = "Nom"
    $script:labelNom.Visible = $true

    $script:textBoxNom.Location = New-Object System.Drawing.Point($placementLargeurText,$placementHauteur)
    $script:textBoxNom.Size = New-Object System.Drawing.Size(200,20)
    $script:textBoxNom.Visible = $true

    $placementHauteur = $placementHauteur + 40

    $script:labelPrenom.Location = New-Object System.Drawing.Point($placementLargeurLabel,$placementHauteur)
    $script:labelPrenom.Size = New-Object System.Drawing.Size(100,22)
    $script:labelPrenom.text = "Prénom"
    $script:labelPrenom.Visible = $true

    $script:textBoxPrenom.Location = New-Object System.Drawing.Point($placementLargeurText,$placementHauteur)
    $script:textBoxPrenom.Size = New-Object System.Drawing.Size(200,20)
    $script:textBoxPrenom.Visible = $true

    $placementHauteur = $placementHauteur + 40

    $script:labelDateNaissance.Location = New-Object System.Drawing.Point($placementLargeurLabel,$placementHauteur)
    $script:labelDateNaissance.Size = New-Object System.Drawing.Size(100,22)
    $script:labelDateNaissance.text = "Date de naissance"
    $script:labelDateNaissance.Visible = $true

    $script:datePickerNaissance.Location = New-Object System.Drawing.Point($placementLargeurDate,$placementHauteur)
    $script:datePickerNaissance.Size = New-Object System.Drawing.Size(100,20)
    $script:datePickerNaissance.Visible = $true
    $script:datePickerNaissance.Format = [System.Windows.Forms.DateTimePickerFormat]::Short

    $placementHauteur = $placementHauteur + 40

    $script:labelDebutContrat.Location = New-Object System.Drawing.Point($placementLargeurLabel,$placementHauteur)
    $script:labelDebutContrat.Size = New-Object System.Drawing.Size(100,22)
    $script:labelDebutContrat.text = "Début de contrat"
    $script:labelDebutContrat.Visible = $true

    $script:datePickerDebutContrat.Location = New-Object System.Drawing.Point($placementLargeurDate,$placementHauteur)
    $script:datePickerDebutContrat.Size = New-Object System.Drawing.Size(100,20)
    $script:datePickerDebutContrat.Visible = $true
    $script:datePickerDebutContrat.Format = [System.Windows.Forms.DateTimePickerFormat]::Short

    $placementHauteur = $placementHauteur + 40

    $script:labelFinContrat.Location = New-Object System.Drawing.Point($placementLargeurLabel,$placementHauteur)
    $script:labelFinContrat.Size = New-Object System.Drawing.Size(100,22)
    $script:labelFinContrat.text = "Fin de contrat"
    $script:labelFinContrat.Visible = $true

    $script:datePickerFinContrat.Location = New-Object System.Drawing.Point($placementLargeurDate,$placementHauteur)
    $script:datePickerFinContrat.Size = New-Object System.Drawing.Size(100,20)
    $script:datePickerFinContrat.Visible = $true
    $script:datePickerFinContrat.Format = [System.Windows.Forms.DateTimePickerFormat]::Short

    $placementHauteur = $placementHauteur + 40
    $placementLargeurButton = $placementLargeurText + 130

    $script:buttonValider.Location = New-Object System.Drawing.Point($placementLargeurButton,$placementHauteur)
    $script:buttonValider.Size = New-Object System.Drawing.Size(70,22)
    $script:buttonValider.Text = "Valider"
    $script:buttonValider.Add_Click({validerData})
    $script:buttonValider.Visible = $true

    $placementHauteur = $placementHauteur + 40

    $script:labelCodeNonValide.Location = New-Object System.Drawing.Point($placementLargeurLabel,$placementHauteur)
    $script:labelCodeNonValide.Size = New-Object System.Drawing.Size(200,22)
    $script:labelCodeNonValide.Visible = $false
    
    $script:labelNomNonValide.Location = New-Object System.Drawing.Point($placementLargeurLabel,$placementHauteur)
    $script:labelNomNonValide.Size = New-Object System.Drawing.Size(200,22)
    $script:labelNomNonValide.Visible = $false
    
    $script:labelPrenomNonValide.Location = New-Object System.Drawing.Point($placementLargeurLabel,$placementHauteur)
    $script:labelPrenomNonValide.Size = New-Object System.Drawing.Size(200,22)
    $script:labelPrenomNonValide.Visible = $false

    $script:labelDateNonValide.Location = New-Object System.Drawing.Point($placementLargeurLabel,$placementHauteur)
    $script:labelDateNonValide.Size = New-Object System.Drawing.Size(300,40)
    $script:labelDateNonValide.Visible = $false

    $labelSite.Location = New-Object System.Drawing.Point(500,20)
    $labelSite.Size = New-Object System.Drawing.Size(200,22)
    $labelSite.Text = "2. Choisir le site"
    $labelSite.Visible = $false

    $script:comboBoxSite.Location = New-Object System.Drawing.Point(500,45)
    $script:comboBoxSite.Size = New-Object System.Drawing.Size(200,22)
    $script:comboBoxSite.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
    $script:comboBoxSite.Visible = $false

    $labelFormation.Location = New-Object System.Drawing.Point(705,20)
    $labelFormation.Size = New-Object System.Drawing.Size(200,22)
    $labelFormation.Text = "3. Choisir la formation"
    $labelFormation.Visible = $false
    
    $script:comboBoxFormation.Location = New-Object System.Drawing.Point(705,45)
    $script:comboBoxFormation.Size = New-Object System.Drawing.Size(200,22)
    $script:comboBoxFormation.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
    $script:comboBoxFormation.Visible = $false

    $labelPlateformes.Location = New-Object System.Drawing.Point(500,100)
    $labelPlateformes.Size = New-Object System.Drawing.Size(200,22)
    $labelPlateformes.Text = "4. Sélectionner les comptes a créer"
    $labelPlateformes.Visible = $false
    
    $script:listBoxplateformes.Location = New-Object System.Drawing.Point(500,125)
    $script:listBoxplateformes.Size = New-Object System.Drawing.Size(180,210)
    $script:listBoxplateformes.CheckOnClick = $true
    #$script:listBoxplateformes.Add_ItemCheck({ModifyFormationPlateformes})
    $script:listBoxplateformes.visible = $false

    $ButtonRetour = New-Object System.Windows.Forms.Button
    $ButtonRetour.Location = New-Object System.Drawing.Point(20,580)
    $ButtonRetour.Size = New-Object System.Drawing.Size(150,60)
    $ButtonRetour.Text = "Retour"
    $ButtonRetour.Add_Click({$listForm.Close()})
    # la touche echap est mappée sur retour
    $listForm.CancelButton = $ButtonRetour

    $script:buttonCreerCompte.Location = New-Object System.Drawing.Point(815,580)
    $script:buttonCreerCompte.Size = New-Object System.Drawing.Size(150,60)
    $script:buttonCreerCompte.Text = "Créer le compte"
    $script:buttonCreerCompte.Add_Click({
        SelectPlateformes
        $listForm.Close()
    })
    $script:buttonCreerCompte.Visible = $false
    # la touche entrée est mappée sur importer
    $listForm.AcceptButton = $script:buttonCreerCompte

    $listForm.Controls.Add($labelData)
    $listForm.Controls.Add($script:LabelCodeStagiaire)
    $listForm.Controls.Add($script:LabelNom)
    $listForm.Controls.Add($script:LabelPrenom)
    $listForm.Controls.Add($script:LabelDateNaissance)
    $listForm.Controls.Add($script:labelDebutContrat)
    $listForm.Controls.Add($script:labelFinContrat)
    
    $listForm.Controls.Add($script:TextBoxCodeStagiaire)
    $listForm.Controls.Add($script:TextBoxNom)
    $listForm.Controls.Add($script:TextBoxPrenom)
    $listForm.Controls.Add($script:datePickerNaissance)
    $listForm.Controls.Add($script:datePickerDebutContrat)
    $listForm.Controls.Add($script:datePickerFinContrat)

    $listForm.Controls.Add($script:buttonValider)
    $listForm.Controls.Add($script:labelCodeNonValide)
    $listForm.Controls.Add($script:labelNomNonValide)
    $listForm.Controls.Add($script:labelPrenomNonValide)
    $listForm.Controls.Add($script:labelDateNonValide)
    
    $listForm.Controls.Add($script:labelSite)
    $listForm.Controls.Add($script:comboBoxSite)
    $listForm.Controls.Add($script:labelFormation)
    $listForm.Controls.Add($script:comboBoxFormation)
    $listForm.Controls.Add($script:buttonCreerCompte)

    $listForm.Controls.Add($script:labelPlateformes)
    $listForm.Controls.Add($script:listBoxPlateformes)

    $listForm.Controls.Add($ButtonRetour)
    
    # Afficher la fenetre
    $listForm.ShowDialog()
}