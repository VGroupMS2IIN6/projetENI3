function Remove-StringDiacritic
{

param
(
[ValidateNotNullOrEmpty()]
[Alias('Text')]
[System.String]$String,
[System.Text.NormalizationForm]$NormalizationForm = "FormD"
)
BEGIN
{
$Normalized = $String.Normalize($NormalizationForm)
$NewString = New-Object -TypeName System.Text.StringBuilder
}
PROCESS
{
$normalized.ToCharArray() | ForEach-Object -Process {
if ([Globalization.CharUnicodeInfo]::GetUnicodeCategory($psitem) -ne [Globalization.UnicodeCategory]::NonSpacingMark)
{
[void]$NewString.Append($psitem)
}
}
}
END
{
$NewString = [regex]::replace($NewString ,"[^a-zA-Z0-9_\-.]","")
Write-Output $($NewString -as [string])
}
}