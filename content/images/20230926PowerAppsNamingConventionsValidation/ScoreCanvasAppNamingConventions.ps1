Install-Module -Name powershell-yaml -Force -Repository PSGallery -Scope CurrentUser

$environment = "" #Name of your environment
$sourceUrl = "https://<<unique name>>.crm4.dynamics.com/" #Instance url of your environment (can be found in sessions details)  
$sourceConnectionName = "ConnectionName" #Name of your connection
$solutionName = "SolutionName" #use Internal Name of your solution

$dateTime = Get-Date -Format "yyyy-MM-dd-HHmm"
$destinationFolder = "C:\temp\$($dateTime)-$($solutionName)"
$reportErrorLevel = $true #If false: all logging will be stored in the output CSV
$namingConventionsPath = "C:\temp\NamingConventionsJsonObject.json" ## Location of JSON file which contains naming conventions

#namingconventions
$table = Get-Content -Path $namingConventionsPath -Raw | ConvertFrom-Json

pac auth create --url $sourceURL --name $sourceConnectionName 

pac solution export --path "$($destinationFolder).zip" --name $solutionName --managed false --include general
pac solution unpack --zipfile "$($destinationFolder).zip" --folder "$($destinationFolder)\." --processCanvasApps --allowWrite  

$canvasApps = Get-ChildItem -Path "$($destinationFolder)\." -Filter *.msapp -Recurse -File -Name
$summary = @()
$outputCSV = @()

foreach ($canvasApp in $canvasApps) {

    $internalAppName = $canvasApp.Split('\')[-1].replace('_DocumentUri.msapp', '')

    $displayName = (Get-Content -Path "$($destinationFolder)\CanvasApps\$($internalAppName).meta.xml" -Raw) | Select-Xml -XPath "/CanvasApp/DisplayName" | Select-Object -ExpandProperty Node | Select-Object -ExpandProperty "#text"

    $sourceFiles = Get-ChildItem -Path "$($destinationFolder)\CanvasApps\Src\$($internalAppName)\Src" -Filter *.yaml -Recurse -File -Name
    
    $output = @()

    # Get all Yaml files of the app and get all the controls with there name and type
    foreach ($sourceFile in $sourceFiles) { 
        Write-output "$($sourceFile)"

        $fileContent = Get-Content "$($destinationFolder)\CanvasApps\Src\$($internalAppName)\Src\$($sourceFile)" -Raw

        $jsonObject = ConvertFrom-Yaml -Yaml $fileContent 
       
        function LoopJson($jsonObject, $screen, $path, $loginPath) {
            $item = @()

            foreach ($key in $jsonObject.Keys) {
                if ($key.Contains("As")) {                   
                    
                    $name = $key.Split(' As ')[0]
                    $type = $key.Split(' As ')[1]  
                    
                    Write-Host "$($name)"

                    $item += @{
                        Name   = $name
                        Type   = $type.split('.')[0]
                        Screen = $screen
                        Path   = $path
                    }          
                    $item += (LoopJson $jsonObject.$key $screen $(if (!$loginPath) { $path } elseif ($path -eq "") { "$name" } else { "$path/$name" }) $true)
                }

            }
            return $item   
        }

        $outputScreen = LoopJson $jsonObject $sourceFile.Split('.fx.yaml')[0] ""
        $output += $outputScreen
    }
 
    $wrong = 0
    # Test if all controls match the given namingconventions
    foreach ($item in $output) {
    
        $naming = $table | Where-Object { $_.Control -eq $item.Type } | Select-Object -ExpandProperty Naming
        if ($naming -and $item.Name -cmatch "^$naming") {
            $message = "Control '$($item.Name)' matches type '$($item.Type)' with naming convention '$($naming)'."
            $status = "Correct"
            Write-Host "✅ " $message
        }
        elseif ($item.Type -eq "screen" -and $item.Name -cmatch 'Screen$') {
            $message = "Screen $($item.Name) matches naming convention."
            $status = "Correct"
            Write-Host "✅ " $message
        }
        elseif ($item.Type -eq "screen" -and $item.Name -notmatch 'Screen$') {
            $message = "Screen $($item.Name) doesn't match naming convention."
            $status = "Error"
            Write-Host "❌ " $message -ForeGroundColor Blue
        }
        else { 
            $message = "Control '$($item.Name)' with type '$($item.Type)' does not match naming convention, Name should start with '$($naming)' on Screen named '$($item.Screen)' $(if ( $item.Path -ne '') { "in element '$($item.Path)'"})"    
            $status = "Error"
            Write-Host "❌ " $message -ForegroundColor Blue
            $wrong++           
        }

        $outputCSV += [ordered] @{
            Environment = $environment
            Solution    = $solutionName
            App         = $displayName
            Screen      = $item.Screen
            Path        = $item.Path
            Control     = $item.Name
            Type        = $item.Type
            Status      = $status
            Message     = $message           
        }
    }

    $calc = 100 - (($($wrong) / $($output.Count)) * 100)
    $score = [math]::Round($calc, 1)

    # Write conclusion to terminal 
    Write-Host "The score of the app $($displayName) in solution $($solutionName) is " -NoNewline
    if ($score -ge 90) {
        Write-Host "$($score)% `u{1F600}" -ForegroundColor Green -NoNewline
        $summary += "The score of the app $($displayName) is $($score)% `u{1F600}. $($wrong) out of $($output.Count) doesn't match the naming conventions.>"
    }
    else {
        Write-Host "$($score)% `u{1F622}" -ForegroundColor Red -NoNewline
        $summary += "The score of the app $($displayName) is $($score)% `u{1F622}. $($wrong) out of $($output.Count) doesn't match the naming conventions.>"
    }

    Write-Host ": $($wrong) out of $($output.Count) doesn't match the naming conventions."   

}

# The summary of the results of all the apps available in the solution 
Write-Host "`n Summary of solution $($solutionName):" -ForegroundColor Magenta
$summaryLines = $summary.split('>').Trim()
foreach ($summaryLine in $summaryLines) { 
    Write-Host $summaryLine
}

$sortedOutputCsv = $outputCSV | Sort-Object { $_.Environment }, { $_.Solution }, { $_.App }, { $_.Status }

if ($reportErrorLevel) { 
    $filteredOutputCSV = $sortedOutputCsv | Where-Object { $_.Status -eq "Error" } 
    $filteredOutputCSV | Export-Csv -Path "C:\temp\$($dateTime)$($solutionName).csv" -NoTypeInformation 
}
else {
    $sortedOutputCsv | Export-Csv -Path "C:\temp\$($dateTime)$($solutionName).csv" -NoTypeInformation 
}