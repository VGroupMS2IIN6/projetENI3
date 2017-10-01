Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

. "../ps/fg_1-1_DBUtils.ps1"
. "../GUI/fa_3_CreationComptesCSV_Functions.ps1"
#chargement de la fonction s'occupant de la gestion des droits
. "../ps/droits.ps1"
#chargement de la fonction de mise en forme des variables
. "../ps/RemoveStrangeChar.ps1"
#chargement des fonctions pour les créations
. "../ps/creation_active_directory.ps1"
. "../ps/creation_7speaking.ps1"
. "../ps/creation_office_365.ps1"
. "../ps/creation_cisco.ps1"
. "../ps/creation_mediaplus.ps1"

#if ($ADusername -eq $NULL)
#{
#    exit
#}
OpenDB

$formations = MakeRequest "select * from formation"
$sites = MakeRequest "select * from site"
$reqSel = "select distinct p.* from plateforme p"
$reqSel += " join ass_droit_plateforme dp on dp.plateforme = p.ID"
$reqSel += " join ass_profil_droit_plateforme pdp on pdp.droit_plateforme = dp.ID and pdp.accord = 1"
$reqSel += " join profil pf on pdp.profil = pf.ID"
$reqSel += " join ass_profil_utilisateur pu on pu.profil = pf.ID and pu.accord = 1"
$reqSel += " join utilisateur u on pu.utilisateur = u.ID"
$reqSel += " where u.login = '" + $ADusername + "'"
$plateformes = MakeRequest $reqSel

MakeForm

CloseDB