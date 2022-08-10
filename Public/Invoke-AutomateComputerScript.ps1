function Invoke-AutomateComputerScript {
   <#
    .SYNOPSIS
       
    .DESCRIPTION
        
    .NOTES
        Version:        1.0
    .EXAMPLE
        Invoke-AutomateComputerScript
    #>
        param (
            [int]$ComputerId,
            [int]$ScriptId,
            [hashtable] $Parameters
        )

        $URI = ($Script:CWAServer + '/cwa/api/v1/Computers/' + $ComputerID + "/ScheduledScripts")
        
        $ParamArray = @()

        foreach ($p in $Parameters.Keys){
            $ParamArray += ($p + "=" + ($Parameters[$p] -replace "|", "") )
        }

        $Body = [Ordered]@{
            Id = 0
            ScriptId = $ScriptId
            ClientId = 0
            LocationId = 0
            ComputerId = $ComputerId
            GroupId = 0
            IncludeSubgroups = $false
            SearchId = 0
            Disabled = $false
            EffectiveStartDate = "$(Get-Date -Format "M/dd/yyyy")"
            EffectiveOccurrences = 0
            DistributionWindowType = 2
            DistributionWindowAmount = 0
            NextRun = "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")"
            NextSchedule = "$(Get-Date -Format "yyyy-MM-dd HH:mm")"
            ScheduleType = 1
            Interval = 0
            ScheduleWeekOfMonth = 0
            ScheduleDayOfWeek = 0
            RepeatType = 0
            RepeatAmount = 0
            RepeatStopAfter = 0
            SkipOffline = $true
            OfflineOnly = $false
            WakeOffline = $false
            WakeScript = $false
            DisableTimeZone = $false
            RunScriptOnProbe = $false
            Priority = 6
            TimeZoneAdd = 0
            User = "SCAPI"
            LastUpdate = "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")"
            Parameters = $ParamArray -join "|"
        } | ConvertTo-Json -Compress

        $Arguments = @{
            URI = $URI
            ContentType = "application/json"
            Method = "POST"
            Body = $Body
        }

        Try{
            $Result = Invoke-AutomateAPIMaster -Arguments $Arguments
            If ($Result.content){
                $Result = $Result.content | ConvertFrom-Json
            }
            $ReturnedResults += ($Result)
        }Catch{
            Write-Error "Failed to perform Invoke-AutomateAPIMaster"
            $ReturnedResults=$Null
        }

        Return $ReturnedResults
}