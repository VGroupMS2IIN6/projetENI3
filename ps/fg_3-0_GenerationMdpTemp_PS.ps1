<#
Fonction : fg_3.0_GenerationMdpTemp_PS
#>
function GenerationMdpTemp
{
    # Requete SQL de récupération de l'expresion régulière de génération du mot de passe en fonction de la plateforme
    $nomPlateforme = $plateforme -replace "_"," "
    $reqRegexMdp = 'select regexMDP from plateforme where nom = "' + $nomPlateforme + '";'
    $regexmdp = makeRequest $reqRegexMdp
    if ($regexmdp.regexMDP.Length -gt 0)
    {
        # Génération du mot de passe
        $password = invoke-expression $regexmdp.regexMDP

        return $password
    }
}