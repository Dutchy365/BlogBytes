---
author: ""
title: "Rename OneNote Sections using Power Automate"
date: 2024-09-02
description: Update OneNote section displayname based on a renamed Microsoft Teams Channel
tags:
- Teams
- OneNote
- PowerAutomate
thumbnail: /images/20240902RenamingOneNotePowerAutomate/00RenameOneNoteSectionPowerAutomate.png
preview: /00RenameOneNoteSectionPowerAutomate.png
images: 
- /00RenameOneNoteSectionPowerAutomate.png
---


Recently I wrote a [blog regarding renaming OneNote sections based on a renamed channelname using PowerShell](/blog/20240810-renameoneNotesection/). 
In this blog same scenario is done using Power Automate.


The flow iterates iterates through all channels to determine changes.


# Scenario
A new Team comes with a OneNote and every new channel gets it's own OneNote section with the display name of the channel.
When the name of the channel is modified, the name of the OneNote section isn't updated automatically.

This blog describes how to programmatically sync the name of the channel with the name of the related section again using Powershell. 

The Team contains several channels:
![Team with channels](/images/20240810RenameOneNoteSection/1-before.png)
Every channel has its own Notes tab with an associated OneNote Section. 
![Related OneNote Sections](/images/20240810RenameOneNoteSection/1-beforeonenote.png)

The Team with renamed channel names, those displaynames aren't automatically updated in the OneNote.
![Renamed channel names](/images/20240810RenameOneNoteSection/2-renamedchannels.png)



# Create an App Registration
You can't use the Graph API using your personal user credentials, first you need to create an App Registration.
There are already plenty of blogs about creating an app registration, this won't be covered in this blog.

## Permissions needed
Notes.ReadWrite.All
Channel.ReadBasic.All
Group.Read.All
Sites.Read.All

![App Permissions](/images/20240810RenameOneNoteSection/3-apppermissions.png)


Unfortunately the 'Send a Microsoft Graph HTTP request' for Teams isn't sufficient to use in these scenario, because the API calls that needs to be done aren't supported in that action.

# Flow actions

### Initializing variables
First couple of actions in the flow are initializing variables.

![Variables](/images/20240902RenamingOneNotePowerAutomate/4-variables.png) 

### OneNote ID of the Team
For the group you need to get the OneNote Id.

URI:
`https://graph.microsoft.com/v1.0/groups/@{variables('groupID')}/onenote/notebooks`

Method: GET

![OneNote](/images/20240902RenamingOneNotePowerAutomate/5-onenoteid.png) 

## Iterate through all channels
After listing all channels of the Team, you need to iterate through all channels.

Get the tabs that are related to the current channel.

URI:
`https://graph.microsoft.com/v1.0/teams/@{variables('groupID')}/channels/@{items('Apply_to_each_Channel')?['id']}/tabs?$select=displayName,configuration`

Method: GET

![Get tabs](/images/20240902RenamingOneNotePowerAutomate/6-gettabs.png) 

Filter the tabs on the tab with displayName 'Notes' to get the tab related to a OneNote.

![Filter tab](/images/20240902RenamingOneNotePowerAutomate/7-filtertab.png) 


Set values for variables contenturl and sectionid:

![Set variables](/images/20240902RenamingOneNotePowerAutomate/8-setcontenturl.png) 


Set variable contenturl:
`first(body('Filter_array_Notes_tab'))?['configuration']?['contentUrl']`

Set variable sectionId:
`first(split(last(split(variables('contenturl'),'sectionId=')),'&'))`


Get the details of the OneNote section
![OneNote section details](/images/20240902RenamingOneNotePowerAutomate/9-onenotesectiondetails.png) 

URI:
`https://graph.microsoft.com/v1.0/groups/@{variables('groupID')}/onenote/notebooks/@{variables('notebookID')}/sections`

Method: GET

Filter the section on sectionId, to be able to get the current displayname of the section.

![Filter section](/images/20240902RenamingOneNotePowerAutomate/10-filtersection.png) 



Set variables for sectionname and channelname:

![Variables](/images/20240902RenamingOneNotePowerAutomate/10b-variables.png) 


Set variable SectionName:
`first(body('Filter_array_sectionId'))?['displayName']`

Set variable channelName:
`item()?['displayName']`


Add a condition in which you compare the SectionName and channelName.

![Condition](/images/20240902RenamingOneNotePowerAutomate/11-condition.png) 


If those names aren't the same the renaming of the OneNote section needs to take place:

![Renaming](/images/20240902RenamingOneNotePowerAutomate/12-renaming.png) 

URI: 
`https://graph.microsoft.com/v1.0/groups/@{variables('groupID')}/onenote/sections/@{variables('sectionId')}`

Method: PATCH

# Result
After running the flow the OneNote Section for the renamed channels are updated!

![App Permissions](/images/20240810RenameOneNoteSection/4-updatedsections.png)


# Side note
Don't forget to add some error handling, for blogging purposes and clean screenshots it isn't added here ☺️.