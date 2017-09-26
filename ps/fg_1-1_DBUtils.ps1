# Chargement du pilote .NET pour MySQL
Add-Type -Path '..\libs\MySql.Data.dll'

$connexion = ConvertFrom-StringData (Get-Content '..\config\connexion.properties' -raw)

# Creation de l'instance, connexion à la base de données  
$connexionString = "server=" + $connexion.'server'
$connexionString += ";port=" + $connexion.'port'
$connexionString += ";uid=" + $connexion.'user'
$connexionString += ";pwd=" + $connexion.'pass'
$connexionString += ";database=" + $connexion.db
$connexionString += ";Pooling=False"
$mysql = New-Object MySql.Data.MySqlClient.MySqlConnection($connexionString)

function OpenDB() {
    $script:mysql.Open()
}

function CloseDB() {
    $script:mysql.Close()
}

function MakeRequest($request) {
    $command = New-Object Mysql.Data.MysqlClient.MySqlCommand($request,$script:mysql)  
    $dataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($command)
    $dataSet = New-Object System.Data.DataSet
    $recordCount = $dataAdapter.Fill($dataSet, "data")
    $result = $dataSet.Tables["data"]
    return $result
}