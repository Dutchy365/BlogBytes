---
author: Elianne Burgers
title: How to get all SharePoint sites of a hub site in Power Automate
date: 2023-07-22
description: Use Power Automate to get all SharePoint Hubsites
tags:
  - Power Automate
  - SharePoint
  - hubsites
thumbnail: /BlogBytes/images/20230722SharePointGetAllHubsites/00SharePointHubsites.png
preview: /thumbnails/20230707SharePointGetAllHubsites.png
---

## The Challenge
There is a lot of information available on how to retrieve all sites related to a SharePoint hub using Powershell. 
Another option is to use Microsoft Graph and search for all sites.
https://graph.microsoft.com/v1.0/sites?search=*

![Graph](/blog/images/20230722SharePointGetAllHubsites/1-Graph.png)

The challenge was to get all the sites of a hub in Power Automate without using premium actions like the HTTP request.
This blog describes how to achieve this!

## Needed HTTP requests
Initialized a variable to store the URL of the hubsite. Next step is to get the HubSiteID. You can get the ID using the: 
```
/_api/site?$select=IsHubSite,HubSiteId
``` 

![HTTP Request get Hubsite ID](/blog/images/20230722SharePointGetAllHubsites/2-HTTPGetHubsiteID.png)

Use Parse JSON and initialize HubsiteID variable

![Parse JSON](/blog/images/20230722SharePointGetAllHubsites/3-ParseJsonHubsiteID.png)

To get all sites related to the hub, you need to use this call: 
```
_api/v2.1/sites?$filter=sharepointIds/hubSiteId eq '@{variables('HubSiteID')}'
```

![HTTP Request get all Hubsites](/blog/images/20230722SharePointGetAllHubsites/4-HTTPGetAllHubsites.png)


So now you are able to iterate through all sites related to a SharePoint Hub Site using Power Automate.