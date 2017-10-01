Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

. "../ps/fg_1-1_DBUtils.ps1"
. "../GUI/CreationUnitaire_Functions.ps1"
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
#    exit'
#}

OpenDB

$formations = MakeRequest "select * from formation"
$sites = MakeRequest "select * from site"
$plateformes = MakeRequest "select * from plateforme"

MakeForm

CloseDB