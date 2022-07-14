# Encryption Routine:

function Test-IfAlreadyRunning {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$ScriptName
	)
	Write-Host "testing if already running..." $strScriptName
	$PsScriptRunning = Get-WmiObject win32_process | Where-Object { $_.processname -eq 'powershell.exe' } | Select-Object commandline,ProcessId

	foreach ($PsCmdLine in $PsScriptsRunning)
	{
		[int32]$OtherPID = $PsCmdLine ProcessId
		[string]$OtherCmdLine = $PsCmdLine.commandline
		if (($OtherCmdLine -match $strScriptName) -and ($OtherPID -ne $PID))
		{
			Write-Host "PID [$OtherPID] is already running this script [$strScriptName]"
			Write-Host "Exiting this instance. (PID=[$PID])..."
			Start-Sleep -Second 7
			exit
		}
	}
