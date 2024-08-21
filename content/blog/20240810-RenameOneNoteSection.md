---
author: ""
title: "Rename OneNote Sections using Powershell"
date: 2024-08-10
description: Update OneNote section displayname based on a renamed Microsoft Teams Channel
tags:
- Powershell
- OneNote
thumbnail: /images/20240810RenameOneNoteSection/00RenameOneNoteSection.png
preview: /00RenameOneNoteSection.png
images: 
- /00RenameOneNoteSection.png
---


## Scenario
When a new Team is created, a OneNote is automatically generated, and each new channel receives its own section in OneNote, named after the channel. However, if the channel name is changed, the corresponding OneNote section name does not update automatically.

This blog explains how to use PowerShell to programmatically synchronize the channel name with the associated OneNote section name.

### Example
The Team contains several channels:
![Team with channels](/images/20240810RenameOneNoteSection/1-before.png)
Every channel has its own Notes tab with an associated OneNote Section. 
![Related OneNote Sections](/images/20240810RenameOneNoteSection/1-beforeonenote.png)

The Team with renamed channel names, those displaynames aren't automatically updated in the OneNote.
![Renamed channel names](/images/20240810RenameOneNoteSection/2-renamedchannels.png)

Let's create the Powershell script to be able to rename the OneNote sections.

## Create an App Registration
The Powershell script needs the Graph API. You can't use the Graph API using your personal user credentials, an App Registration must be created to be able to login.

### Permissions needed
The app registration needs some specific permissions: 
* Notes.ReadWrite.All
* Channel.ReadBasic.All
* Group.Read.All

![App Permissions](/images/20240810RenameOneNoteSection/3-apppermissions.png)


## Powershell

The script systematically iterates over groups and channels in Microsoft Teams, ensures that the corresponding OneNote sections are correctly named, and updates them if necessary.
High level steps which the script performs:  
1. The script starts with authentication in order to get an **access token**. 
2. After that **all groups** are fetched and stored in the variable $groups.
The script iterates over each group and gets the OneNote Notebook ID for the group.
3. After that the script retrieves **all channels** associated with the current group. 
To be able to match the OneNote section associated to the channel, the details of the OneNote tab are retrieved. 
4. The sectionId is kind of hidden inside the **contentURL** of the OneNote tab and a regular expression is needed to get that id. 

Example of (decoded) contentUrl, this contains a lot of details regarding the OneNote and also contains the sectionId: 
```
https://www.microsoft365.com/launch/onenote/officeunihost/teams?auth=2&flight=officeunihost&notebookSource=DefaultNotes&notebookSelfUrl=https://www.onenote.com/api/v1.0/myOrganization/siteCollections/36f07f85-6ada-4c7c-add3-de012ac6def8/sites/e7cf79ed-5b17-48ba-acde-6846aa55e1ca/notes/notebooks/1-0c16d522-bef6-4698-bb94-e2c4e9d25d8f&oneNoteWebUrl=https://abc123.sharepoint.com/sites/CustomerXYZ/SiteAssets/Customer%20XYZ%20Notebook&notebookName=Notes&createdTeamType=Standard&oneNoteClientUrl=https://abc123.sharepoint.com/sites/CustomerXYZ/SiteAssets/Customer%20XYZ%20Notebook/General.one&subEntityId={"objectUrl":"https://abc123.sharepoint.com/sites/CustomerXYZ/SiteAssets/Customer%20XYZ%20Notebook","wd":"target(General.one/)","fileType":"one","fileId":"0c16d522-bef6-4698-bb94-e2c4e9d25d8f","baseUrl":"https://abc123.sharepoint.com/sites/CustomerXYZ"}&sectionId=1-1733edcf-dde5-4a10-9c54-2572a995115b&notebookIsDefault=false&isMigrated=1&locale={locale}&tid={tid}&upn={userPrincipalName}&groupId={groupId}&theme={theme}&entityId={entityId}&sessionId={sessionId}&ringId={ringId}&teamSiteUrl={teamSiteUrl}&channelType={channelType}&appSessionId={appSessionId}&hostClientType={hostClientType}
```

5. This **sectionId** is needed to get the displayname of the OneNote section associated to the channelname. Those two displaynames can be compared. If they don't match, the script renames the OneNote section to match the channel name.

6. Last step the OneNote section is actually updated to do so a **PATCH request** is send via the Graph API. 


```powershell
### AUTHENTICATION ###
# Application (client) ID, tenant Name and secret
$clientID = "<replace by your own clientID>"
$clientSecret = "<replace by your own clientSecret>"
$tenantName = "<replace by your own tenantname>.onmicrosoft.com"
$resource = "https://graph.microsoft.com/"

$ReqTokenBody = @{
    Grant_Type    = "client_credentials"
    Scope         = "https://graph.microsoft.com/.default"
    client_Id     = $clientID
    Client_Secret = $clientSecret
}

$TokenResponse = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$TenantName/oauth2/v2.0/token" -Method POST -Body $ReqTokenBody

$headers = @{
'Content-Type'  = 'application/json'
'Authorization' = 'Bearer ' + $($TokenResponse.access_token)
}

### GROUPS ###
## Get All Groups with a team
$apiUrl = 'https://graph.microsoft.com/v1.0/Groups/'
$Data = Invoke-RestMethod -Headers @{Authorization = "Bearer $($Tokenresponse.access_token)"} -Uri $apiUrl -Method Get
$groups = ($Data | select-object Value).Value | Where-Object { $_.resourceProvisioningOptions -eq "Team" }

# Loop through each group to get channels
foreach ($group in $groups) {
    $groupId = $group.id
    $groupName = $group.displayName

    Write-Output "Processing Group: $groupName ($groupId)"

    # Get NotebookID of group
    $noteBookUri = "https://graph.microsoft.com/v1.0/groups/$groupId/onenote/notebooks"
    $noteBookResponse = Invoke-RestMethod -Headers $headers -Uri $noteBookUri -Method Get
    $notebookID = $noteBookResponse.value.id
    Write-Output "OneNoteID: $notebookID"

    # Get all channels for the current group
    $channelsUri = "https://graph.microsoft.com/v1.0/teams/$groupId/channels"
    $channelsResponse = Invoke-RestMethod -Headers $headers -Uri $channelsUri -Method Get
    $channels = $channelsResponse.value

     if ($channels -ne [string]::IsNullOrEmpty($notebookID)) {
        Write-Output "Channels for Group: $groupName"
        $channels | Format-Table displayName, id -AutoSize

        foreach ($channel in $channels) {
            $ChannelId = $channel.id

            Write-Output "Processing Channel: $($channel.displayName) ($ChannelId)"

            # Get all tabs for the current channel
            $tabsUri = "https://graph.microsoft.com/v1.0/teams/$groupId/channels/$ChannelId/tabs"
            $tabsResponse = Invoke-RestMethod -Headers $headers -Uri $tabsUri -Method Get

            # Find the OneNote tab
            $oneNoteTab = $tabsResponse.value | Where-Object { $_.displayName -eq "Notes" }

            if ($oneNoteTab) {
                Write-Output "Found OneNote Tab in Channel: $($channel.displayName)"
                $oneNoteTab | Format-Table displayName, id, webUrl -AutoSize

                # Extract the content URL
                $contentUrl = $oneNoteTab.configuration.contentUrl            

                # Define the regex pattern to extract sectionId
                $pattern = "sectionId=([a-f0-9\-]+)"

                # Perform the match
                if ($contentUrl -match $pattern) {
                    $sectionId = $matches[1]                
                
                # Get details of OneNote section related to the channel
                $sectionUri= "https://graph.microsoft.com/v1.0/groups/$groupId/onenote/notebooks/$notebookID/sections"
                $oneNoteSection = Invoke-RestMethod -Headers $headers -Uri $sectionUri -Method Get
                $sectionInfo = $oneNoteSection.value | Where-Object { $_.id -eq $sectionId }
                $sectionName = $sectionInfo.displayName                

                if ($channel.displayName -eq $sectionName) {
                    Write-Output "Channel display name and OneNote Section name are the same."
                } else {
                    Write-Output "Channel display name '$($channel.displayName)' and OneNote Section name '$($sectionName)' are not equal."              
                  
                    # Define the body for renaming the OneNote section
                    $body = @{
                        displayName = $channel.displayName
                    } | ConvertTo-Json

                    Write-Output "Rename OneNoteSection of $($notebookID) in: $($groupId) into $($channel.displayName)"                   
             
                    $renameNotebookUri = "https://graph.microsoft.com/v1.0/groups/$groupId/onenote/sections/$sectionId"
                    $renameNotebookResponse = Invoke-RestMethod -Method Patch -Uri $renameNotebookUri -Headers $headers -Body $body
                    Write-Output "OneNote section renamed successfully."
                }
                }
            } else {
                Write-Output "No OneNote Tab found in Channel: $($channel.displayName)"
            }
        }
    } else {
        Write-Output "No channels found for Group: $groupName"
    }
}
```

After running the script the OneNote section displaynames for the renamed channels are updated!

![Updated sections](/images/20240810RenameOneNoteSection/4-updatedsections.png)

## Side note
This blog focus on the Powershell itself to do the renaming itself, you can think of ways to embed the script in an Azure Function to periodically run the script to be sure the displaynames of OneNote sections are still corresponding the channel display names.

This script uses plain client id/client secret, this isn't the best way to go. Implementing this in a real-world scenario requires paying attention to authentication; using Azure KeyVault or Managed identity.