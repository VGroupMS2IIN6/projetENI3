<#
Fonction : fg_3.0_GenerationMdpTemp_PS
#>
function GenerationMdpTemp
{
    # Requete SQL de récupération de l'expresion régulière de génération du mot de passe en fonction de la plateforme
    $nomPlateforme = $plateformeBase -replace "_"," "
    $reqRegexMdp = 'select regexMDP from plateforme where nom = "' + $nomPlateforme + '";'
    $regexmdp = makeRequest $reqRegexMdp
    $testeu = $($prenom.Substring(0,2).ToLower() + $nom.Substring(0,2).ToUpper() + $DateNaissance.Substring(0,2).ToUpper() + "@")
    if ($regexmdp.regexMDP.Length -gt 0)
    {
        # Génération du mot de passe
        $password = invoke-expression $regexmdp.regexMDP

        return $password
    }
}