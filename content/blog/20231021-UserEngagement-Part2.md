---
author: ""
title: "Part 2: Enhancing User Engagement Measurement on SharePoint Intranets: Page Freshness"
date: 2023-10-21T00:00:02Z
description: "SharePoint Intranet user engagement: page freshness"
tags:
  - Power Automate
  - user engagement
  - page freshness
  - SharePoint
  - Power BI
thumbnail: /images/20231021UserEngagement/Part2/00Part2.png
preview: /00Part2.png
images:
- 00Part2.png
---

Measuring user engagement is crucial for any SharePoint-based intranet to ensure that the platform is meeting its intended purpose and delivering value to the users. You can already benefit from Viva Connections and Viva Insights to enhance the user engagement measurement capabilities.

[In the first part of this blog serie](/BlogBytes/blog/20231021-userengagement-part1), you could read how to use the Power Platform to measure user engagement even more deeply using KPI's regarding user engagement. 

This second part of this blog serie will cover the KPI regarding page freshness. 

Part 3 will cover how to visualize the collected data in Power BI to gain insights into user behavior and engagement patterns. We will walk through the creation of a dashboard that displays the engagement metrics in a clear and concise manner, allowing intranet administrators to quickly assess the intranet's effectiveness and identify areas for improvement.

## Step by step
Page freshness is the total amount of pages versus pages with modified date within the past half year. 

Most of the SharePoint intranets nowadays consists of a hubsite and we need to identify all the pages in the hubsites. How to retrieve the hubsiteid and related sites, [can be read in this blog](./20230707SharePointGetAllHubsites.md).

Set the recurrence of the Flow the same as in part 1 and set the value of the half year you’re working on.

![Get all sites](/images/20231021UserEngagement/Part2/1-Getallsites.png)

Use the output of the JSON in an apply to each to loop through all the pages of all the related sites and count the amount of pages.
The URI:
```
_api/web/lists/SitePages/items?$filter=ContentType eq 'Site Page' and PromotedState eq '0' and OData__SPSitePageFlags ne 'Template' &$select=id,Modified
```


![Apply to each](/images/20231021UserEngagement/Part2/2-applytoeach.png)


In the next steps you need to filter the pages on the modified date, to get the amount of pages that are modified in the past half year.

![Apply to each](/images/20231021UserEngagement/Part2/3-filterarray.png)

And for all the sites the amount of pages and modified amount of pages can be stored into a SharePoint list.

![Create item SharePoint list](/images/20231021UserEngagement/Part2/4-createitemsharepoint.png)


The SharePoint list:

![SharePoint list](/images/20231021UserEngagement/Part2/5-SharePointlist.png)

Now you have insight in the page freshness of your SharePoint intranet. In the third and last part of this blogserie you can read how to visualize this data in PowerBI.