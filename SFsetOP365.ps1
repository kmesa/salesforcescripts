Import-Module "C:\Users\kmesa\Documents\Source Control\powershell-modules\EncryptModule\PassEncryptModule.psm1"

$ResultsTable = New-Object system.Data.DataTable "ResultsTable"
$col1 = New-Object system.Data.DataColumn ("Name", [string])
$col2 = New-Object system.Data.DataColumn ("ID", [string])
$col3 = New-Object system.Data.DataColumn ("Account ID", [string])
$ResultsTable.columns.add($col1)
$ResultsTable.columns.add($col2)
$ResultsTable.columns.add($col3)

$addstr = "https://portal.sharepoint2013site.com/cp/"
$csv = Import-Csv "C:\Users\kmesa\Downloads\createsites.csv"

Foreach ($line in $csv){
    $output = $ResultsTable.Rows.Add($line.Name, $line.ID, $addstr+$line.ID)
}
$ResultsTable | export-csv "C:\Users\kmesa\Downloads\createSites.csv" -notype

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$tokenurl = "https://benefitfocus.my.salesforce.com/services/oauth2/token"
$postParams = [ordered]@{
grant_type="password";
client_id="[client_id]";
client_secret="[client_secret]";
username="yourusername@company.com";
password= getPassword "Salesforce";
}

# Get user token
$access_token = (Invoke-RestMethod -Uri $tokenurl -Method POST -Body $postParams).access_token
$url = "https://benefitfocus.my.salesforce.com/services/data/v38.0/sobjects/Account"
Invoke-RestMethod -Uri $url -Headers @{Authorization = "Bearer " + $access_token}

$headers = @{};
$headers =  @{Authorization = "Bearer " + $access_token};

$sites = Import-Csv "C:\users\kmesa\downloads\createsites.csv"

Foreach ($site in $sites)
{
    $body = @{"Sharepoint_Site__c" = $site.'Account ID' } | ConvertTo-Json
    $url1 = 'https://benefitfocus.my.salesforce.com/services/data/v38.0/sobjects/account/'+$site.ID
    Invoke-RestMethod -Method Patch -Uri $url1 -headers $headers -body $body -ContentType: 'application/json'
}
