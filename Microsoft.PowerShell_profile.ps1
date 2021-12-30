
#$global:DefaultUser = [System.Environment]::UserName

#Import-Module Get-ChildItemColor
# Set aliases to use the new Get-ChildItemColor cmdlets
#Set-Alias l Get-ChildItemColor -Option AllScope
#Set-Alias ls Get-ChildItemColorFormatWide -Option AllScope
#Set-Alias dir Get-ChildItemColorFormatWide -Option AllScope

# PSColor is useful but incompatible with Terminal-Icons
#Import-Module PSColor
Import-Module posh-git
Import-Module oh-my-posh
Import-Module Terminal-Icons

$GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $false

Set-PoshPrompt aliens

Remove-PSReadlineKeyHandler 'Ctrl+r'
Remove-PSReadlineKeyHandler 'Ctrl+t'
Import-Module PSFzf

# Powerline now has PSReadLine
#Import-Module PSReadLine
# Tab key completion
# Note: I don't like the way it handles tab completion - tab completion works fine without this
#Set-PSReadLineKeyHandler -Key Tab -Function Complete

Import-Module ZLocation
# Displays some additional information about ZLocation on start-up 
Write-Host -Foreground Green "`n[ZLocation] knows about $((Get-ZLocation).Keys.Count) locations.`n"

# Searching for commands with up/down arrow is really handy.  The
# option "moves to end" is useful if you want the cursor at the end
# of the line while cycling through history like it does w/o searching,
# without that option, the cursor will remain at the position it was
# when you used up arrow, which can be useful if you forget the exact
# string you started the search on.
#Set-PSReadLineOption -HistorySearchCursorMovesToEnd
#Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
#Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

# This key handler shows the entire or filtered history using Out-GridView. The
# typed text is used as the substring pattern for filtering. A selected command
# is inserted to the command line without invoking. Multiple command selection
# is supported, e.g. selected by Ctrl + Click.
Set-PSReadLineKeyHandler -Key F7 `
                         -BriefDescription History `
                         -LongDescription 'Show command history' `
                         -ScriptBlock {
    $pattern = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$pattern, [ref]$null)
    if ($pattern)
    {
        $pattern = [regex]::Escape($pattern)
    }

    $history = [System.Collections.ArrayList]@(
        $last = ''
        $lines = ''
        foreach ($line in [System.IO.File]::ReadLines((Get-PSReadLineOption).HistorySavePath))
        {
            if ($line.EndsWith('`'))
            {
                $line = $line.Substring(0, $line.Length - 1)
                $lines = if ($lines)
                {
                    "$lines`n$line"
                }
                else
                {
                    $line
                }
                continue
            }

            if ($lines)
            {
                $line = "$lines`n$line"
                $lines = ''
            }

            if (($line -cne $last) -and (!$pattern -or ($line -match $pattern)))
            {
                $last = $line
                $line
            }
        }
    )
    $history.Reverse()

    $command = $history | Out-GridView -Title History -PassThru
    if ($command)
    {
        [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert(($command -join "`n"))
    }
}

# Helper function to show Unicode characters
function U
{
    param
    (
        [int] $Code
    )
 
    if ((0 -le $Code) -and ($Code -le 0xFFFF))
    {
        return [char] $Code
    }
 
    if ((0x10000 -le $Code) -and ($Code -le 0x10FFFF))
    {
        return [char]::ConvertFromUtf32($Code)
    }
 
    throw "Invalid character code $Code"
}

# This function will help test whether your powerline font is working correctly.
# Run this in the console:
# Write-Host "$(U 0xE0B0) $(U 0x00B1) $(U 0xE0A0) $(U 0x27A6) $(U 0x2718) $(U 0x26A1) $(U 0x2699)"
# And you should see a line of stylized powerline icons, specifcally, what looks like:
# A "Play button" half triangle, a plus-minus sign - plus on top, minus underneath (dirty working directory), a git branch glyph, an arrow sign (detached head state), an "italic" x (previous command failed), a "lightning bolt" (elevated admin privileges), and a "gear" glyph
# Note: May not work in new powerline versions