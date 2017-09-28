Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

. "../ps/fg_1-1_DBUtils.ps1"
. "../GUI/fa_7_Parametres_Functions.ps1"

OpenDB

# recuperation de la liste des plateformes
$plateformes = MakeRequest "SELECT * FROM plateforme"
$profils = MakeRequest "SELECT * FROM profil"
$utilisateurs = MakeRequest "SELECT * FROM utilisateur"
#$droitPlateformes = MakeRequest "select ass_droit_plateforme.ID, droit.nom droit, plateforme.nom plateforme from droit, plateforme, ass_droit_plateforme where ass_droit_plateforme.droit = droit.ID and ass_droit_plateforme.plateforme = plateforme.ID and ass_droit_plateforme.droit ORDER by droit.ID, plateforme.ID;"

# Creation des composants dont on aura besoin plus tard
$listBoxDroitPlateforme = New-Object System.Windows.Forms.checkedListBox
$listBoxDroitPlateforme.Location = New-Object System.Drawing.Point(10,80)
$listBoxDroitPlateforme.Size = New-Object System.Drawing.Size(280,410)
$listBoxDroitPlateforme.CheckOnClick = $true
$listBoxDroitPlateforme.Add_ItemCheck({ModifyProfilDroitsPlateforme})
$saveEnabled = $true
#$listBoxDroitPlateforme.add_SelectedIndexChanged({FillDroitsDroitPlateforme})

$listBoxDroitFormSite = New-Object System.Windows.Forms.checkedListBox
$listBoxDroitFormSite.Location = New-Object System.Drawing.Point(400,80)
$listBoxDroitFormSite.Size = New-Object System.Drawing.Size(280,410)
$listBoxDroitFormSite.CheckOnClick = $true
$listBoxDroitFormSite.Add_ItemCheck({ModifyProfilDroitsFormSite})

$listBoxProfils = New-Object System.Windows.Forms.checkedListBox
$listBoxProfils.Location = New-Object System.Drawing.Point(10,80)
$listBoxProfils.Size = New-Object System.Drawing.Size(280,410)
$listBoxProfils.CheckOnClick = $true
$listBoxProfils.Add_ItemCheck({ModifyProfilUtilisateur})

# Affichage de l'ecran
MakeForm

CloseDB



