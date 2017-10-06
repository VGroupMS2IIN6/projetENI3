Param($MDP)

Function Chiffrement ($MDP)
{
[Byte[]] $key = (1..16)

$MDPsecure = $MDP | ConvertTo-SecureString -AsPlainText -Force
$MDPchiffre = ConvertFrom-SecureString -key $key -SecureString $MDPSecure
return $MDPchiffre
}