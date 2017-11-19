[cmdletbinding()]
param(
	[string]$Title="PowerShell Message",

	[string]$Message="<message>",

	[string]$Url="",

	[string]$UrlTitle="",

	[alias("Prio")]
	[ValidateSet('-1','1')]
	[string]$Priority="",

	[string[]]$Device="",
	
	[alias("Token")]
	[ValidateSet('([A-Za-z0-9]{30})')]
	[ValidateNotNullOrEmpty()]
	[Parameter(Mandatory=$true)]
	[string]$ApplicationToken,
	
	[alias("User")]
	[ValidateSet('([A-Za-z0-9]{30})')]
	[ValidateNotNullOrEmpty()]
	[Parameter(Mandatory=$true)]
	[string]$UserToken,

	[string][ValidateSet(
		'pushover',
		'bike',
		'bugle',
		'cashregister',
		'classical',
		'cosmic',
		'falling',
		'gamelan',
		'incoming',
		'intermission',
		'magic',
		'mechanical',
		'pianobar',
		'siren',
		'spacealarm',
		'tugboat',
		'alien',
		'climb',
		'persistent',
		'echo',
		'updown',
		'none'
	)]$Sound="pushover",

	[switch]$Detailed=$false,

	[switch]$Silent=$false
)
#requires -version 3.0

$uri = 'https://api.pushover.net/1/messages.json'

$parameters = @{
	title = "$Title"
	priority = "$Priority"
   token = "$ApplicationToken"
   user = "$UserToken"
   message = "$Message"
	url = "$Url"
	url_title = "$UrlTitle"
	device = "$($Device -join ",")"
}
$output = $parameters | Invoke-RestMethod -Uri $uri -Method Post


if ($Silent){
	if ($output.status -eq "1") {
		exit (0)
	} else {
		exit (1)
	}
} else {
	if (($output.status -eq "1") -and (-not($Detailed))) {
		Write-Host OK
		exit (0)
	} elseif ((-not ($output.status -eq "1")) -and (-not($Detailed))) {
		Write-Host ERROR
		exit (1)
	} elseif (($output.status -eq "1") -and ($Detailed)) {
		$output
		exit (1)
	} else {
		$output
		exit (0)
	}
}
