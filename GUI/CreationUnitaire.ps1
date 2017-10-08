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
# chargement de la fonction de vérification AD
. "../ps/verification_active_directory.ps1"

. "../ps/chiffrement_mdp.ps1"
. "../ps/dechiffrement_mdp.ps1"

if ($ADusername -eq $NULL)
{
    exit
}

OpenDB

#chargement des fonctions pour les créations
$reqsel = "select nom from plateforme;"
$scriptsPlateformes = makeRequest $reqsel
$scriptsPlateformes = $scriptsplateformes.nom -replace " ","_"
foreach ($scriptPlateforme in $scriptsPlateformes)
{
    $scriptPlateforme = "creation_" + $scriptplateforme + ".ps1"
    . "../ps/$scriptPlateforme"
}

$formations = MakeRequest "select * from formation"
$sites = MakeRequest "select * from site"

MakeForm

CloseDB