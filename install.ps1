#requires -Version 5
<#
.SYNOPSIS
  Install the unified-review-suite into Cursor.
.DESCRIPTION
  Deploys skills, rule, command, and (optionally) hooks into the Cursor config dir.
  Default scope is personal (~/.cursor), so the suite is available across all projects.
.PARAMETER ProjectPath
  Install into a project's .cursor/ instead of the personal ~/.cursor/.
.PARAMETER SkipHooks
  Do not install/merge the automation hook.
.EXAMPLE
  ./install.ps1
.EXAMPLE
  ./install.ps1 -ProjectPath "C:\repos\my-app"
#>
param(
  [string]$ProjectPath,
  [switch]$SkipHooks
)

$ErrorActionPreference = "Stop"
$src = Split-Path -Parent $MyInvocation.MyCommand.Path

if ($ProjectPath) {
  $base = Join-Path $ProjectPath ".cursor"
  $scope = "project ($ProjectPath)"
} else {
  $base = Join-Path $env:USERPROFILE ".cursor"
  $scope = "personal (~/.cursor)"
}

Write-Host "Installing unified-review-suite -> $scope" -ForegroundColor Cyan

# 1) Skills
$skillsDst = Join-Path $base "skills"
New-Item -ItemType Directory -Force -Path $skillsDst | Out-Null
Get-ChildItem -Directory (Join-Path $src "skills") | ForEach-Object {
  Copy-Item -Recurse -Force $_.FullName $skillsDst
  Write-Host "  skill  -> $($_.Name)"
}

# 2) Rules
$rulesDst = Join-Path $base "rules"
New-Item -ItemType Directory -Force -Path $rulesDst | Out-Null
Get-ChildItem -File (Join-Path $src "rules") -Filter *.mdc | ForEach-Object {
  Copy-Item -Force $_.FullName $rulesDst
  Write-Host "  rule   -> $($_.Name)"
}

# 3) Commands
$cmdDst = Join-Path $base "commands"
New-Item -ItemType Directory -Force -Path $cmdDst | Out-Null
Get-ChildItem -File (Join-Path $src "commands") -Filter *.md | ForEach-Object {
  Copy-Item -Force $_.FullName $cmdDst
  Write-Host "  command-> /$([System.IO.Path]::GetFileNameWithoutExtension($_.Name))"
}

# 4) Hooks (safe merge)
if (-not $SkipHooks) {
  $hookSrc = Join-Path $src "hooks\hooks.json"
  $hookDst = Join-Path $base "hooks.json"
  $ours = Get-Content $hookSrc -Raw | ConvertFrom-Json
  if (-not (Test-Path $hookDst)) {
    Copy-Item -Force $hookSrc $hookDst
    Write-Host "  hooks  -> installed (new hooks.json)"
  } else {
    $bak = "$hookDst.bak.$(Get-Date -Format yyyyMMddHHmmss)"
    Copy-Item -Force $hookDst $bak
    $existing = Get-Content $hookDst -Raw | ConvertFrom-Json
    if (-not $existing.hooks) { $existing | Add-Member -NotePropertyName hooks -NotePropertyValue ([pscustomobject]@{}) -Force }
    foreach ($evt in $ours.hooks.PSObject.Properties.Name) {
      $merged = @()
      if ($existing.hooks.PSObject.Properties.Name -contains $evt) { $merged = @($existing.hooks.$evt) }
      $sigs = $merged | ForEach-Object { ($_ | ConvertTo-Json -Compress -Depth 20) }
      foreach ($entry in @($ours.hooks.$evt)) {
        if ($sigs -notcontains ($entry | ConvertTo-Json -Compress -Depth 20)) { $merged += $entry }
      }
      $existing.hooks | Add-Member -NotePropertyName $evt -NotePropertyValue $merged -Force
    }
    ($existing | ConvertTo-Json -Depth 20) | Set-Content -Encoding UTF8 $hookDst
    Write-Host "  hooks  -> merged into existing hooks.json (backup: $bak)"
  }
} else {
  Write-Host "  hooks  -> skipped (-SkipHooks)"
}

Write-Host "Done. Restart Cursor or toggle Skills if the suite does not appear." -ForegroundColor Green
