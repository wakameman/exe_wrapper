Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$configPath = Join-Path -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition) -ChildPath "config.json"

if (-Not (Test-Path $configPath)) {
    [System.Windows.Forms.MessageBox]::Show("confg.json not found. $configPath", "error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    exit
}

$config = Get-Content $configPath -Raw | ConvertFrom-Json

$exePath = $config.ExePath
$defArguments = $config.DefaultArguments

# create form
$form = New-Object System.Windows.Forms.Form
$form.Text = "exe wapper"
$form.Size = New-Object System.Drawing.Size(600, 120)
$form.StartPosition = "CenterScreen"

# "arguments" Label
$argLabel = New-Object System.Windows.Forms.Label
$argLabel.Text = "Arguments:"
$argLabel.Location = New-Object System.Drawing.Point(10, 15)
$argLabel.Size = New-Object System.Drawing.Size(70, 20)
$form.Controls.Add($argLabel)

# argument textbox
$inputBox = New-Object System.Windows.Forms.TextBox
$inputBox.Location = New-Object System.Drawing.Point(85, 12)
$inputBox.Size = New-Object System.Drawing.Size(390, 20)
$form.Controls.Add($inputBox)

# execution button
$button = New-Object System.Windows.Forms.Button
$button.Text = "execution"
$button.Location = New-Object System.Drawing.Point(490, 10)
$button.Size = New-Object System.Drawing.Size(75, 23)
$form.Controls.Add($button)

$button.Add_Click({
    if ([string]::IsNullOrWhiteSpace($inputBox.Text)) {
        [System.Windows.Forms.MessageBox]::Show("command is empty()", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
        return
    }
    $inputArguments = $inputBox.Text.Trim()
    $command = "$exePath $defArguments $inputArguments"
    $cmdArgs = "/c `"$command & pause`""

    Start-Process -FilePath "cmd.exe" -ArgumentList $cmdArgs
})

# show form
[void]$form.ShowDialog()
