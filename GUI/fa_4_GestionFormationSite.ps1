Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

. "../ps/fg_1-1_DBUtils.ps1"
. "../GUI/fa_4_GestionFormationSite_Functions.ps1"

OpenDB

# recuperation de la liste des plateformes
$plateformes = MakeRequest "SELECT * FROM plateforme"
$sites = MakeRequest "SELECT * FROM site"
$formations = MakeRequest "SELECT * FROM formation"

# Creation des composants dont on aura besoin plus tard

$listBoxFormations = New-Object System.Windows.Forms.checkedListBox
$listBoxFormations.Location = New-Object System.Drawing.Point(10,80)
$listBoxFormations.Size = New-Object System.Drawing.Size(280,410)
$listBoxFormations.CheckOnClick = $true
$listBoxFormations.Add_ItemCheck({ModifySiteFormations})

$listBoxplateformes = New-Object System.Windows.Forms.checkedListBox
$listBoxplateformes.Location = New-Object System.Drawing.Point(10,80)
$listBoxplateformes.Size = New-Object System.Drawing.Size(280,410)
$listBoxplateformes.CheckOnClick = $true
$listBoxplateformes.Add_ItemCheck({ModifyFormationPlateformes})

# Affichage de l'ecran
MakeForm

CloseDB



