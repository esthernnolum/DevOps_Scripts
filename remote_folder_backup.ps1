	param
	(
		[Parameter(Mandatory=$True,Position=1)]
		[string]$service
	)
	
	$computers  = "<hostIP>"
	$source = "<sourcepath>"
	$time = $(Get-Date -format "yyyy_MM_dd_hh_mm_ss")
	$destination = "<destpath>"
	$ServiceName = $service
	$serviceStat = Get-Service -Name $ServiceName
	write-host $serviceStat.status
		
	#The below steps stops the service.
	$id = Get-WmiObject -Class Win32_Service -Filter "Name LIKE '$ServiceName'" | Select-Object -ExpandProperty ProcessId
	write-host "$ServiceName $id"
	taskkill /PID $id /F /T
	Start-Sleep -Seconds 10
		  
	$serviceStat.Refresh()
		
	if ($serviceStat.Status -eq 'Stopped')
	{
		write-host "$ServiceName Service completely stopped."
        Copy-Item $source -Destination \\$computers\$destination\<namd>-$time -Force -PassThru -Verbose -Recurse
		Start-Service $ServiceName
		$serviceStat = Get-Service -Name $ServiceName
		write-host $serviceStat.status
		write-host 'Service starting'
			
		Start-Sleep -seconds 20
	}	  
		
	$serviceStat.Refresh()
	while( -NOT( ($serviceStat.Status -eq 'Running') ) ){
		Start-Sleep -seconds 5
	}
			
	Write-Host "$ServiceName Service is now Running"
