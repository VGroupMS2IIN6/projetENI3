Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

. "../ps/fg_1-1_DBUtils.ps1"
. "../ps/fg_10-0_Authentification_PS.ps1"

OpenDB

# Initalisation des variables
$return = 0
$i = 0
#$ADusername = 0

# Définition de la fenêtre
$ListForm = New-Object System.Windows.Forms.Form
$ListForm.Text = "Application de création des comptes stagiaires"
$ListForm.Size = New-Object System.Drawing.Size(500,400)
$ListForm.StartPosition = "CenterScreen"
$ListForm.TopMost = $True

# Raccourcis clavier : entrée pour valider ; Esc pour quitter

$ListForm.KeyPreview = $True
$ListForm.Add_KeyDown({if ($_.KeyCode -eq "Enter") 
    {$x=$ListForm.Text;$ListForm.Close()}})
$ListForm.Add_KeyDown({if ($_.KeyCode -eq "Escape") 
    {$ListForm.Close()}})

## Définition des composants
# Texte "Nom d'utilisateur"
$LabelUsername = New-Object System.Windows.Forms.Label
$LabelUsername.Text = "Nom d'utilisateur"
$LabelUsername.Location = New-Object System.Drawing.Point(110,100)
$LabelUsername.Size = New-Object System.Drawing.Size(100,20)

# Champ texte Nom d'utilisateur
$TextBoxUsername = New-Object System.Windows.Forms.TextBox 
$TextBoxUsername.Location = New-Object System.Drawing.Size(110,120) 
$TextBoxUsername.Size = New-Object System.Drawing.Size(250,20) 

# Texte "Mot de passe"
$LabelPassword = New-Object System.Windows.Forms.Label
$LabelPassword.Text = "Mot de passe"
$LabelPassword.Location = New-Object System.Drawing.Point(110,160)
$LabelPassword.Size = New-Object System.Drawing.Size(100,20)

# Champ texte Nom d'utilisateur
$TextBoxPassword = New-Object System.Windows.Forms.TextBox 
$TextBoxPassword.Location = New-Object System.Drawing.Size(110,180) 
$TextBoxPassword.Size = New-Object System.Drawing.Size(250,20)
$TextBoxPassword.PasswordChar = '•'

# Bouton "OK"
$ButtonOK = New-Object System.Windows.Forms.Button
$ButtonOK.Location = New-Object System.Drawing.Point(280,220)
$ButtonOK.Size = New-Object System.Drawing.Size(80,25)
$ButtonOK.Text = "OK"
$ButtonOK.DialogResult = [System.Windows.Forms.DialogResult]::OK

# Affichage du logo ENI
$LogoENI = $(get-item ((get-location).path + '\ENILogo.png'))
$img = [System.Drawing.Image]::Fromfile($LogoENI);
$pictureBox = new-object Windows.Forms.PictureBox
$pictureBox.Location = New-Object System.Drawing.Point(0,262)
$pictureBox.Width = $img.Size.Width;
$pictureBox.Height = $img.Size.Height;
$pictureBox.Image = $img;

# Ajout des composants à la fenêtre
$ListForm.Controls.Add($LabelUsername)
$ListForm.Controls.Add($LabelPassword) 
$ListForm.Controls.Add($TextBoxUsername) 
$ListForm.Controls.Add($TextBoxPassword) 
$ListForm.Controls.Add($ButtonOK) 
$ListForm.Controls.Add($pictureBox)
$listForm.AcceptButton = $script:ButtonOK
#$ListForm.Add_Closing({$_.Cancel = $true})



do{

    # Afficher la fenetre
    $result = $ListForm.ShowDialog()


    switch ($result){
        ([System.Windows.Forms.DialogResult]::OK){
        echo "choix OK"

        $ADusername = $TextBoxUsername.text
        $ADpassword = $TextBoxPassword.text

        if ( controlUserCredentials -eq 'vrai'){
            Invoke-Expression "..\GUI\fa_2_Accueil.ps1"
            $i = 1
            break
            }
        else
            {[System.Windows.Forms.MessageBox]::Show("Nom d'utilisateur ou mot de passe incorect.", "Erreur")}
            break
        }
       ([System.Windows.Forms.DialogResult]::Cancel){
       echo "choix Cancel"
       $i = 1
       break
       } 
    }
} while($i -eq 0)

CloseDB