Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

. "../ps/fg_1-1_DBUtils.ps1"

OpenDB

# recuperation de la liste des plateformes
$GetHistorique = MakeRequest "SELECT * FROM historique"

$text = $GetHistorique | ft -auto


Function MakeForm {
    $listForm = New-Object System.Windows.Forms.Form
    $listForm.Text = "Création de comptes stagiaires"
    $listForm.Size = New-Object System.Drawing.Size(1000,700)
    $listForm.StartPosition = "CenterScreen"
    
    $labelHistorique = New-Object System.Windows.Forms.Label
    $labelHistorique.Location = New-Object System.Drawing.Point(20,20)
    $labelHistorique.Size = New-Object System.Drawing.Size(400,22)
    $labelHistorique.Text = "Historique de création des comptes"

   
    $richtextBox = New-Object System.Windows.Forms.RichTextBox 
    $richtextBox.Location = New-Object System.Drawing.Point(50,50) 
    $richtextBox.Size = New-Object System.Drawing.Size(880,500)
    $richTextBox.Text = $richTextBox.Text.Clear

    	foreach ($line in $GetHistorique) {
		$richTextBox.Appendtext(($line | Select * | Out-String ))
	}


    $ButtonRetour = New-Object System.Windows.Forms.Button
    $ButtonRetour.Location = New-Object System.Drawing.Point(30,580)
    $ButtonRetour.Size = New-Object System.Drawing.Size(150,60)
    $ButtonRetour.Text = "Retour"
    $ButtonRetour.Add_Click({$script:listForm.Close()})
    # la touche echap est mappée sur retour
    $script:listForm.CancelButton = $ButtonRetour


    $listForm.Controls.Add($labelHistorique)
    $listForm.Controls.Add($ButtonRetour)
    $listform.Controls.Add($richtextBox) 

    # Afficher la fenetre
    $listForm.ShowDialog()
}

MakeForm

CloseDB