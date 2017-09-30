Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

. "../ps/fg_1-1_DBUtils.ps1"
. "../GUI/fa_3_CreationComptesCSV_Functions.ps1"
#if ($ADusername -eq $NULL)
#{
#    exit
#}
OpenDB

$formations = MakeRequest "select * from formation"
$sites = MakeRequest "select * from site"
$plateformes = MakeRequest "select * from plateforme"

MakeForm

CloseDB