# MIT License
# Copyright (c) 2020 pegaeae

#Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# https://ss64.com/ps/syntax-preference.html
$DebugPreference   = @("SilentlyContinue","Continue","Inquire","Stop")[1]
$WarningPreference = @("SilentlyContinue","Continue","Inquire","Stop")[1]
$ErrorActionPreference = @("Continue","Ignore","Inquire","SilentlyContinue","Stop","Suspend")[2]
$InformationPreference = @("Continue","Inquire","SilentlyContinue","Stop")[0]

# import modules
#[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

remove-module pegaeae-*
@(
    "$PSScriptRoot\ps-lib\pegaeae-fn-clickup.psm1",
    "$PSScriptRoot\ps-lib\pegaeae-fn-set-wallpaper.psm1",
    "$PSScriptRoot\ps-lib\pegaeae-fn-draw-tile.psm1"
    ) | ForEach { Import-Module "$_" }


$Token = (Get-Content -Path "$PSScriptRoot\config\clickup-token.json" | ConvertFrom-Json).Token
$UIItems = (Get-Content -Path "$PSScriptRoot\config\clickup-goals.json" | ConvertFrom-Json)

$goals = @()
$jsonTeams = Get-ClickUpTeams -Token $Token
(ConvertFrom-Json -InputObject $jsonTeams).teams | foreach {
    
    $teamName = $_.name

    $jsonGoals = Get-ClickUpGoals -Token $Token -TeamID $_.id
    (ConvertFrom-Json -InputObject $jsonGoals).goals | foreach {
        $goals += [pscustomobject]@{
            goalID= $_.id;
            team = $teamName;
            name = $_.name;
            start_date = ([datetime]'1970-01-01Z').AddMilliseconds($_.start_date);
            due_date = ([datetime]'1970-01-01Z').AddMilliseconds($_.due_date);
            percent_completed=[math]::Round($_.percent_completed*100);
            description = $_.description;
        }
    }
}

$goals | select -Property goalID,name,team, percent_completed | Format-Table | Out-String | Out-File -FilePath "$PSScriptRoot\cache\goals.txt"

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
$wallpaper = new-object System.Drawing.Bitmap (1920*2) , (1080)
$graphics = [System.Drawing.Graphics]::FromImage($wallpaper)
$graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
$graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias
$graphics.FillRectangle([System.Drawing.Brushes]::Black,0,0,$wallpaper.Width,$wallpaper.Height)

$UIItems | ForEach-Object {
    $ui = $_
    $goal = ($goals | Where-Object -Property goalID -match -Value $ui.goalID)

    $img = Get-Tile `
        -TileID $goal.goalID `        -Title ($goal.team + " ~ " + $goal.name).ToLower() `
        -StartDate $goal.start_date `
        -DueDate   $goal.due_date `
        -Desc $goal.description `
        -Progress $goal.percent_completed `
        -Width $ui.width `        -ProgressWidth $ui.progressWidth `        -Height $ui.height `        -ImgDir "$PSScriptRoot\cache"

    $graphics.DrawImage($img,$ui.left,$ui.top)
    
}
$dateFormat = new-object System.Drawing.StringFormat
$dateFormat.Alignment = [System.Drawing.StringAlignment]::Far
$dateFormat.LineAlignment = [System.Drawing.StringAlignment]::Near
$graphics.DrawString(
    ("dernière maj`r`n" + [datetime]::Now.toString("dd/MM/yyyy HH:mm:ss")), 
    (new-object System.Drawing.Font Tahoma,6), 
    [System.Drawing.Brushes]::Ivory, 
    [System.Drawing.RectangleF]::FromLTRB(0,0,(($wallpaper.width-1)-5),$wallpaper.Height), 
    $dateFormat)

$graphics.Dispose();
$wallpaper.Save("$PSScriptRoot\cache\clickup-wallpaper.png")
Set-WallPaper -Path ("$PSScriptRoot\cache\clickup-wallpaper.png") -Style Fit


# $goals | Sort-Object -Property @{Expression = "due_date"; Descending=$false},@{Expression = "percent_completed"; Descending=$true} | Where-Object -Property goaldID -EQ -Value $gid
# $goals | Sort-Object -Property due_date | Where-Object -Property percent_completed -LT -Value 100


#$jsonTasks = Get-ClickUpTasks -Token $Token -ListID 38336262
#(ConvertFrom-Json -InputObject $jsonTasks).tasks.count

#Set-WallPaper -Path "$filename" -Style Fit