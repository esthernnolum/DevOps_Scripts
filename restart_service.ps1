	param
	(
		[Parameter(Mandatory=$True,Position=1)]
		[string]$service
	)
		

			$ServiceName = $service
			$serviceStat = Get-Service -Name $ServiceName
			write-host $serviceStat.status
			if ($serviceStat.Status -ne 'Stopped')
			{
				$id = Get-WmiObject -Class Win32_Service -Filter "Name LIKE '$ServiceName'" | Select-Object -ExpandProperty ProcessId
				write-host "$ServiceName $id"
				taskkill /PID $id /F /T
				Start-Sleep -Seconds 10
			}
			
			Start-Service $ServiceName
			$serviceStat = Get-Service -Name $ServiceName
			write-host $serviceStat.status
			write-host 'Service starting'
			
			Start-Sleep -seconds 20
		  
			$serviceStat.Refresh()
			while( -NOT( ($serviceStat.Status -eq 'Running') ) ){
				Start-Sleep -seconds 5
			}
			
			Write-Host "$ServiceName Service is now Running"
			
			#}else{
			#  write-host "There is no crash report for $wf_path"
			#}
			
			
			write-host "=============================================="
			Start-Sleep -seconds 10
