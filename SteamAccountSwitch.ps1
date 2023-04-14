###########################################################
#####################!! EDIT BELOW !!######################

# 1.
# Add your steam login account names here,
# and seperate them with commas.
$ACCOUNT_NAMES = # Index starts from 0
  "account0",   # Index 0
  "account1",   # Index 1
  "account2",   # Index 2
  "account3",   # Index 3
  "account4"    # Index 4

# 2. (Optional)
# Add a prompt to each account
# if you like.
## For example, streammer don't want to leak hi account name,
## or you have too many accounts to recognize each of them.
# Leave it blank if you don't want to.
# The prompt will replace the account name in the dialog.
$ACCOUNT_PROMPTS =
  "My account",       # Prompt for account0
  "",                 # No prompt for account1. Account name of account1 will show up.
  "Alice's account"   # Prompt for account2

# If you don't want to set prompt for every account,
# you can set prompt for your accounts seperately like this.
$ACCOUNT_PROMPTS[3] = "My brother's account"               # Prompt of account3
$ACCOUNT_PROMPTS[4] = "My girlfriend's (if you have one)"  # Prompt of account4

###########################################################
###########################################################

# Steam Account Switch
# PowerShell Ver. For Windows Only

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

foreach($a in 1..$ACCOUNT_NAMES.Length) {
  if ($ACCOUNT_PROMPTS[$a-1]) {
    $item = $ACCOUNT_PROMPTS[$a-1]
  } else {
    $item = $ACCOUNT_NAMES[$a-1]
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

$account_name = $ACCOUNT_NAMES[$main_listBox.SelectedIndices]

reg add "HKCU\Software\Valve\Steam" /v AutoLoginUser /t REG_SZ /d $account_name /f
reg add "HKCU\Software\Valve\Steam" /v RememberPassword /t REG_DWORD /d 1 /f

start steam://open/main
