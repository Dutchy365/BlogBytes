---
author: ""
title: "Provision Perfect Pipeline"
date: 2025-02-25
description: "Use the pac cli to provision pipeline using Power Fx"
tags:
  - PowerShell
  - Pipeline
thumbnail: /images/20250225ProvisionPerfectPipeline/00ProvisionPipeline.png
preview: /00ProvisionPipeline.png
images: 
- /00ProvisionPipeline.png
---


During the Global Power Platform Bootcamp Belgium together with Albert-Jan Schot I presented a session titled 'Provision Perfect Pipelines'. 
A part of the session was the demo of a script to automatically provision a pipeline setup using the in product Deployment Pipeline Configuration.

## Scenario
We have a project called Projecthub which uses three different environments:
* Projecthub-Dev
* Projecthub-QA 
* Projecthub-Prod

For this project we want to have pipeline to be able to move solutions from Dev to QA and from QA to Prod.

In the Deployment Pipeline Configuration there are three tables involved: 

![structure](/images/20250225ProvisionPerfectPipeline/structure.png)
 

In the deployment environments the list of environment is set to use. Differentiate by a type developer or target environment. 
The deployment pipeline as the actual pipeline related information, including the related deployment stages. 

## Script
To automate the creation of the pipeline configuration, we've developed a script that updates a Power Fx text file and executes it. By using the 'pac power-fx run' command, we can execute a file containing Power Fx instructions. In the PowerShell script, we replace certain variables and generate a new file, making the template reusable for other projects.

### Step by step
A short explanation of what the script does:
* you need to define the variables for the related project and environments
* it gets the environment id from the environments. Those ids are needed in the Power Fx part 
* it replaces the variable values in the text file for the actual values
* it runs the Power Fx to create the deployment environments, deployment pipeline and the defined deployment stages


### Powershell

```powershell
# Authenticate with Power Platform
pac auth create 

# Define variables
$projectName = "Projecthub"
$devEnvName = "$projectName-Dev"
$testEnvName = "$projectName-QA"
$prodEnvName = "$projectName-Prod"

# Define the template file and output file
$templateFile = "C:\Temp\pfx-provisionpipeline-template.txt"
$outputFile = "C:\Temp\pfx-provisionpipeline-uptated.txt"

# Using regular expression to extract Environment ID for development environment
$devEnvId = (pac org list --filter $devEnvName  | Select-String -Pattern "\s+([0-9a-fA-F-]+)\s+https").Matches.Groups[1].Value
Write-Host "Environment ID for dev: $devEnvId"

# Using regular expression to extract Environment ID for test environment
$testEnvId = (pac org list --filter $testEnvName  | Select-String -Pattern "\s+([0-9a-fA-F-]+)\s+https").Matches.Groups[1].Value
Write-Host "Environment ID for test: $testEnvId"

# Using regular expression to extract Environment ID for production environment
$prodEnvId = (pac org list --filter $prodEnvName  | Select-String -Pattern "\s+([0-9a-fA-F-]+)\s+https").Matches.Groups[1].Value
Write-Host "Environment ID for prod: $prodEnvId"

# Read the content of the template file
$powerFxExpression = Get-Content -Path $templateFile -Raw

# Replace the placeholders with actual values
$powerFxExpression = $powerFxExpression -replace "@projectName", $projectName
$powerFxExpression = $powerFxExpression -replace "@devEnvName", $devEnvName
$powerFxExpression = $powerFxExpression -replace "@testEnvName", $testEnvName
$powerFxExpression = $powerFxExpression -replace "@prodEnvName", $prodEnvName
$powerFxExpression = $powerFxExpression -replace "@devEnvId", $devEnvId
$powerFxExpression = $powerFxExpression -replace "@testEnvId", $testEnvId
$powerFxExpression = $powerFxExpression -replace "@prodEnvId", $prodEnvId

# Write the updated Power Fx expression to a new file
$powerFxExpression | Out-File -FilePath $outputFile -Force

# Run the pac CLI command with the new file
pac power-fx run --file $outputFile --echo
```

### Power Fx
Store this in a txt file, referenced in the script as 'pfx-provisionpipeline-template.txt'


```
Collect(deploymentenvironment, {name: "@devEnvName", 'Environment Type': 'Environment Type (Deployment Environments)'.'Development Environment', 'Environment ID': "@devEnvId"});

With(
    {
        varDeployPipeline: Collect(
            'Deployment Pipelines', 
            {
                Name: "@projectName", 
                'Enable AI Deployment Notes': 'Enable AI Deployment Notes (Deployment Pipelines)'.Enabled, 
                'Enable Redeployment': 'Enable Redeployment (Deployment Pipelines)'.Enabled
            }
        ),
        testDeplEnv: Collect(
            deploymentenvironment, 
            {
                name: "@testEnvName", 
                'Environment Type': 'Environment Type (Deployment Environments)'.'Target Environment', 
                'Environment ID': "@testEnvId"
            }
        ),
        prodDeplEnv: Collect(
            deploymentenvironment, 
            {
                name: "@prodEnvName", 
                'Environment Type': 'Environment Type (Deployment Environments)'.'Target Environment', 
                'Environment ID': "@prodEnvId"
            }
        )
    },
    With(
        {
            firstStage: Collect(
                'Deployment Stages',
                {
                    Name: "From Dev To Test",
                    'Is Sharing Enabled': 'Is Sharing Enabled (Deployment Stages)'.No,
                    'Pre-Deployment Step Required': 'Pre-Deployment Step Required (Deployment Stages)'.No,
                    'Pre-Export Step Required': 'Pre-Export Step Required (Deployment Stages)'.No,
                    'Target Deployment Environment': testDeplEnv,     
                    'Deployment Pipeline': varDeployPipeline
                }
            )
        },
        Collect(
            'Deployment Stages',
            {
                Name: "From Test To Prod",
                'Is Sharing Enabled': 'Is Sharing Enabled (Deployment Stages)'.No,
                'Pre-Deployment Step Required': 'Pre-Deployment Step Required (Deployment Stages)'.No,
                'Pre-Export Step Required': 'Pre-Export Step Required (Deployment Stages)'.No,
                'Previous Deployment Stage': firstStage,
                'Target Deployment Environment': prodDeplEnv,     
                'Deployment Pipeline': varDeployPipeline
            }
        )
    )
)
```


## Conclusion
This approach allows you to deploy a pipeline that aligns with your organization's governance and compliance regulations, eliminating the need for manual configuration.

### Tips
* Errors during execution: check the pac cli language: [For more info click on this link](https://dianabirkelbach.wordpress.com/2023/10/30/setup-the-language-for-pac-power-fx-in-vscode-terminal/)
    * type “set-culture -cultureinfo en-US”, in Terminal
    * restart VSCode
    * type “get-culture” in terminal, to confirm the change
* [Microsoft Learn about using pac power-fx](https://learn.microsoft.com/en-us/power-platform/developer/cli/reference/power-fx)

