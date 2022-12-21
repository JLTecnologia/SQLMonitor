﻿#$DomainCredential = Get-Credential -UserName 'Lab\SQLServices' -Message 'AD Account'
#$saAdmin = Get-Credential -UserName 'sa' -Message 'sa'
#$localAdmin = Get-Credential -UserName 'Administrator' -Message 'Local Admin'

cls
import-module dbatools
$sqlDropTable = @"
Do something here
go
select 'Done' as result;
"@
$params = @{
    SqlInstanceToBaseline = 'SqlPractice'
    #DbaDatabase = 'DBA'
    #HostName = 'Workstation'
    #RetentionDays = 7
    DbaToolsFolderPath = 'F:\GitHub\dbatools'
    #FirstResponderKitZipFile = 'F:\GitHub\SQL-Server-First-Responder-Kit-20221213main.zip'
    #RemoteSQLMonitorPath = 'C:\SQLMonitor'
    InventoryServer = 'SQLMonitor'
    InventoryDatabase = 'DBA'
    #DbaGroupMailId = 'some_dba_mail_id@gmail.com'
    #SqlCredential = $saAdmin
    #WindowsCredential = $DomainCredential
    <#
    SkipSteps = @(  "1__sp_WhoIsActive", "2__AllDatabaseObjects", "3__XEventSession",
                "4__FirstResponderKitObjects", "5__DarlingDataObjects", "6__OlaHallengrenSolutionObjects",
                "7__sp_WhatIsRunning", "8__usp_GetAllServerInfo", "9__CopyDbaToolsModule2Host",
                "10__CopyPerfmonFolder2Host", "11__SetupPerfmonDataCollector", "12__CreateCredentialProxy",
                "13__CreateJobCollectDiskSpace", "14__CreateJobCollectOSProcesses", "15__CreateJobCollectPerfmonData",
                "16__CreateJobCollectWaitStats", "17__CreateJobCollectXEvents", "18__CreateJobCollectFileIOStats",
                "19__CreateJobPartitionsMaintenance", "20__CreateJobPurgeTables", "21__CreateJobRemoveXEventFiles",
                "22__CreateJobRunWhoIsActive", "23__CreateJobRunBlitzIndex", "24__CreateJobRunBlitzIndexWeekly",
                "25__CreateJobUpdateSqlServerVersions", "26__CreateJobCheckInstanceAvailability", "27__CreateJobGetAllServerInfo",
                "28__WhoIsActivePartition", "29__BlitzIndexPartition", "30__EnablePageCompression",
                "31__GrafanaLogin", "32__LinkedServerOnInventory", "33__LinkedServerForDataDestinationInstance",
                "34__AlterViewsForDataDestinationInstance")
    #>
    SkipSteps = @(  "1__sp_WhoIsActive", "3__XEventSession", "5__DarlingDataObjects", "6__OlaHallengrenSolutionObjects",
                "7__sp_WhatIsRunning", "9__CopyDbaToolsModule2Host", "10__CopyPerfmonFolder2Host", "11__SetupPerfmonDataCollector", 
                "12__CreateCredentialProxy", "13__CreateJobCollectDiskSpace", "14__CreateJobCollectOSProcesses", 
                "15__CreateJobCollectPerfmonData", "16__CreateJobCollectWaitStats", "17__CreateJobCollectXEvents", 
                "21__CreateJobRemoveXEventFiles", "24__CreateJobUpdateSqlServerVersions", "25__CreateJobCheckInstanceAvailability", 
                "26__CreateJobGetAllServerInfo", "30__GrafanaLogin", "31__LinkedServerOnInventory", 
                "32__LinkedServerForDataDestinationInstance", "33__AlterViewsForDataDestinationInstance")
    #StartAtStep = '23__CreateJobRunBlitzIndex'
    #StopAtStep = '29__EnablePageCompression'
    #DropCreatePowerShellJobs = $true
    #DryRun = $false
    SkipRDPSessionSteps = $true
    SkipPowerShellJobs = $true
    #SkipTsqlJobs = $true
    SkipMailProfileCheck = $true
    skipCollationCheck = $true
    SkipWindowsAdminAccessTest = $true
    #SqlInstanceAsDataDestination = 'Demo\SQL2019'
    #SqlInstanceForPowershellJobs = 'Workstation'
    #SqlInstanceForTsqlJobs = 'Workstation'
    #ConfirmValidationOfMultiInstance = $true
}
F:\GitHub\SQLMonitor\SQLMonitor\Install-SQLMonitor.ps1 @Params #-PreQuery $sqlDropTable #-Debug


# Get-Help F:\GitHub\SQLMonitor\SQLMonitor\Install-SQLMonitor.ps1 -ShowWindow
#Get-DbaDbMailProfile -SqlInstance '192.168.56.31' -SqlCredential $personalCredential
#Copy-DbaDbMail -Source '192.168.56.15' -Destination '192.168.56.31' -SourceSqlCredential $personalCredential -DestinationSqlCredential $personalCredential # Lab
#New-DbaCredential -SqlInstance 'xy' -Identity $LabCredential.UserName -SecurePassword $LabCredential.Password -Force # -SqlCredential $SqlCredential -EnableException
#New-DbaAgentProxy -SqlInstance 'xy' -Name $LabCredential.UserName -ProxyCredential $LabCredential.UserName -SubSystem PowerShell,CmdExec
<#

Enable-PSRemoting -Force -SkipNetworkProfileCheck # remote machine
Set-Item WSMAN:\Localhost\Client\TrustedHosts -Value SQLMonitor.Lab.com -Concatenate -Force # remote machine
Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name LocalAccountTokenFilterPolicy
Set-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name LocalAccountTokenFilterPolicy -Value 1

# Incase 
#Set-Item WSMAN:\Localhost\Client\TrustedHosts -Value * -Force # run on local machine
#Set-NetConnectionProfile -NetworkCategory Private # Execute this only if above command fails

Enter-PSSession -ComputerName '192.168.56.31' -Credential $localAdmin -Authentication Negotiate
Test-WSMan '192.168.56.31' -Credential $localAdmin -Authentication Negotiate


#>

