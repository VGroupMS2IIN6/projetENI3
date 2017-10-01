# Chargement du pilote .NET pour MySQL
Add-Type -Path '..\libs\MySql.Data.dll'

$connexion = ConvertFrom-StringData (Get-Content '..\config\connexion.properties' -raw)

# Creation de l'instance, connexion Ã  la base de donnÃ©es  
$connexionString = "server=" + $connexion.'server'
$connexionString += ";port=" + $connexion.'port'
$connexionString += ";uid=" + $connexion.'user'
$connexionString += ";pwd=" + $connexion.'pass'
$connexionString += ";database=" + $connexion.db
$connexionString += ";Pooling=False"
$mysql = New-Object MySql.Data.MySqlClient.MySqlConnection($connexionString)
$connexionOK = $false

function OpenDB() {
    try {
        $script:mysql.Open()
        $script:connexionOK = $true
    } catch {
        $message = "Impossible de se connecter à la base de données`r`n`r`n"
        $message += "Erreur :`r`n"
        $message += $Error[0].ToString()
        [System.Windows.Forms.MessageBox]::Show($message, "Erreur de configuration", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

function CloseDB() {
    if($script:connexionOK) {
        $script:mysql.Close()
    }
}

function MakeRequest($request) {
    if(-not $script:connexionOK) {
        throw "Connexion non ouverte"
    }

    $command = New-Object Mysql.Data.MysqlClient.MySqlCommand($request,$script:mysql)  
    $dataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($command)
    $dataSet = New-Object System.Data.DataSet
    $recordCount = $dataAdapter.Fill($dataSet, "data")
    $result = $dataSet.Tables["data"]
    return $result
}

function RetreiveRow($rows, $field, $filter) {
    # on parcourt les lignes une part une, pour trouver celle qui correspond
    foreach($row in $rows)
    {
        if($row.$field -eq $filter)
        {
            return $row
        }
    }
}

function RecordLog($action, $status, $utilisateur, $nom, $prenom, $typeCompte, $site, $formation)
{

$timestamp = get-date -Format "yyyy-MM-dd hh:mm:ss"
$reqinsert = "INSERT INTO projet_eni.historique (`action`, statut, `timestamp`, utilisateur, stagiaire, typeCompte, site, formation)"
$reqinsert += " VALUES(" + $action + ", '" + $status + "', '" + $timestamp +"', '" + $utilisateur + "', '" + $nom + " " + $prenom + "', '" + $typeCompte +"', '" + $site + "', '" + $formation + "');"
makeRequest $reqinsert
}