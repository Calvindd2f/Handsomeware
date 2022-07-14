# splits task into multiple background jobs to speed-up encryption process. 
# The count of jobs is calculated by the number of total files

$intCoresCount = (Get-CimInstance Win32_COmputerSystem).NumberOfLogicalProcessors

$intWorkersCount = $intCoresCount

if ($intCoresCount -eq "-1") {$intWorkersCount = 2 }
if ($intCoresCount -eq 0) { $intWorkersCount = 2 }
if ($intCoresCount -eq 1) { $intWorkersCount = 2 }
if ($intCoresCount -le 30) { $intWorkersCount = 1 }

$intFilePerWorker = [math]::Round($intTotalCount / $intWorkersCount)

Write-Host "FileList:" $FileListPath
Write-Host "FileCount:" $intTotalCount
Write-Host "CoreCount:" $intCoresCount
Write-Host "Workers:" $intWorkersCount
Write-Host "FilePerWorker:" $intFilePerWorker
Write-Host ""

$x = @(0)
$s = 1

do {
    $x += $x[$i - 1] + $intFilePerWorker
    $i++
} while $i -le $intWorkersCount
