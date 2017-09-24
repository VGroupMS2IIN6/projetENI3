# Chargement du pilote .NET pour MySQL 
#[system.reflection.Assembly]::LoadWithPartialName("MySql.Data")
Add-Type -Path '..\libs\MySql.Data.dll'
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Initialisation des variables  
$serv = "127.0.0.1" # Addresse du serveur
$port = "3306" # Port de connexion (3306 par dÃ©faut)
$user = "vgroup"  # nom d'utilisateur pour la connexion
$password = "vgrouproxx" # mot de passe
$db = "projet_eni" # nom de la base de donnÃ©e

# Creation de l'instance, connexion Ã  la base de donnÃ©es  
$mysql = New-Object MySql.Data.MySqlClient.MySqlConnection("server=" + $serv + ";port=" + $port + ";uid=" + $user + ";pwd=" + $password + ";database=" + $db + ";Pooling=False")  
$mysql.Open()

# recuperation de la liste des plateformes
$plateformes = MakeRequest "SELECT * FROM plateforme"
$profils = MakeRequest "SELECT * FROM profil"
$utilisateurs = MakeRequest "SELECT * FROM utilisateur"
#$droitPlateformes = MakeRequest "select ass_droit_plateforme.ID, droit.nom droit, plateforme.nom plateforme from droit, plateforme, ass_droit_plateforme where ass_droit_plateforme.droit = droit.ID and ass_droit_plateforme.plateforme = plateforme.ID and ass_droit_plateforme.droit ORDER by droit.ID, plateforme.ID;"

# Creation des composants dont on aura besoin plus tard
$listForm = New-Object System.Windows.Forms.Form
$listForm.Text = "Paramétrage"
$listForm.Size = New-Object System.Drawing.Size(1000,700)
$listForm.StartPosition = "CenterScreen"

$textBoxAdURL = New-Object System.Windows.Forms.TextBox
$textBoxAdURL.Location = New-Object System.Drawing.Point(220,50)
$textBoxAdURL.Size = New-Object System.Drawing.Size(200,22)
$textBoxAdUser = New-Object System.Windows.Forms.TextBox
$textBoxAdUser.Location = New-Object System.Drawing.Point(220,90)
$textBoxAdUser.Size = New-Object System.Drawing.Size(200,22)
$textBoxAdMDP = New-Object System.Windows.Forms.TextBox
$textBoxAdMDP.Location = New-Object System.Drawing.Point(220,130)
$textBoxAdMDP.Size = New-Object System.Drawing.Size(200,22)

$ListBoxAffichage = New-Object System.Windows.Forms.ListBox 
$ListBoxAffichage.Location = New-Object System.Drawing.Size(255,30) 
$ListBoxAffichage.Size = New-Object System.Drawing.Size(700,530) 
$ComboBoxPlateformes = New-Object System.Windows.Forms.ComboBox
$ComboBoxPlateformes.Location = New-Object System.Drawing.Point(10,10)
$ComboBoxPlateformes.Size = New-Object System.Drawing.Size(200,20)
$ComboBoxPlateformes.add_SelectedIndexChanged({FillPlateforme})
FillComboBoxPlateformes
$ComboBoxProfil = New-Object System.Windows.Forms.ComboBox
$ComboBoxProfil.Location = New-Object System.Drawing.Point(10,10)
$ComboBoxProfil.Size = New-Object System.Drawing.Size(200,20)
$ComboBoxProfil.add_SelectedIndexChanged({FillProfilPlateforme})
FillComboBoxProfil
$ComboBoxUtilisateur = New-Object System.Windows.Forms.ComboBox
$ComboBoxUtilisateur.Location = New-Object System.Drawing.Point(10,10)
$ComboBoxUtilisateur.Size = New-Object System.Drawing.Size(200,20)
$ComboBoxUtilisateur.add_SelectedIndexChanged({FillProfilUtilisateur})
FillComboBoxUtilisateur
$textBoxURL = New-Object System.Windows.Forms.TextBox
$textBoxURL.Location = New-Object System.Drawing.Point(220,50)
$textBoxURL.Size = New-Object System.Drawing.Size(200,22)
$textBoxMail = New-Object System.Windows.Forms.TextBox
$textBoxMail.Location = New-Object System.Drawing.Point(220,90)
$textBoxMail.Size = New-Object System.Drawing.Size(200,22)
$textBoxUser = New-Object System.Windows.Forms.TextBox
$textBoxUser.Location = New-Object System.Drawing.Point(220,130)
$textBoxUser.Size = New-Object System.Drawing.Size(200,22)
$textBoxMdp = New-Object System.Windows.Forms.TextBox
$textBoxMdp.Location = New-Object System.Drawing.Point(220,170)
$textBoxMdp.Size = New-Object System.Drawing.Size(200,22)
$textBoxRegexMdp = New-Object System.Windows.Forms.TextBox
$textBoxRegexMdp.Location = New-Object System.Drawing.Point(220,210)
$textBoxRegexMdp.Size = New-Object System.Drawing.Size(200,22)
$checkBoxObligatoire = New-Object System.Windows.Forms.CheckBox
$checkBoxObligatoire.Location = New-Object System.Drawing.Point(220,250)
$checkBoxObligatoire.Size = New-Object System.Drawing.Size(200,22)

$listBoxDroitPlateforme = New-Object System.Windows.Forms.checkedListBox
$listBoxDroitPlateforme.Location = New-Object System.Drawing.Point(10,80)
$listBoxDroitPlateforme.Size = New-Object System.Drawing.Size(280,410)
#TODO : vérifier si le comportement est bien celui avec cette option à true
$listBoxDroitPlateforme.CheckOnClick = $true
# ajouter l'enregistrement en base de chaque case cochée.
$listBoxDroitPlateforme.Add_ItemCheck({ModifyProfilDroitsPlateforme})
$saveEnabled = $true
#$listBoxDroitPlateforme.add_SelectedIndexChanged({FillDroitsDroitPlateforme})

$listBoxDroitFormSite = New-Object System.Windows.Forms.checkedListBox
$listBoxDroitFormSite.Location = New-Object System.Drawing.Point(400,80)
$listBoxDroitFormSite.Size = New-Object System.Drawing.Size(280,410)
#TODO : vérifier si le comportement est bien celui avec cette option à true
$listBoxDroitFormSite.CheckOnClick = $true
# ajouter l'enregistrement en base de chaque case cochée.
$listBoxDroitFormSite.Add_ItemCheck({ModifyProfilDroitsFormSite})

$listBoxProfils = New-Object System.Windows.Forms.checkedListBox
$listBoxProfils.Location = New-Object System.Drawing.Point(10,80)
$listBoxProfils.Size = New-Object System.Drawing.Size(280,410)
#TODO : vérifier si le comportement est bien celui avec cette option à true
$listBoxProfils.CheckOnClick = $true
# ajouter l'enregistrement en base de chaque case cochée.
$listBoxProfils.Add_ItemCheck({ModifyProfilUtilisateur})

# Affichage de l'ecran
MakeForm

$mysql.Close()

function FillComboBoxPlateformes {
    # creation de la datatable
    $table = New-Object system.Data.DataTable
		
    # definition des colonnes
    $colId = New-Object system.Data.DataColumn "id",([string])
    $colNom = New-Object system.Data.DataColumn "nom",([string])
 
    # table des colonnes à la datatable
    $table.Columns.Add($colId)
    $table.Columns.Add($colNom)

    # alimentation de la datatable avec les plateformes
    foreach($plateforme in $script:plateformes) {
        $ligne = $table.NewRow()
        $ligne.id = $plateforme.ID
        $ligne.nom = $plateforme.nom
        $table.Rows.Add($ligne)
    }

    $script:ComboBoxPlateformes.DisplayMember = "nom"
    $script:ComboBoxPlateformes.ValueMember = "id"
    $script:ComboBoxPlateformes.DataSource = $table
}

function FillComboBoxProfil {
    # creation de la datatable
    $table = New-Object system.Data.DataTable
		
    # definition des colonnes
    $colId = New-Object system.Data.DataColumn "id",([string])
    $colNom = New-Object system.Data.DataColumn "nom",([string])
 
    # table des colonnes à la datatable
    $table.Columns.Add($colId)
    $table.Columns.Add($colNom)

    # alimentation de la datatable avec les plateformes
    foreach($profil in $script:profils) {
        $ligne = $table.NewRow()
        $ligne.id = $profil.ID
        $ligne.nom = $profil.nom
        $table.Rows.Add($ligne)
    }

    $script:ComboBoxProfil.DisplayMember = "nom"
    $script:ComboBoxProfil.ValueMember = "id"
    $script:ComboBoxProfil.DataSource = $table
}

function MakeRequest($request) {
    $command = New-Object Mysql.Data.MysqlClient.MySqlCommand($request,$mysql)  
    $dataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($command)
    $dataSet = New-Object System.Data.DataSet
    $recordCount = $dataAdapter.Fill($dataSet, "data")
    $result = $dataSet.Tables["data"]
    return $result
}

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

Function MakeForm {
    $ButtonADAdmin = New-Object System.Windows.Forms.Button
    $ButtonADAdmin.Location = New-Object System.Drawing.Point(40,40)
    $ButtonADAdmin.Size = New-Object System.Drawing.Size(200,50)
    $ButtonADAdmin.Text = "Active Directory administratif"
    $ButtonADAdmin.Add_Click({makeMenuAd})

    $ButtonPlateformes = New-Object System.Windows.Forms.Button
    $ButtonPlateformes.Location = New-Object System.Drawing.Point(40,100)
    $ButtonPlateformes.Size = New-Object System.Drawing.Size(200,50)
    $ButtonPlateformes.Text = "Plateformes"
    $ButtonPlateformes.Add_Click({makeMenuPlateformes})

    $ButtonDefProfils = New-Object System.Windows.Forms.Button
    $ButtonDefProfils.Location = New-Object System.Drawing.Point(40,160)
    $ButtonDefProfils.Size = New-Object System.Drawing.Size(200,50)
    $ButtonDefProfils.Text = "Défnition des profils"
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
    $ButtonRetour.Add_Click({$script:listForm.Close()})
    # la touche echap est mappée sur retour
    $script:listForm.CancelButton = $ButtonRetour

    $ListBoxMenu = New-Object System.Windows.Forms.ListBox 
    $ListBoxMenu.Location = New-Object System.Drawing.Size(30,30) 
    $ListBoxMenu.Size = New-Object System.Drawing.Size(220,530) 

    $script:listForm.Controls.Add($ButtonADAdmin) 
    $script:listForm.Controls.Add($ButtonPlateformes)
    $script:listForm.Controls.Add($ButtonDefProfils)
    $script:listForm.Controls.Add($ButtonAssProfils)
    $script:listForm.Controls.Add($ButtonRetour)
    $script:listForm.Controls.Add($ListBoxMenu)
    $script:listForm.Controls.Add($script:ListBoxAffichage)

    # Afficher la fenetre
    $script:listForm.ShowDialog()
}

Function ModifyAd {
    # on créé le répertoire s'il n'existe pas
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

    $buttonEnregistrerAd = New-Object System.Windows.Forms.Button
    $buttonEnregistrerAd.Location = New-Object System.Drawing.Point(220,10)
    $buttonEnregistrerAd.Size = New-Object System.Drawing.Size(70,22)
    $buttonEnregistrerAd.Text = "Enregistrer"
    $buttonEnregistrerAd.Add_Click({ModifyAd})

    $labelAdURL = New-Object System.Windows.Forms.Label
    $labelAdURL.Location = New-Object System.Drawing.Point(10,50)
    $labelAdURL.Size = New-Object System.Drawing.Size(200,20)
    $labelAdURL.Text = "Adresse IP ou nom du serveur"
    $labelAdURL.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes

    $labelAdUser = New-Object System.Windows.Forms.Label
    $labelAdUser.Location = New-Object System.Drawing.Point(10,90)
    $labelAdUser.Size = New-Object System.Drawing.Size(200,20)
    $labelAdUser.Text = "Nom d'utilisateur"
    $labelAdUser.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes
    
    $labelAdMDP = New-Object System.Windows.Forms.Label
    $labelAdMDP.Location = New-Object System.Drawing.Point(10,130)
    $labelAdMDP.Size = New-Object System.Drawing.Size(200,20)
    $labelAdMDP.Text = "Mot de passe"
    $labelAdMDP.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes
    
    $script:ListBoxAffichage.Controls.clear();
    $script:ListBoxAffichage.Controls.Add($labelTitreAd)
    $script:ListBoxAffichage.Controls.Add($buttonEnregistrerAd)
    $script:ListBoxAffichage.Controls.Add($labelAdURL)
    $script:ListBoxAffichage.Controls.Add($script:textBoxAdURL)
    $script:ListBoxAffichage.Controls.Add($labelAdUser)
    $script:ListBoxAffichage.Controls.Add($script:textBoxAdUser)
    $script:ListBoxAffichage.Controls.Add($labelAdMDP)
    $script:ListBoxAffichage.Controls.Add($script:textBoxAdMDP)

    # si le fichier existe, on charge les données
    if(Test-Path '..\config\ad.properties') {
        $adprop = ConvertFrom-StringData (Get-Content '..\config\ad.properties' -raw)
        $script:textBoxAdURL.Text = $adprop.'url'
        $script:textBoxAdUser.Text = $adprop.'user'
        $script:textBoxAdMDP.Text = $adprop.'pass'
    }
}

Function AddPlateforme {
    # on vérifie qu'on essaie pas d'insérer une entrée déjà existante
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

        $reqSelect = "select last_insert_id() as id"
        # last_insert_id() permet de récupérer le dernier auto_increment de la connexion courante
        # c'est donc valide même dans le cas de plusieurs clients en parallèle
        $idNewPlateforme = MakeRequest $reqSelect

        # on ajoute les droits pour les plateformes
        $reqInsertDroitsPlateformes = "INSERT INTO projet_eni.ass_droit_plateforme (droit, plateforme)"
        $reqInsertDroitsPlateformes += " select droit.ID, " + $idNewPlateforme.id + " from droit"
        MakeRequest $reqInsertDroitsPlateformes

#############################################################################
#############################################################################
##     #requete compliquée il manque le listing de tous les profils....    ##
#############################################################################
#############################################################################

#        # on ajoute les droits pour les plateformes
#        $reqInsertDroitsPlateformes = "INSERT INTO projet_eni.ass_profil_droit_plateforme (profil, droit_plateforme, accord)"
#        $reqInsertDroitsPlateformes += " select " + $idNewPlateforme.id + ", ass_droit_plateforme.ID droit_plateforme, 0 accord from ass_droit_plateforme where plateforme = " + $idNewPlateforme.id
#        MakeRequest $reqInsertDroitsPlateformes

        # on recharge les infos
        $script:plateformes = MakeRequest "SELECT * FROM plateforme"
        FillComboBoxPlateformes
    }
}

Function ModifyPlateforme {
    # on vérifie qu'on essaie pas de modifier une nouvelle entrée pas encore insérée
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

Function DeletePlateforme {
    # on vérifie qu'on essaie pas de supprimer une nouvelle entrée pas encore insérée
    if($script:ComboBoxPlateformes.SelectedIndex -ne -1) {
        $reqDelete = "delete from plateforme where id="
        $reqDelete += $script:ComboBoxPlateformes.SelectedItem.id
        MakeRequest $reqDelete

#############################################################################
#############################################################################
##      TODO : supprimer les infos des tables d'associations pdp et dp     ##
#############################################################################
#############################################################################

        # on recharge les infos
        $script:plateformes = MakeRequest "SELECT * FROM plateforme"
        FillComboBoxPlateformes
    }
}

Function MakeMenuPlateformes {
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

    $labelURL = New-Object System.Windows.Forms.Label
    $labelURL.Location = New-Object System.Drawing.Point(10,50)
    $labelURL.Size = New-Object System.Drawing.Size(200,20)
    $labelURL.Text = "Adresse IP ou nom du serveur"
    $labelURL.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes

    $labelMail = New-Object System.Windows.Forms.Label
    $labelMail.Location = New-Object System.Drawing.Point(10,90)
    $labelMail.Size = New-Object System.Drawing.Size(200,20)
    $labelMail.Text = "Adresse mail destinataire"
    $labelMail.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes
    
    $labelUser = New-Object System.Windows.Forms.Label
    $labelUser.Location = New-Object System.Drawing.Point(10,130)
    $labelUser.Size = New-Object System.Drawing.Size(200,20)
    $labelUser.Text = "Nom d'utilisateur"
    $labelUser.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes

    $labelMdp = New-Object System.Windows.Forms.Label
    $labelMdp.Location = New-Object System.Drawing.Point(10,170)
    $labelMdp.Size = New-Object System.Drawing.Size(200,20)
    $labelMdp.Text = "Mot de passe"
    $labelMdp.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes

    $labelRegexMdp = New-Object System.Windows.Forms.Label
    $labelRegexMdp.Location = New-Object System.Drawing.Point(10,210)
    $labelRegexMdp.Size = New-Object System.Drawing.Size(200,20)
    $labelRegexMdp.Text = "Regex de génération du mot de passe"
    $labelRegexMdp.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes
    
    $labelObligatoire = New-Object System.Windows.Forms.Label
    $labelObligatoire.Location = New-Object System.Drawing.Point(10,250)
    $labelObligatoire.Size = New-Object System.Drawing.Size(200,20)
    $labelObligatoire.Text = "Compte obligatoire"
    $labelObligatoire.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes
    
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

Function FillPlateforme {
    $plateforme = RetreiveRow $script:plateformes "id" $script:ComboBoxPlateformes.SelectedItem.id
    $script:textBoxURL.Text = $plateforme.URL
    $script:textBoxMail.Text = $plateforme.mail
    $script:textBoxUser.Text = $plateforme.identifiant
    $script:textBoxMdp.Text = $plateforme.MDP
    $script:textBoxRegexMdp.Text = $plateforme.regexMDP
    $script:checkBoxObligatoire.Checked = $plateforme.obligatoire
}

Function AddProfil {
    # on vérifie qu'on essaie pas d'insérer une entrée déjà existante
    if($script:ComboBoxProfil.SelectedIndex -eq -1 -and -not [string]::IsNullOrEmpty($script:ComboBoxProfil.Text)) {
        # on crée le nouveau profil
        $reqInsertProfil = "insert into profil(nom) values('" + $script:ComboBoxProfil.Text + "')"
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

        # on recharge les infos
        $script:profils = MakeRequest "SELECT * FROM profil"
        FillComboBoxProfil
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

Function DeleteProfil {
    # on vérifie qu'on essaie pas de supprimer une nouvelle entrée pas encore insérée
    if($script:ComboBoxProfil.SelectedIndex -ne -1) {
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
        FillComboBoxProfil
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
    $labelcreation.Text = "Création de comptes"
    $labelcreation.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes

    $labelFormSite = New-Object System.Windows.Forms.Label
    $labelFormSite.Location = New-Object System.Drawing.Point(400,50)
    $labelFormSite.Size = New-Object System.Drawing.Size(200,20)
    $labelFormSite.Text = "droits formations et sites"
    $labelFormSite.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes

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
    # rustine dégueu en attendant de comprendre
    FillProfilPlateforme
}

Function FillProfilPlateforme {
    #afficher les droits de création et réinitialisation de compte en lien avec le profil et en fonction du nombre de plateformes

    # creation de la datatable
    $table = New-Object system.Data.DataTable
		
    # definition des colonnes
    $colId = New-Object system.Data.DataColumn "id",([string])
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

Function FillProfilFormSite {
    #afficher les droits de création et réinitialisation de compte en lien avec le profil et en fonction du nombre de plateformes

    # creation de la datatable
    $table = New-Object system.Data.DataTable
		
    # definition des colonnes
    $colId = New-Object system.Data.DataColumn "id",([string])
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

Function MakeMenuAssProfils {
    #afficher tous les comptes pour un profil sélectionné + checkbox pour sélectionner les users (en fonction du nombre de users dans la base

    $script:ListBoxAffichage.Controls.clear();
    $script:ListBoxAffichage.Controls.Add($script:ComboBoxUtilisateur)
    $script:ListBoxAffichage.Controls.Add($script:listBoxProfils)

    # alimentation des champs pour le profil selectionne
    FillProfilUtilisateur
    FillProfilUtilisateur
}

function FillComboBoxUtilisateur {
    # creation de la datatable
    $table = New-Object system.Data.DataTable
		
    # definition des colonnes
    $colId = New-Object system.Data.DataColumn "id",([string])
    $colLogin = New-Object system.Data.DataColumn "login",([string])
 
    # table des colonnes à la datatable
    $table.Columns.Add($colId)
    $table.Columns.Add($colLogin)

    # alimentation de la datatable avec les plateformes
    foreach($utilisateur in $script:utilisateurs) {
        $ligne = $table.NewRow()
        $ligne.id = $utilisateur.ID
        $ligne.login = $utilisateur.login
        $table.Rows.Add($ligne)
    }

    $script:ComboBoxUtilisateur.DisplayMember = "login"
    $script:ComboBoxUtilisateur.ValueMember = "id"
    $script:ComboBoxUtilisateur.DataSource = $table
}

Function FillProfilUtilisateur {
    #afficher les droits de création et réinitialisation de compte en lien avec le profil et en fonction du nombre de plateformes

    # creation de la datatable
    $table = New-Object system.Data.DataTable
		
    # definition des colonnes
    $colId = New-Object system.Data.DataColumn "id",([string])
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

Function ModifyProfilUtilisateur {
    if($script:saveEnabled) {
        # la case n'est pas encore décochée quand l'événement est déclenché, d'où le -not
        $accord = -not $script:listBoxProfils.GetItemChecked($script:listBoxProfils.SelectedIndex)
        $reqUpdate = "update ass_profil_utilisateur set accord = " + $accord
        $reqUpdate += " where id = " + $script:listBoxProfils.SelectedItem.id
        MakeRequest $reqUpdate
    }
}