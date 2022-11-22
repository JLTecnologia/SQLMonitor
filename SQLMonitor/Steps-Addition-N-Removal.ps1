﻿[CmdletBinding()]
Param (
    [Parameter(Mandatory=$false)]
    [ValidateSet("AddStep", "RemoveStep")]
    [String]$Action = "AddStep",

    [Parameter(Mandatory=$false)]
    [String]$StepName = "34__DropTable_resource_consumption_queries",
    
    [Parameter(Mandatory=$false)]
    [String[]]$AllSteps = @( "1__RemoveJob_CollectDiskSpace", "2__RemoveJob_CollectOSProcesses", "3__RemoveJob_CollectPerfmonData",
                "4__RemoveJob_CollectWaitStats", "5__RemoveJob_CollectXEvents", "6__RemoveJob_PartitionsMaintenance",
                "7__RemoveJob_PurgeTables", "8__RemoveJob_RemoveXEventFiles", "9__RemoveJob_RunWhoIsActive",
                "10__RemoveJob_CollectFileIOStats", "11__RemoveJob_RunBlitzIndex", "12__RemoveJob_UpdateSqlServerVersions",
                "13__RemoveJob_CheckInstanceAvailability", "14__DropProc_UspExtendedResults", "15__DropProc_UspCollectWaitStats",
                "16__DropProc_UspRunWhoIsActive", "17__DropProc_UspCollectXEventsResourceConsumption", "18__DropProc_UspPartitionMaintenance",
                "19__DropProc_UspPurgeTables", "20__DropProc_SpWhatIsRunning", "21__DropProc_UspActiveRequestsCount",
                "22__DropProc_UspCollectFileIOStats", "23__DropProc_UspEnablePageCompression", "24__DropProc_UspWaitsPerCorePerMinute",
                "25__DropView_VwPerformanceCounters", "26__DropView_VwOsTaskList", "27__DropView_VwWaitStatsDeltas",
                "28__DropView_vw_file_io_stats_deltas", "29__DropView_vw_resource_consumption", "30__DropXEvent_ResourceConsumption",
                "31__DropLinkedServer", "32__DropLogin_Grafana", "33__DropTable_ResourceConsumption",
                "34__DropTable_resource_consumption_queries", "35__DropTable_ResourceConsumptionProcessedXELFiles", "36__DropTable_WhoIsActive_Staging",
                "37__DropTable_WhoIsActive", "38__DropTable_PerformanceCounters", "39__DropTable_PurgeTable",
                "40__DropTable_PerfmonFiles", "41__DropTable_InstanceDetails", "42__DropTable_InstanceHosts",
                "43__DropTable_OsTaskList", "44__DropTable_BlitzWho", "45__DropTable_BlitzCache",
                "46__DropTable_ConnectionHistory", "47__DropTable_BlitzFirst", "48__DropTable_BlitzFirstFileStats",
                "49__DropTable_DiskSpace", "50__DropTable_BlitzFirstPerfmonStats", "51__DropTable_BlitzFirstWaitStats",
                "52__DropTable_BlitzFirstWaitStatsCategories", "53__DropTable_WaitStats", "54__DropTable_BlitzIndex",
                "55__DropTable_FileIOStats", "56__RemovePerfmonFilesFromDisk", "57__RemoveXEventFilesFromDisk",
                "58__DropProxy", "59__DropCredential", "60__RemoveInstanceFromInventory"
                ),

    [Parameter(Mandatory=$false)]
    [Bool]$PrintUserFriendlyFormat = $true,

    [Parameter(Mandatory=$false)]
    [String]$ScriptFile = 'F:\GitHub\SQLMonitor\SQLMonitor\Remove-SQLMonitor.ps1'
                          #'F:\GitHub\SQLMonitor\SQLMonitor\Install-SQLMonitor.ps1'
)

cls

# Placeholders
$finalSteps = @()

# Calculations
[int]$paramStepNo = $StepName -replace "__\w+", ''
$preStep = $paramStepNo-2;
if($Action -eq "AddStep") { # Add New Step
    $postStep = $paramStepNo-1;
    $lastStep = $AllSteps.Count-1;
}
else { # Remove Existing Step
    $postStep = $paramStepNo;
    $lastStep = $AllSteps.Count-1;
}

#"Pre-Steps" | Write-Host -ForegroundColor Green
$preNewSteps = @()
$preNewSteps += $AllSteps[0..$preStep]

#"`nAdd step '$StepName' here`n" | Write-Host -ForegroundColor Cyan

#"Post-Steps" | Write-Host -ForegroundColor Green
$postNewSteps = @()
if($Action -eq "AddStep") { # Add New Step
    $postNewSteps += $AllSteps[$postStep..$lastStep] | 
        ForEach-Object {[int]$stepNo = $_ -replace "__\w+", ''; $_.Replace("$stepNo", "$($stepNo+1)")}
    $finalSteps = $preNewSteps + @($StepName) + $postNewSteps
}
else { # Remove Existing Step
    $postNewSteps += $AllSteps[$postStep..$lastStep] | 
        ForEach-Object {[int]$stepNo = $_ -replace "__\w+", ''; $_.Replace("$stepNo", "$($stepNo-1)")}
    $finalSteps = $preNewSteps + $postNewSteps
}



"All New Steps => `n`n " | Write-Host -ForegroundColor Green
if($PrintUserFriendlyFormat) {
    foreach($num in $(0..$([Math]::Floor($finalSteps.Count/3)))) {
        $numStart = ($num*3)
        $numEnd = ($num*3)+2
        #"`$num = $num, `$numStart = $numStart, `$numEnd = $numEnd"        
        
        "                " + $(($finalSteps[$numStart..$numEnd] | ForEach-Object {'"'+$_+'"'}) -join ', ') + $(if($num -ne $([Math]::Floor($finalSteps.Count/3))){","})
        
    }
}
else {
    $finalSteps
}

if([String]::IsNullOrEmpty($ScriptFile)) {
    "`n`nNo file provided to replace the content."
} else {
    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Read file content.."
    $fileContent = [System.IO.File]::ReadAllText($ScriptFile)
    foreach($index in $($postStep..$($AllSteps.Count-1))) 
    {
        if($Action -eq "AddStep") { # Add New Step
            $fileContent = $fileContent.Replace($AllSteps[$index],$finalSteps[$index+1]);
        }
        else { # Remove Existing Step
            $fileContent = $fileContent.Replace($AllSteps[$index],$finalSteps[$index-1]);
        }
    }
    $newScriptFile = $ScriptFile.Replace('.ps1',' __bak.ps1')
    $fileContent | Out-File -FilePath $newScriptFile
    notepad $newScriptFile
    "Updated data saved into file '$newScriptFile'." | Write-Host -ForegroundColor Green
    "Opening saved file '$newScriptFile'." | Write-Host -ForegroundColor Green
}

