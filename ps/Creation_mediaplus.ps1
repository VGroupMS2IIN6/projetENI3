function creation_mediaplus
{
    # on vérifie que ce n'est pas la dernière exécution
    if ($vide -eq $NULL -and $script:creationTotale -eq $true)
    {
        $reqsel = "select * from plateforme where nom = 'mediaplus'"
        $result = makeRequest $reqsel
        $urlMediaPlus = $result.url
        $loginAPI = $result.identifiant
        $passwordSecureAPI = $result.mdp
        $passwordAPI = Dechiffrement $passwordSecureAPI 

        $login = $($PrenomSSCaratSpec.ToLower() + $NomSSCaratSpec.ToLower() + $annee)
        $sexe = 2
        $requeteSoap = "<soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:eni='http://ENI.Editions.MEDIAplus.Web.Services/'><soapenv:Header><eni:CredentialHeader><!--Optional:--><eni:Separator></eni:Separator><!--Optional:--><eni:Login>SOAPLOGINAPI</eni:Login><!--Optional:--><eni:Password>SOAPPASSWORDAPI</eni:Password><!--Optional:--><eni:NULLValue>#NULL</eni:NULLValue></eni:CredentialHeader></soapenv:Header><soapenv:Body><eni:User_WriteInfos><!--Optional:--><eni:ooParameters><eni:Id>-1</eni:Id><eni:Guid>00000000-0000-0000-0000-000000000000</eni:Guid><eni:IdOrg>4</eni:IdOrg><!--Optional:--><eni:FamilyName>SOAPNOM</eni:FamilyName><!--Optional:--><eni:FirstName>SOAPPRENOM</eni:FirstName><!--Optional:--><eni:Login>SOAPLOGIN</eni:Login><eni:Title>SOAPSEXE</eni:Title><!--Optional:--><eni:Email>SOAPEMAIL</eni:Email><!--Optional:--><eni:Password>SOAPPASSWD</eni:Password><eni:StateMask>2</eni:StateMask><eni:UpdateOption>UpdateByLogin</eni:UpdateOption></eni:ooParameters></eni:User_WriteInfos></soapenv:Body></soapenv:Envelope>"
        $requeteSoap = $requeteSoap -replace "SOAPPASSWORDAPI","$passwordAPI"
        $requeteSoap = $requeteSoap -replace "SOAPPASSWD","$password"
        $requeteSoap = $requeteSoap -replace "SOAPPRENOM","$prenom"
        $requeteSoap = $requeteSoap -replace "SOAPNOM","$nom"
        $requeteSoap = $requeteSoap -replace "SOAPLOGINAPI","$loginAPI"
        $requeteSoap = $requeteSoap -replace "SOAPLOGIN","$login"
        $requeteSoap = $requeteSoap -replace "SOAPSEXE","$sexe"
        $requeteSoap = $requeteSoap -replace "SOAPEMAIL","$email"
        
        ..\bin\curl.exe -i -s -k -X 'POST' -H 'Content-Type: text/xml;charset=UTF-8' -H 'SOAPAction: http://ENI.Editions.MEDIAplus.Web.Services/User_WriteInfos' -H 'User-Agent: Apache-HttpClient/4.1.1 (java 1.5)' --data-binary "$requeteSoap" $urlMediaPlus
        echo $requeteSoap > test.text
        $status = "OK"
        $action = "création"
        # on log ajoute les informations dans la base de données
        $timestamp = Get-Date -Format "yyyy-MM-dd hh:mm:ss"
        $reqinsertHist = "INSERT INTO projet_eni.historique (action, statut, timestamp, utilisateur, stagiaire, typeCompte, site, formation)"
        $reqinsertHist += " VALUES('" + $action + "', '" + $status + "', '" + $timestamp +"', '" + $ADusername + "', '" + $script:NomSSCaratSpec + " " + $script:PrenomSSCaratSpec + "', '" + $script:plateformeBase +"', '" + $script:site + "', '" + $script:formation + "');"
        makeRequest $reqinsertHist
    }
}