---
author: ""
title: "Import solution missing dependencies error"
date: 2025-01-06
description: "How to overcome unmanaged dependencies while importing a solution"
tags:
  - Power Apps
  - Import
  - Dependency
thumbnail: /images/20250106ImportMissingDependency/00ImportMissingDependency.png
preview: /00ImportMissingDependency.png
images: 
- /00ImportMissingDependency.png
---

## Issue
Encountering errors while deploying solutions can be a frustrating experience. The errors I received during my first attempt to export and import the solution were difficult to understand. Despite having all the necessary dependent objects included in the solution, the import still failed.

The error message:
_"The solution.xml for the solution xxx contains an unmanaged dependency on the Active solution with type 1, schemaName her_camp, displayName Camp. A solution will fail to import in a target environment when missing dependencies on unmanaged components are present."_


![solution checker](/images/20250106ImportMissingDependency/solutionchecker.png)

The solution checker gave reference to [meta-include-missingunmanageddependencies](https://learn.microsoft.com/en-us/troubleshoot/power-platform/dataverse/working-with-solutions/missing-dependency-on-solution-import), this didn't provide a proper solution.


### Importing 
While importing the solution it failed and displayed this error: _Import failed due to missing dependencies for xxx._

![import error](/images/20250106ImportMissingDependency/importerror.png)

The details showed all the tables and even mentioning themselves:
adding required objects didn't solve the issue. 

![missing dependencies](/images/20250106ImportMissingDependency/missingdependencies.png)


### Log
The log.txt pointed to different 'dependent types':
* Dependent type=\"1\"
* Dependent type=\"2\"
* Dependent type=\"26\"
* Dependent type=\"29\"
* Dependent type=\"60\"
* Dependent type=\"300"

All related to default attributes of tables, like views, columns, system forms, entity relationship.
In my scenario I didn't even changed the defaults, I only used the Dataverse tables to store data in, used by a Canvas App.



## Solving the error message
After struggling for a while I tried my last hope, to manipulate the solution zipfile. Luckily, this only needed to be done the first time for importing the solution, next deployments of new versions of the solution worked fine.
 
Below the steps how to achieve this: 

1. Export the solution and store the .zip file locally


2. Unpack solution using PowerShell pac cli

Open a PowerShell terminal in which you point to the location of the zip file and unpack.
```powershell
cd C:\Temp
$varSolutionName = "Solutionname_1_0_0_4"
pac solution unpack --zipfile($varSolutionName + ".zip") --folder $varSolutionName
``` 

3. Delete missing dependency nodes in the solution.xml

Open the unpacked folder of your solution and navigate to Other, open the 'solution.xml' file in an editor. 

![missing dependencies](/images/20250106ImportMissingDependency/solutionxml.png)


Navigate to the Missing Dependencies. Delete everything between the tags while keeping the parent tags:
`<MissingDependencies></MissingDependencies>`

![missing dependencies](/images/20250106ImportMissingDependency/solutionxml2.png)


4. Pack solution using PowerShell pac cli

Go back to PowerShell terminal and pack the solution.

```powershell
pac solution pack --zipfile($varSolutionName + ".zip") --folder $varSolutionName
```
 
 
5. Import solution

Import the newly created zip file into the environment you want to deploy it to and you are ready to go!



## Conclusion
Manually removing the missing dependencies in the solution.xml resolved the errors. However, be cautious when making changes to the solution in this manner! This step is only required the first time; after that, you can export and import new versions of the solution without needing to do this.