Param($MDPchiffre)

Function Dechiffrement ($MDPchiffre)
{
[Byte[]] $key = (1..16)
$MDPSecure = $MDPchiffre | ConvertTo-SecureString -Key $key
$MDPdechiffre = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($MDPSecure))
return $MDPdechiffre
}