Param($MDP)

Function Chiffrement ($MDP)
{
$MDPchiffre = $MDP | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString
return $MDPchiffre
}