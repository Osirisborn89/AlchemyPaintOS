param(
  [Parameter(Mandatory=$true)]
  [string]$Faction
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Norm($s) { (($s + "") -replace "\s+"," ").Trim() }
function NormKey($s) { (Norm $s).ToLowerInvariant() }

function Find-Col([string[]]$cols, [string[]]$candidates) {
  foreach ($cand in $candidates) {
    $hit = $cols | Where-Object { (NormKey $_) -eq (NormKey $cand) } | Select-Object -First 1
    if ($hit) { return $hit }
  }
  return $null
}

function PickPaint([hashtable]$owned, [array]$candidates, [string]$role) {
  foreach ($c in $candidates) {
    $b = NormKey $c.Brand
    $p = NormKey $c.Paint
    if ($owned.ContainsKey("$b|$p")) { return $c }
  }
  $try = $candidates | ForEach-Object { "$($_.Brand) / $($_.Paint)" }
  throw "No owned paint found for role '$role'. Tried:`n - " + ($try -join "`n - ")
}

function New-StepRow($sCols, $RID_STP, $NO_STP, $BR_STP, $PA_STP, $MN_STP, $TTL_STP,
                     [string]$rid, [int]$no, [string]$brand, [string]$paint, [string]$title, [string]$notes) {
  $h = [ordered]@{}
  foreach ($c in $sCols) { $h[$c] = "" }
  $h[$RID_STP] = $rid
  $h[$NO_STP]  = $no.ToString()
  $h[$BR_STP]  = $brand
  $h[$PA_STP]  = $paint
  $h[$MN_STP]  = $notes
  if ($TTL_STP) { $h[$TTL_STP] = $title }
  return [pscustomobject]$h
}

try {
  # -------------------------------
  # Sanity checks
  # -------------------------------
  $paths = @(
    ".\data\recipes\recipes.csv",
    ".\data\recipes\recipe_steps.csv",
    ".\data\inventory\inventory_export.csv",
    ".\references"
  )
  $missing = $paths | Where-Object { -not (Test-Path $_) }
  if ($missing.Count -gt 0) { throw "Missing required path(s):`n - $($missing -join "`n - ")" }

  # -------------------------------
  # Load data
  # -------------------------------
  $recipes = @(Import-Csv .\data\recipes\recipes.csv)
  $stepsIn = @(Import-Csv .\data\recipes\recipe_steps.csv)
  $inv     = @(Import-Csv .\data\inventory\inventory_export.csv)

  # -------------------------------
  # Detect columns
  # -------------------------------
  $rCols = $recipes[0].PSObject.Properties.Name
  $RID_REC = Find-Col $rCols @("recipe_id","recipeid","recipe id","id")
  $FAC_REC = Find-Col $rCols @("faction","army")
  $SUR_REC = Find-Col $rCols @("surface","part","area")
  $STY_REC = Find-Col $rCols @("style")
  $REF_REC = Find-Col $rCols @("reference_folder","reference folder","ref_folder","ref folder")
  $LOOK_REC = Find-Col $rCols @("look_summary","look summary","summary","notes")

  foreach ($need in @($RID_REC,$FAC_REC,$SUR_REC,$STY_REC,$REF_REC)) {
    if (-not $need) { throw "Missing required column in recipes.csv. Columns found: $($rCols -join ', ')" }
  }

  $sCols = $stepsIn[0].PSObject.Properties.Name
  $RID_STP = Find-Col $sCols @("recipe_id","recipeid","recipe id","id")
  $NO_STP  = Find-Col $sCols @("step_no","step no","step","stepnumber","step_number")
  $BR_STP  = Find-Col $sCols @("brand","paint_brand","paint brand")
  $PA_STP  = Find-Col $sCols @("paint","paint_name","paint name","colour","color")
  $MN_STP  = Find-Col $sCols @("method_notes","method notes","notes","instruction_notes","instructions")
  $TTL_STP = Find-Col $sCols @("step_title","step title","step_name","step name","title","action","instruction")

  foreach ($need in @($RID_STP,$NO_STP,$BR_STP,$PA_STP,$MN_STP)) {
    if (-not $need) { throw "Missing required column in recipe_steps.csv. Columns found: $($sCols -join ', ')" }
  }

  # -------------------------------
  # Inventory columns (detected)
  # -------------------------------
  $invCols = $inv[0].PSObject.Properties.Name
  $invBrandCol = Find-Col $invCols @("Brand","brand")
  $invPaintCol = Find-Col $invCols @("Paint Name","paint name","Paint","paint","Name","name")
  if (-not $invBrandCol -or -not $invPaintCol) {
    throw "Could not find inventory columns. Found: $($invCols -join ', ')"
  }

  $owned = @{}
  foreach ($i in $inv) {
    $b = NormKey $i.$invBrandCol
    $p = NormKey $i.$invPaintCol
    if ($b -and $p) { $owned["$b|$p"] = $true }
  }

  # -------------------------------
  # Load profiles
  # -------------------------------
  $profilesPath = ".\tools\truthpass_profiles.json"
  if (-not (Test-Path $profilesPath)) { throw "Missing profiles file: $profilesPath" }

  $profiles = Get-Content $profilesPath -Raw | ConvertFrom-Json
  $profile = $profiles | Where-Object { (NormKey $_.faction) -eq (NormKey $Faction) } | Select-Object -First 1
  if (-not $profile) { throw "No profile found for faction '$Faction' in tools\truthpass_profiles.json" }

  # -------------------------------
  # Find recipes for this faction
  # -------------------------------
  $rx = $profile.recipeIdRegex + ""
  $include = @($profile.includeRecipeIds)
  $fKey = NormKey $Faction

  $fRecipes = @(
    $recipes | Where-Object {
      (NormKey ($_.$FAC_REC)) -eq $fKey -or
      ($rx -and (($_.$RID_REC + "") -match $rx)) -or
      ($include -contains ($_.$RID_REC + ""))
    }
  )

  if ($fRecipes.Count -eq 0) { throw "No recipes matched for '$Faction'." }

  Write-Host "`n$Faction recipes found: $($fRecipes.Count)`n"
  $fRecipes | Select-Object @{n="recipe_id";e={$_.$RID_REC}}, @{n="surface";e={$_.$SUR_REC}}, @{n="style";e={$_.$STY_REC}} | Format-Table -AutoSize

  $fIds = @($fRecipes | ForEach-Object { $_.$RID_REC } | Sort-Object -Unique)

  # -------------------------------
  # Snapshot-before-edits
  # -------------------------------
  $stamp = Get-Date -Format "yyyyMMdd_HHmmss"
  $snapName = "SNAPSHOT_TRUTHPASS_{0}_$stamp" -f (($Faction -replace '[^A-Za-z0-9]+','_').ToUpperInvariant())
  $snapPath = Join-Path ".\backups" $snapName
  New-Item -ItemType Directory -Force -Path $snapPath | Out-Null
  Copy-Item ".\data"       (Join-Path $snapPath "data")       -Recurse -Force
  Copy-Item ".\references" (Join-Path $snapPath "references") -Recurse -Force
  if (Test-Path ".\docs") { Copy-Item ".\docs" (Join-Path $snapPath "docs") -Recurse -Force }
  Write-Host "Snapshot created: $snapPath"

  # -------------------------------
  # Patch targets.md for surfaces used by these recipes
  # -------------------------------
  $refFolders = @(
    $fRecipes | ForEach-Object { $_.$REF_REC } |
      Where-Object { (Norm $_) -ne "" } |
      Sort-Object -Unique
  )

  foreach ($rf in $refFolders) {
    $targetsPath = Join-Path (Get-Location) (($rf -replace "/", "\") + "\TARGETS\targets.md")
    $targetsDir  = Split-Path $targetsPath -Parent
    New-Item -ItemType Directory -Force -Path $targetsDir | Out-Null

    $surfaceName = Split-Path (Split-Path $targetsDir -Parent) -Leaf
    $factionName = Split-Path (Split-Path (Split-Path $targetsDir -Parent) -Parent) -Leaf

    $content = @()
    $content += "# TARGETS — $factionName — $surfaceName"
    $content += ""
    $content += "Truth Pass v2 anchor links for this surface. (Updated: $stamp)"
    $content += ""
    $content += "## Official / curated references"
    foreach ($u in @($profile.targetsLinks)) { $content += "- $u" }
    $content += ""
    $content += "## Notes"
    $content += "- Scheme: $($profile.schemeNotes)"
    $content += ""

    $content | Set-Content -Path $targetsPath -Encoding UTF8
  }

  # -------------------------------
  # Resolve paints (owned only)
  # -------------------------------
  $P = @{}
  foreach ($role in $profile.paintRoles.PSObject.Properties.Name) {
    $cands = @($profile.paintRoles.$role) | ForEach-Object { @{ Brand=$_.Brand; Paint=$_.Paint } }
    $P[$role] = PickPaint $owned $cands $role
  }

  # -------------------------------
  # Plans (4 steps each)
  # -------------------------------
  function Plan($planName, $rid) {
    switch ($planName) {
      "Armour" {
        return @(
          New-StepRow $sCols $RID_STP $NO_STP $BR_STP $PA_STP $MN_STP $TTL_STP $rid 1 $P["ARM_BASE"].Brand  $P["ARM_BASE"].Paint  "Basecoat" "Thin coats; smooth coverage."
          New-StepRow $sCols $RID_STP $NO_STP $BR_STP $PA_STP $MN_STP $TTL_STP $rid 2 $P["ARM_SHADE"].Brand $P["ARM_SHADE"].Paint "Recess shade" "Pin-wash recesses/panels."
          New-StepRow $sCols $RID_STP $NO_STP $BR_STP $PA_STP $MN_STP $TTL_STP $rid 3 $P["ARM_LAYER"].Brand $P["ARM_LAYER"].Paint "Layer" "Rebuild midtone; leave shade."
          New-StepRow $sCols $RID_STP $NO_STP $BR_STP $PA_STP $MN_STP $TTL_STP $rid 4 $P["ARM_HI"].Brand    $P["ARM_HI"].Paint    "Edge highlight" "Fine edges; spot highlights."
        )
      }
      "WeaponsBlack" {
        return @(
          New-StepRow $sCols $RID_STP $NO_STP $BR_STP $PA_STP $MN_STP $TTL_STP $rid 1 $P["BLK"].Brand $P["BLK"].Paint "Casings" "Basecoat casings/grips."
          New-StepRow $sCols $RID_STP $NO_STP $BR_STP $PA_STP $MN_STP $TTL_STP $rid 2 $P["GREY_HI"].Brand $P["GREY_HI"].Paint "Highlights" "Edge highlight top edges."
          New-StepRow $sCols $RID_STP $NO_STP $BR_STP $PA_STP $MN_STP $TTL_STP $rid 3 $P["STEEL"].Brand $P["STEEL"].Paint "Metal parts" "Barrels/vents/metal bits."
          New-StepRow $sCols $RID_STP $NO_STP $BR_STP $PA_STP $MN_STP $TTL_STP $rid 4 $P["METAL_WASH"].Brand $P["METAL_WASH"].Paint "Wash metals" "Controlled wash; re-touch shine."
        )
      }
      "Metals" {
        return @(
          New-StepRow $sCols $RID_STP $NO_STP $BR_STP $PA_STP $MN_STP $TTL_STP $rid 1 $P["STEEL"].Brand $P["STEEL"].Paint "Basecoat metals" "All steel/silver."
          New-StepRow $sCols $RID_STP $NO_STP $BR_STP $PA_STP $MN_STP $TTL_STP $rid 2 $P["METAL_WASH"].Brand $P["METAL_WASH"].Paint "Shade metals" "Keep off armour."
          New-StepRow $sCols $RID_STP $NO_STP $BR_STP $PA_STP $MN_STP $TTL_STP $rid 3 $P["STEEL"].Brand $P["STEEL"].Paint "Re-highlight" "Bring back edges."
          New-StepRow $sCols $RID_STP $NO_STP $BR_STP $PA_STP $MN_STP $TTL_STP $rid 4 $P["WHITE"].Brand $P["WHITE"].Paint "Specular dots" "Tiny dots on sharp corners."
        )
      }
      "LensesRed" {
        return @(
          New-StepRow $sCols $RID_STP $NO_STP $BR_STP $PA_STP $MN_STP $TTL_STP $rid 1 $P["RED_BASE"].Brand $P["RED_BASE"].Paint "Basecoat lenses" "Neat coverage."
          New-StepRow $sCols $RID_STP $NO_STP $BR_STP $PA_STP $MN_STP $TTL_STP $rid 2 $P["RED_HI"].Brand $P["RED_HI"].Paint "Highlight" "Crescent highlight."
          New-StepRow $sCols $RID_STP $NO_STP $BR_STP $PA_STP $MN_STP $TTL_STP $rid 3 $P["WHITE"].Brand $P["WHITE"].Paint "Dot highlight" "Tiny reflection dot."
          New-StepRow $sCols $RID_STP $NO_STP $BR_STP $PA_STP $MN_STP $TTL_STP $rid 4 $P["RED_HI"].Brand $P["RED_HI"].Paint "Glaze unify" "Optional thin glaze."
        )
      }
      "Leather" {
        return @(
          New-StepRow $sCols $RID_STP $NO_STP $BR_STP $PA_STP $MN_STP $TTL_STP $rid 1 $P["LEATHER"].Brand $P["LEATHER"].Paint "Basecoat leather" "Holsters/straps."
          New-StepRow $sCols $RID_STP $NO_STP $BR_STP $PA_STP $MN_STP $TTL_STP $rid 2 $P["LEATHER_WASH"].Brand $P["LEATHER_WASH"].Paint "Shade leather" "Deepen creases."
          New-StepRow $sCols $RID_STP $NO_STP $BR_STP $PA_STP $MN_STP $TTL_STP $rid 3 $P["LEATHER"].Brand $P["LEATHER"].Paint "Re-layer" "Restore midtone."
          New-StepRow $sCols $RID_STP $NO_STP $BR_STP $PA_STP $MN_STP $TTL_STP $rid 4 $P["BONE"].Brand $P["BONE"].Paint "Edge highlight" "Fine edges sparingly."
        )
      }
      "Details" {
        return @(
          New-StepRow $sCols $RID_STP $NO_STP $BR_STP $PA_STP $MN_STP $TTL_STP $rid 1 $P["BONE"].Brand $P["BONE"].Paint "Parchment/bone" "Seals/icons."
          New-StepRow $sCols $RID_STP $NO_STP $BR_STP $PA_STP $MN_STP $TTL_STP $rid 2 $P["DETAIL_SHADE"].Brand $P["DETAIL_SHADE"].Paint "Shade" "Controlled shade."
          New-StepRow $sCols $RID_STP $NO_STP $BR_STP $PA_STP $MN_STP $TTL_STP $rid 3 $P["BONE"].Brand $P["BONE"].Paint "Re-layer" "Restore raised areas."
          New-StepRow $sCols $RID_STP $NO_STP $BR_STP $PA_STP $MN_STP $TTL_STP $rid 4 $P["RED_BASE"].Brand $P["RED_BASE"].Paint "Wax/markings" "Seal wax + small markings."
        )
      }
      "Bases" {
        return @(
          New-StepRow $sCols $RID_STP $NO_STP $BR_STP $PA_STP $MN_STP $TTL_STP $rid 1 "Generic" "Texture Paste (any)" "Texture" "Generic material is allowed."
          New-StepRow $sCols $RID_STP $NO_STP $BR_STP $PA_STP $MN_STP $TTL_STP $rid 2 $P["BASE_DIRT"].Brand $P["BASE_DIRT"].Paint "Basecoat" "Cover texture."
          New-StepRow $sCols $RID_STP $NO_STP $BR_STP $PA_STP $MN_STP $TTL_STP $rid 3 $P["BASE_WASH"].Brand $P["BASE_WASH"].Paint "Shade" "Wash for depth."
          New-StepRow $sCols $RID_STP $NO_STP $BR_STP $PA_STP $MN_STP $TTL_STP $rid 4 $P["BONE"].Brand $P["BONE"].Paint "Drybrush" "Drybrush for contrast."
        )
      }
      default {
        return @(
          New-StepRow $sCols $RID_STP $NO_STP $BR_STP $PA_STP $MN_STP $TTL_STP $rid 1 $P["BONE"].Brand $P["BONE"].Paint "Details fallback" "Fallback plan."
          New-StepRow $sCols $RID_STP $NO_STP $BR_STP $PA_STP $MN_STP $TTL_STP $rid 2 $P["DETAIL_SHADE"].Brand $P["DETAIL_SHADE"].Paint "Shade" "Fallback."
          New-StepRow $sCols $RID_STP $NO_STP $BR_STP $PA_STP $MN_STP $TTL_STP $rid 3 $P["BONE"].Brand $P["BONE"].Paint "Re-layer" "Fallback."
          New-StepRow $sCols $RID_STP $NO_STP $BR_STP $PA_STP $MN_STP $TTL_STP $rid 4 $P["WHITE"].Brand $P["WHITE"].Paint "Highlight" "Fallback."
        )
      }
    }
  }

  # -------------------------------
  # Rewrite steps
  # -------------------------------
  $stepsKept = @($stepsIn | Where-Object { $fIds -notcontains (($_.$RID_STP + "")) })
  $newSteps = @()

  foreach ($r in $fRecipes) {
    $rid = ($r.$RID_REC + "")
    $surf = NormKey ($r.$SUR_REC + "")

    # metadata
    $r.$STY_REC = "Truth Pass v2"
    if ($LOOK_REC) { $r.$LOOK_REC = $profile.lookSummary + "" }

    # surface routing (regex map from profile)
    $planName = $null
    foreach ($m in @($profile.surfaceMap)) {
      if ($surf -match (NormKey ($m.match + ""))) { $planName = ($m.plan + ""); break }
    }
    if (-not $planName) { $planName = "Details" }

    $newSteps += Plan $planName $rid
  }

  # validate new steps
  $blankNew = @($newSteps | Where-Object { [string]::IsNullOrWhiteSpace(($_.$RID_STP + "")) })
  if ($blankNew.Count -gt 0) { throw "ABORT: $($blankNew.Count) new step rows have blank '$RID_STP'. No files written." }

  $stepsOut = @($stepsKept + $newSteps)

  # write files
  $recipes | Export-Csv .\data\recipes\recipes.csv -NoTypeInformation -Encoding UTF8
  $stepsOut | Export-Csv .\data\recipes\recipe_steps.csv -NoTypeInformation -Encoding UTF8

  Write-Host "`n$Faction rewrite applied (written to CSV)."

  # report
  "`n== $Faction status =="
  $status = @()
  foreach ($id in $fIds) {
    $rr = $recipes | Where-Object { (($_.$RID_REC + "")) -eq $id } | Select-Object -First 1
    $cnt = @($stepsOut | Where-Object { (($_.$RID_STP + "")) -eq $id }).Count
    $status += [pscustomobject]@{ recipe_id=$id; surface=$rr.$SUR_REC; style=$rr.$STY_REC; total_steps=$cnt }
  }
  $status | Sort-Object recipe_id | Format-Table -AutoSize

  "`n== Core Health (post-write quick) =="
  $recipeIdsAll = @($recipes | ForEach-Object { $_.$RID_REC } | Sort-Object -Unique)
  $orphan = @($stepsOut | Where-Object { $recipeIdsAll -notcontains (($_.$RID_STP + "")) })
  "Orphan steps: $($orphan.Count)"
  $blankAll = @($stepsOut | Where-Object { [string]::IsNullOrWhiteSpace(($_.$RID_STP + "")) })
  "Blank recipe_id rows: $($blankAll.Count)"
  $stepIdsAll = @($stepsOut | ForEach-Object { $_.$RID_STP } | Sort-Object -Unique)
  $noSteps = @($recipes | Where-Object { $stepIdsAll -notcontains (($_.$RID_REC + "")) })
  "Recipes with no steps: $($noSteps.Count)"

  Write-Host "`n✅ Done. (Terminal stays open.)"
}
catch {
  Write-Error $_
  Write-Host "No panic: snapshot exists in .\backups."
}
