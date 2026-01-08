# Warhammer Dashboard Repo Audit Runbook
# PowerShell 7.5.4+
# Purpose: Generate complete structure + file contents for AI inspection

$repoPath = "C:\Users\day_8\Desktop\Pproject"
$outputDir = "$repoPath\AUDIT_OUTPUT"
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

# Create output directory
New-Item -ItemType Directory -Path $outputDir -Force | Out-Null

Write-Host "=== Starting Repo Audit ===" -ForegroundColor Cyan
Write-Host "Repo: $repoPath" -ForegroundColor Cyan
Write-Host "Output: $outputDir" -ForegroundColor Cyan

# ============================================================================
# PART 1: Generate Tree Structure
# ============================================================================

Write-Host "`n[1/4] Generating folder tree structure..." -ForegroundColor Green

$treeFile = "$outputDir\01_REPO_STRUCTURE_$timestamp.txt"

function Get-TreeStructure {
    param([string]$Path, [int]$Depth = 0, [string]$Prefix = "")
    
    $items = @(Get-ChildItem -Path $Path -Force -ErrorAction SilentlyContinue | Sort-Object {$_.PSIsContainer}, Name)
    
    $itemCount = $items.Count
    for ($i = 0; $i -lt $itemCount; $i++) {
        $item = $items[$i]
        $isLast = ($i -eq $itemCount - 1)
        $currentPrefix = if ($isLast) { "└── " } else { "├── " }
        $nextPrefix = if ($isLast) { "    " } else { "│   " }
        
        Write-Output "$Prefix$currentPrefix$($item.Name)"
        
        if ($item.PSIsContainer -and $Depth -lt 10) {
            Get-TreeStructure -Path $item.FullName -Depth ($Depth + 1) -Prefix "$Prefix$nextPrefix"
        }
    }
}

Get-TreeStructure -Path $repoPath | Out-File -FilePath $treeFile -Encoding UTF8
Write-Host "✓ Tree structure saved: $treeFile" -ForegroundColor Green

# ============================================================================
# PART 2: Generate File Inventory (all files with size/type)
# ============================================================================

Write-Host "`n[2/4] Generating file inventory..." -ForegroundColor Green

$inventoryFile = "$outputDir\02_FILE_INVENTORY_$timestamp.csv"

Get-ChildItem -Path $repoPath -Recurse -Force -ErrorAction SilentlyContinue |
    Where-Object { -not $_.PSIsContainer } |
    Select-Object @{
        Name = "RelativePath"
        Expression = { $_.FullName -replace [regex]::Escape($repoPath), "" }
    },
    @{Name = "FileName"; Expression = { $_.Name } },
    @{Name = "Extension"; Expression = { $_.Extension } },
    @{Name = "SizeBytes"; Expression = { $_.Length } },
    @{Name = "SizeKB"; Expression = { [math]::Round($_.Length / 1KB, 2) } },
    @{Name = "CreatedUTC"; Expression = { $_.CreationTimeUtc } },
    @{Name = "ModifiedUTC"; Expression = { $_.LastWriteTimeUtc } } |
    Export-Csv -Path $inventoryFile -Encoding UTF8 -NoTypeInformation

Write-Host "✓ File inventory saved: $inventoryFile" -ForegroundColor Green

# ============================================================================
# PART 3: Extract All Text File Contents
# ============================================================================

Write-Host "`n[3/4] Extracting text file contents..." -ForegroundColor Green

$textContentFile = "$outputDir\03_ALL_TEXT_CONTENTS_$timestamp.txt"
$textExtensions = @('.txt', '.md', '.csv', '.json', '.yaml', '.yml', '.ps1', '.py', '.js', '.html', '.css', '.config', '.xml', '.log')

# Start header
"==============================================================================`n" +
"COMPLETE TEXT FILE CONTENTS INVENTORY`n" +
"Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`n" +
"Repository: $repoPath`n" +
"==============================================================================`n" |
    Out-File -FilePath $textContentFile -Encoding UTF8

# Iterate through all text files
$textFiles = Get-ChildItem -Path $repoPath -Recurse -Force -ErrorAction SilentlyContinue |
    Where-Object { $textExtensions -contains $_.Extension }

$count = 0
foreach ($file in $textFiles) {
    $count++
    $relativePath = $file.FullName -replace [regex]::Escape($repoPath), ""
    
    Write-Host "  [$count] Processing: $relativePath" -ForegroundColor Cyan
    
    # Header for this file
    "`n" +
    "──────────────────────────────────────────────────────────────────────────" +
    "`nFILE: $relativePath`n" +
    "Type: $($file.Extension) | Size: $([math]::Round($file.Length / 1KB, 2)) KB | Modified: $($file.LastWriteTimeUtc)`n" +
    "──────────────────────────────────────────────────────────────────────────`n" |
    Out-File -FilePath $textContentFile -Encoding UTF8 -Append
    
    # File content (with error handling)
    try {
        $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8 -ErrorAction Stop
        $content | Out-File -FilePath $textContentFile -Encoding UTF8 -Append
    } catch {
        "[ERROR: Could not read file - $_]" | Out-File -FilePath $textContentFile -Encoding UTF8 -Append
    }
    
    # Separator
    "`n`n" | Out-File -FilePath $textContentFile -Encoding UTF8 -Append
}

Write-Host "✓ Extracted $count text files: $textContentFile" -ForegroundColor Green

# ============================================================================
# PART 4: Summary Report
# ============================================================================

Write-Host "`n[4/4] Generating summary report..." -ForegroundColor Green

$summaryFile = "$outputDir\04_AUDIT_SUMMARY_$timestamp.txt"

$summary = @"
╔════════════════════════════════════════════════════════════════════════════╗
║                    REPO AUDIT SUMMARY REPORT                              ║
╚════════════════════════════════════════════════════════════════════════════╝

Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss UTC')
Repository: $repoPath

────────────────────────────────────────────────────────────────────────────

STATISTICS:

Total Files: $(($textFiles).Count)
Text Files: $count

────────────────────────────────────────────────────────────────────────────

OUTPUT FILES GENERATED:

1. 01_REPO_STRUCTURE_$timestamp.txt
   └─ Complete folder tree structure

2. 02_FILE_INVENTORY_$timestamp.csv
   └─ All files with metadata (size, dates, types)

3. 03_ALL_TEXT_CONTENTS_$timestamp.txt
   └─ Full contents of every text/code/config file

4. 04_AUDIT_SUMMARY_$timestamp.txt
   └─ This summary report

────────────────────────────────────────────────────────────────────────────

NEXT STEPS:

1. Copy all files from $outputDir to your upload location
2. Upload the output files to Perplexity Labs
3. Request audit with these files

────────────────────────────────────────────────────────────────────────────
"@

$summary | Out-File -FilePath $summaryFile -Encoding UTF8

Write-Host "✓ Summary saved: $summaryFile" -ForegroundColor Green

# ============================================================================
# COMPLETION
# ============================================================================

Write-Host "`n" -ForegroundColor Green
Write-Host "╔════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║                         AUDIT COMPLETE                                    ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Green

Write-Host "`nAll output files are ready in:" -ForegroundColor Cyan
Write-Host "  $outputDir" -ForegroundColor Yellow

Write-Host "`nFiles created:" -ForegroundColor Green
Get-ChildItem -Path $outputDir -File | ForEach-Object {
    Write-Host "  ✓ $($_.Name) ($([math]::Round($_.Length / 1KB, 2)) KB)" -ForegroundColor Green
}

Write-Host "`nYou can now:" -ForegroundColor Cyan
Write-Host "  1. Upload these files to Perplexity Labs" -ForegroundColor White
Write-Host "  2. Request: 'Audit this Warhammer 40k dashboard repo'" -ForegroundColor White
Write-Host "  3. I'll have complete visibility into structure + contents" -ForegroundColor White

Write-Host "`n" -ForegroundColor Green
