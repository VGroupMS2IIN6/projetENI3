Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

. "../ps/fg_1-1_DBUtils.ps1"
. "../GUI/CreationUnitaire_Functions.ps1"
#chargement de la fonction s'occupant de la gestion des droits
. "../ps/droits.ps1"
#chargement de la fonction de mise en forme des variables
. "../ps/RemoveStrangeChar.ps1"
# chargement de la fonction de génération de mdp temp
. "../ps/fg_3-0_GenerationMdpTemp_PS.ps1"
#chargement des fonctions pour les créations
. "../ps/creation_active_directory.ps1"
. "../ps/creation_7speaking.ps1"
. "../ps/creation_office_365.ps1"
. "../ps/creation_cisco.ps1"
. "../ps/creation_mediaplus.ps1"
. "../ps/creation_microsoft_imagine.ps1"


if ($ADusername -eq $NULL)
{
    #exit
    $ADusername = "sartu"
}

OpenDB

$formations = MakeRequest "select * from formation"
$sites = MakeRequest "select * from site"

MakeForm

CloseDB