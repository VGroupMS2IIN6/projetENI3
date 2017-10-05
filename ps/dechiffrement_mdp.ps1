Param($MDP)

Function Dechiffrement ($MDP)
{
$MDPSecure = $MDP | ConvertTo-SecureString
$MDPdechiffre = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($MDPSecure))
return $MDPdechiffre
}