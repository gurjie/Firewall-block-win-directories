# pop the following two lines into a bash script, execute as admin
#@echo off
#Powershell -noprofile -executionpolicy bypass -file "C:\Users\User\Documents\Scripts\path_to_ps1_file"
$dir = "C:\Program Files\Common Files\"
[string[]]$rules = Get-NetFirewallRule | select -ExpandProperty Name
$items = gci -Recurse $dir -Include *.exe, *.dll 2> $null 
foreach ($item in $items) {
	$filename = $item.Name
	$fullpath = $item.FullName
	$rule_name = "FWDIR Block $filename ($fullpath) outbound"
	if ($rule_name -in $rules) {
		write-host "firewall rule already exists for $filename, skipping"
	} else {
		write-host "$rule_name doesn't exist, adding an entry"
		New-NetFirewallRule -Program "$fullpath" -Action Block -Profile Any -Name "$rule_name" -DisplayName "$rule_name" -Description "Block $filename, auto generated by block exes in chosen dir" -Direction Outbound
	}
}
Read-Host -Prompt "Press Enter to exit"
