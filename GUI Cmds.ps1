#1)	Empty Window Box

$basicForm = New-Object System.Windows.Forms.Form
$basicForm.showDialog()

#2)	Specific Window box

$folderForm = New-Object System.Windows.Forms.Form
$pathTextBox = New-Object System.Windows.Forms.TextBox

$pathTextBox.Location = '23,23'
$pathTextBox.Size = '150,23'

$folderForm.Controls.Add($pathTextBox)
$folderForm.showDialog()

#3)	Button Addition

$selectButton = New-Object System.Windows.Forms.Button
$selectButton.Text = "select"
$selectButton.Location = '196,23'
$folderForm.Controls.Add($selectButton)
$folderForm.showDialog()

#4)	Action for button


$folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog

$selectButton.Add_Click({ 
    $folderBrowser.showDialog() 
    $pathTextBox.Text = $folderBrowser.SelectedPath 
})
$pathTextBox.ReadOnly = $true

$folderForm.showDialog()

$selectButton.Text