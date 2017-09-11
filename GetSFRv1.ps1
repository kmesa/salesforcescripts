#Get Report and remove unnecessary data
#working but issues with commas if they are in the account name
Import-Module "C:\Users\kmesa\Documents\Source Control\powershell-modules\EncryptModule\PassEncryptModule.psm1"

$login_uri = "https://benefitfocus.my.salesforce.com"
$username = "kristian.mesa@benefitfocus.com"
$password = getPassword "Salesforce"
$report_id = "00OC00000063qom"
$startDateTime = Get-Date

#Create Table
$ResultsTable = New-Object system.Data.DataTable "ResultsTable"
$col1 = New-Object system.Data.DataColumn ("Name", [string])
$col2 = New-Object system.Data.DataColumn ("ID", [string])
$ResultsTable.columns.add($col1)
$ResultsTable.columns.add($col2)


#script starts
Write-Host "Test script started "  $startDateTime.ToShortDateString()  " at "  $startDateTime.ToLongTimeString()
[System.Diagnostics.Process]::Start("chrome.exe",$login_uri + '/?un=' + $username + '&pw=' + $password + '&startURL=' + $report_id + '?export=1&enc=UTF-8&xf=csv')

start-sleep -s 6
$csv = Import-CSV "C:\Users\kmesa\Downloads\report*.csv"

Foreach ($line in $csv)
{
write-host ("Adding Account Name "+$line."Account Name"+" and ID "+$line."Account ID 18")
$output = $ResultsTable.Rows.Add($line."Account Name", $line."Account ID 18")

}
$ResultsTable | export-csv "C:\Users\kmesa\Downloads\createSites.csv" -notype

Write-Host Format Completed!
Write-Host Deleting Initial CSV Report
$csv = "C:\Users\kmesa\Downloads\report*.csv"
Remove-Item $csv
