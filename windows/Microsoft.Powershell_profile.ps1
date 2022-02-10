# Bash style complete
Set-PSReadlineKeyHandler -Key Tab -Function Complete
# Standard Powershell complete
# Set-PSReadlineKeyHandler -Key Tab -Function TabCompleteNext

# Theme
# Host Foreground
$Host.PrivateData.ErrorForegroundColor = 'Red'
$Host.PrivateData.WarningForegroundColor = 'Yellow'
$Host.PrivateData.DebugForegroundColor = 'Green'
$Host.PrivateData.ProgressForegroundColor = 'Gray'

# Check for PSReadline
if (Get-Module -ListAvailable -Name "PSReadline") {
    $options = Get-PSReadlineOption

    # Foreground
    $options.CommandForegroundColor = 'Yellow'
    $options.ContinuationPromptForegroundColor = 'DarkYellow'
    $options.DefaultTokenForegroundColor = 'DarkYellow'
    $options.EmphasisForegroundColor = 'Cyan'
    $options.ErrorForegroundColor = 'Red'
    $options.KeywordForegroundColor = 'Green'
    $options.MemberForegroundColor = 'DarkGreen'
    $options.NumberForegroundColor = 'DarkGreen'
    $options.OperatorForegroundColor = 'DarkCyan'
    $options.ParameterForegroundColor = 'DarkCyan'
    $options.VariableForegroundColor = 'Green'
}

# get-time
# http://stackoverflow.com/questions/138144/what-s-in-your-powershell-profile-ps1-file
function Get-Time { return $(get-date | foreach-object { $_.ToLongTimeString() } ) }

# Print PS Version
$major = (Get-Host).Version.Major
$major = "$major" + "."
$minor = (Get-Host).Version.Minor
Write-Host "PowerShell v$major$minor"
Remove-Variable major
Remove-Variable minor

function prompt {
    # Write the time
    write-host "[" -noNewLine
    write-host $(Get-Time) -foreground yellow -noNewLine
    write-host "] " -noNewLine
    # Write the path
    write-host $($(Get-Location).Path.replace($home, "~").replace("\", "/")) -foreground green -noNewLine
    write-host $(if ($nestedpromptlevel -ge 1) { '>>' }) -noNewLine
    return "> "
}

# Shows a line to make it easy to see command inputs
$width = ($Host.UI.RawUI.WindowSize.Width - 2 - $(Get-Location).ToString().Length)
$hr = New-Object System.String @('-', $width)
Write-Host -ForegroundColor Red $(Get-Location) $hr

# im for Import-Module
Set-Alias im Import-Module

# Delete ls alias so we can use it with some more 'flair'
Remove-Item alias:ls -Force

# Coloured LS
function ls {
    param ($dir = ".", $all = $false)

    $origFg = $host.ui.rawui.foregroundColor
    if ( $all ) { $toList = Get-ChildItem -force $dir }
    else { $toList = Get-ChildItem $dir }

    Foreach ($Item in $toList) {
        Switch ($Item.Extension) {
            ".Exe" { $host.ui.rawui.foregroundColor = "Yellow" }
            ".cmd" { $host.ui.rawui.foregroundColor = "Red" }
            ".msh" { $host.ui.rawui.foregroundColor = "Red" }
            ".vbs" { $host.ui.rawui.foregroundColor = "Red" }
            ".ps1" { $host.ui.rawui.foregroundColor = "Red" }
            ".txt" { $host.ui.rawui.foregroundColor = "Cyan" }
            ".json" { $host.ui.rawui.foregroundColor = "Cyan" }
            ".csv" { $host.ui.rawui.foregroundColor = "Cyan" }
            ".xml" { $host.ui.rawui.foregroundColor = "Cyan" }
            ".log" { $host.ui.rawui.foregroundColor = "Cyan" }
            ".conf" { $host.ui.rawui.foregroundColor = "Cyan" }
            ".sys" { $host.ui.rawui.foregroundColor = "Gray" }
            Default { $host.ui.rawui.foregroundColor = $origFg }
        }
        if ($item.Mode.StartsWith("d")) { $host.ui.rawui.foregroundColor = "Green" }
        if ($item.Mode.StartsWith("s")) { $host.ui.rawui.foregroundColor = "Gray" }
        $item
    }
    $host.ui.rawui.foregroundColor = $origFg
}

function lsa {
    param ( $dir = ".")
    ls $dir $true
}

function la { Get-ChildItem -force }

# Change title of the prompt
$host.ui.RawUI.WindowTitle = "Running as user $env:UserName"
if ( (
        New-Object Security.Principal.WindowsPrincipal (
            [Security.Principal.WindowsIdentity]::GetCurrent())
    ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    # Admin-mark in WindowTitle
    $Host.UI.RawUI.WindowTitle = "[Admin] " + $Host.UI.RawUI.WindowTitle

    # Admin-mark on prompt
    Write-Host "[" -nonewline -foregroundcolor DarkGray
    Write-Host "Admin" -nonewline -foregroundcolor Red
    Write-Host "] " -nonewline -foregroundcolor DarkGray
}

Set-Location c:\