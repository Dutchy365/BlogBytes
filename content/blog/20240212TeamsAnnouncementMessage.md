---
author: ""
title: "Using Microsoft Graph and Power Automate to post an Announcement Message in Teams channel"
date: 2024-02-12
description: Use Invoke an HTTP request in Power Automate to POST a message
tags:
  - Power Automate
  - Teams Provisioning
  - chat message
  - Announcement 
thumbnail: /images/20240212TeamsAnnouncementMessage/00Announcement.png
preview: /00Announcement.png
images: 
- /00Announcement.png
---



## Scenario
This blog describes the Flow to create a Team and start with a message of type Announcement.
The default 'Post a message in a chat or channel' isn't sufficient, because the message type can't be selected, so it can't be an Announcement.

The end result should be a clear message in a Teams channel:
![Announcement](/images/20240212TeamsAnnouncementMessage/1-Announcementbanner.png)

## Flow actions to create Team
In order to share the full story the Team needs to be created and Team ID and Channel ID needs to be stored in a variable.
To read the details collapse these steps below:

<details>
<summary>Full Flow steps</summary>

The Team is created using these steps:
The 'initialize var Teamname' and 'Initialize var ChannelID' are variables of type string.
![Create Team](/images/20240212TeamsAnnouncementMessage/2a-FlowCreateTeam.png)
![Create Team](/images/20240212TeamsAnnouncementMessage/2b-FlowCreateTeam.png)
Get the ID of the newly created team.
![Create Team](/images/20240212TeamsAnnouncementMessage/2c-FlowCreateTeam.png)


Get the ChannelID of the General channel and store that in the variable.

![ChannelID](/images/20240212TeamsAnnouncementMessage/3a-FlowChannelID.png)
![ChannelID](/images/20240212TeamsAnnouncementMessage/3b-FlowChannelID.png)


Add a member to the newly create team.
![Add member](/images/20240212TeamsAnnouncementMessage/4a-FlowAddMember.png)

As a preparation for the content of the message the list of members is set up in HTML format.

![MembersList](/images/20240212TeamsAnnouncementMessage/5a-FlowMembersList.png)

</details>


## Invoke an HTTP Request
To post the announcement message add the action Invoke an HTTP Request.
For both the Base Resource URL and Entra ID Resource URI you can enter: https://graph.microsoft.com 

![Graph authentication](/images/20240212TeamsAnnouncementMessage/7a-AuthenticationGraph.png)

The Url of the request is, for which team-id and channel-id are replaced for the corresponding variables:

`https://graph.microsoft.com/v1.0/teams/team-id/channels/channel-id/messages`


The 'Invoke an HTTP Request':
![Invoke HTTP Request](/images/20240212TeamsAnnouncementMessage/8a-InvokeHTTPRequest.png)

The body of the request contains all the information needed for the message to set up correctly.
The body content of the message is in HTML format, so you can use your own creativity. In this example a hyperlink to a manual and a list of added members is configured. 

For both the body content and attachments id the same GUID needs to be set. Therefor use a variable with expression `guid()`, so both locations have the same GUID.

```json
{
  "subject": "Team for @{variables('Teamname')}",
  "body": {
    "contentType": "html",
    "content": "<attachment id=\"@{variables('GUID')}\"></attachment>Welcome in this team. <br><br>You have access to the planner, files and OneNote.<br><br>The user manual can be found<a href='link'> here</a>. <br><br>  The following users were added when the project was created:<br> <ul>@{variables('MembersList')}</ul>"
  },
  "attachments": [
    {
      "id": "@{variables('GUID')}",
      "contentType": "application/vnd.microsoft.teams.messaging-announcementBanner",
      "contentUrl": null,
      "content": "{\"title\":\"This is an Announcement\",\"cardImageType\":\"colorTheme\",\"cardImageDetails\":{\"colorTheme\":\"mulberryred\"}}",
      "name": null,
      "thumbnailUrl": null,
      "teamsAppId": null
    }
  ]
}
```

In the attachments>content the colorTheme can be defined. 
![colorTheme](/images/20240212TeamsAnnouncementMessage/9-colorTheme.png)


Color names you can choose from:
* <span style="color:rgb(205, 218, 234);font-weight:bold;">Periwinkle blue</span>
* <span style="color:rgb(214, 212, 232);font-weight:bold;">Lavender</span>
* <span style="color:rgb(245, 211, 223);font-weight:bold;">Rose</span>
* <span style="color:rgb(251, 222, 215);font-weight:bold;">Orange sherbet</span>
* <span style="color:rgb(248, 234, 205);font-weight:bold;">Flax yellow</span>
* <span style="color:rgb(214, 227, 231);font-weight:bold;">Teal</span>
* <span style="color:rgb(15, 48, 87);font-weight:bold;">Navy blue</span>
* <span style="color:rgb(39, 33, 84);font-weight:bold;">Indigo</span>
* <span style="color:rgb(117, 30, 60);font-weight:bold;">Mulberry red</span>
* <span style="color:rgb(205, 89, 55);font-weight:bold;">Fire orange</span>
* <span style="color:rgb(124, 88, 17);font-weight:bold;">Raw umber</span>
* <span style="color:rgb(51, 105, 107); font-weight:bold;">Ocean green</span>



## Delegated or application only permissions
Unfortunately at this moment you can't use application-only permissions to achieve this. Following [the documentation](https://learn.microsoft.com/en-us/microsoftteams/platform/graph-api/import-messages/import-external-messages-to-teams) you should be apply to Post a message while creating a Team in migration mode. Currently the Announcement type is out-of-scope.

