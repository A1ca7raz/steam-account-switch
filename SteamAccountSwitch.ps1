$ACCOUNT_LIST =
  "account1",
  "account2"

$ACCOUNT_PROMPTS =
  "",
  ""

$motd = "Steam Account Switch"
$prompt = "Select the login account:"

# Draw Dialog
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$mainForm = New-Object System.Windows.Forms.Form
$mainForm.Text = $motd
$mainForm.Size = New-Object System.Drawing.Size(300,200)
$mainForm.StartPosition = 'CenterScreen'

$main_okButton = New-Object System.Windows.Forms.Button
$main_okButton.Location = New-Object System.Drawing.Point(105,120)
$main_okButton.Size = New-Object System.Drawing.Size(80,30)
$main_okButton.Text = 'OK'
$main_okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$mainForm.AcceptButton = $main_okButton
$mainForm.Controls.Add($main_okButton)

$main_label = New-Object System.Windows.Forms.Label
$main_label.Location = New-Object System.Drawing.Point(10,20)
$main_label.Size = New-Object System.Drawing.Size(280,20)
$main_label.Text = $prompt
$mainForm.Controls.Add($main_label)

$main_listBox = New-Object System.Windows.Forms.ListBox
$main_listBox.Location = New-Object System.Drawing.Point(10,40)
$main_listBox.Size = New-Object System.Drawing.Size(260,20)
$main_listBox.Height = 80

ForEach($a in 1..$ACCOUNT_LIST.Length) {
  if ($ACCOUNT_PROMPTS[$a-1]) {
    $item = $ACCOUNT_PROMPTS[$a-1]
  } else {
    $item = $ACCOUNT_LIST[$a-1]
  }
  [void] $main_listBox.Items.Add($item)
}
$mainForm.Controls.Add($main_listBox)

# Main
$mainForm.Topmost = $true
$result = $mainForm.ShowDialog()

# Error process
if ($result -ne [System.Windows.Forms.DialogResult]::OK) {
  exit 1
}

# Switch account
Get-Process | Where-Object -FilterScript {$_.ProcessName -eq "steam"} | Stop-Process

$account_name = $ACCOUNT_LIST[$main_listBox.SelectedIndices]

reg add "HKCU\Software\Valve\Steam" /v AutoLoginUser /t REG_SZ /d %username% /f
reg add "HKCU\Software\Valve\Steam" /v RememberPassword /t REG_DWORD /d 1 /f

start steam://open/main
