﻿function creation_mediaplus
{
    # on vérifie que ce n'est pas la dernière exécution
    if ($vide -eq $NULL)
    {
        .\curl.exe -i -s -k -X 'POST' -H 'Content-Type: text/xml;charset=UTF-8' -H 'SOAPAction: \"http://ENI.Editions.MEDIAplus.Web.Services/User_WriteInfos\"' -H 'User-Agent: Apache-HttpClient/4.1.1 (java 1.5)' --data-binary '<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:eni=\"http://ENI.Editions.MEDIAplus.Web.Services/\"><soapenv:Header><eni:CredentialHeader><!--Optional:--><eni:Separator></eni:Separator><!--Optional:--><eni:Login>eniecole-test</eni:Login><!--Optional:--><eni:Password>8Z1buPEgW</eni:Password><!--Optional:--><eni:NULLValue>#NULL</eni:NULLValue></eni:CredentialHeader></soapenv:Header><soapenv:Body><eni:User_WriteInfos><!--Optional:--><eni:ooParameters><eni:Id>-1</eni:Id><eni:Guid>00000000-0000-0000-0000-000000000000</eni:Guid><eni:IdOrg>2</eni:IdOrg><!--Optional:--><eni:FamilyName>NOMDEFAMILLE</eni:FamilyName><!--Optional:--><eni:FirstName>PRENOM</eni:FirstName><!--Optional:--><eni:Login>USERNAMEPERSO</eni:Login><eni:Title>MYSEXE</eni:Title><!--Optional:--><eni:Email>MONEMAIL</eni:Email><!--Optional:--><eni:Password>MYPASSWD</eni:Password><eni:StateMask>2</eni:StateMask><eni:UpdateOption>UpdateByLogin</eni:UpdateOption></eni:ooParameters></eni:User_WriteInfos></soapenv:Body></soapenv:Envelope>' 'http://www.mediapluspro.com/mediaplus69/ws/adodbservice.asmx'end-MailMessage -From "Eric Persan <epersan@eni-ecole.fr>" -To $mailNetAcad -Subject "ENI Ecole - Creation de comptes" -Body "Bonjour, veuillez trouver ci joint le fichier CSV contenant les comptes à créer" -Attachments "NetAcad.csv" -SmtpServer $SmtpENI
        $timestamp = Get-Date -Format "yyyy-MM-dd hh:mm:ss"
        $reqinsertHist = "INSERT INTO projet_eni.historique (action, statut, timestamp, utilisateur, stagiaire, typeCompte, site, formation)"
        $reqinsertHist += " VALUES('" + $action + "', '" + $status + "', '" + $timestamp +"', '" + $ADusername + "', '" + $nom + " " + $prenom + "', '" + $plateforme +"', '" + $site + "', '" + $formation + "');"
        makeRequest $reqinsertHist
    }
}