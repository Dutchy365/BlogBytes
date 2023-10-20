---
author: ""
title: "Part 1: Enhancing User Engagement Measurement on SharePoint Intranets with Power Platform"
date: 2023-10-21T00:00:01Z
description: "Data from user interaction: get likes and comments of news items"
tags:
  - Power Automate
  - User engagement
  - SharePoint
  - PowerBI
thumbnail: /images/20231021UserEngagement/Part1/00Part1.png
preview: /00Part1.png
images:
- 00Part1.png
---

Measuring user engagement is crucial for any SharePoint-based intranet to ensure that the platform is meeting its intended purpose and delivering value to the users. You can already benefit from Viva Connections and Viva Insights to enhance the user engagement measurement capabilities.

In the first part of this blog serie, we will explore how to use the Power Platform to measure user engagement even more deeply using KPI's regarding user engagement.

[Part 2](/BlogBytes/blog/20231021-userengagement-part2) of this blog serie will cover the KPI regarding page freshness. 

[Part 3](/BlogBytes/blog//20231021-userengagement-part3) will cover how to visualize the collected data in Power BI to gain insights into user behavior and engagement patterns. We will walk through the creation of a dashboard that displays the engagement metrics in a clear and concise manner, allowing intranet administrators to quickly assess the intranet's effectiveness and identify areas for improvement.

## Step by step
### Trigger
Create a flow which is triggered by once per 6 months, so half yearly calculations can be made.

![Flow trigger](/images/20231021UserEngagement/Part1/1-recurrence.png)

### Initialize variables
Initialize variables URL, varYear, varHalfYear and set the half year value dynamically. 

![Half year](/images/20231021UserEngagement/Part1/2-halfyear.png)

The date of the past half year can be detracted by using this expression:
```
subtractFromTime(formatDateTime(convertFromUtc(utcNow(),'W. Europe Standard Time'),'yyyy-MM-ddTHH:mm'),182, 'Day','yyyy-MM-ddThh:MM')
```
![Past half year](/images/20231021UserEngagement/Part1/3-pasthalfyear.png)


Initialize all those variables as integer:
* NewsArticlesTotalLikes
* NewsArticlesTotalComments
* NewsArticleNoComments
* NewsArticleNoLike
* NewsArticleWithComments
* NewsArticleWithLike

![Initialize variables](/images/20231021UserEngagement/Part1/4-variables.png)

### HTTP request to SharePoint
Send an HTTP to SharePoint using this URI to get alle newsitems that were created in the last 6 months and the ‘id’ is selected.
```
_api/web/lists/SitePages/items?$filter=ContentType eq 'Site Page' and PromotedState eq '2' and (Created ge datetime'@{variables('PastHalfYear')}') and (Created le datetime'@{formatDateTime(utcNow(),'yyyy-MM-ddThh:MM')}')&$select=id
```
![HTTP get newsitems](/images/20231021UserEngagement/Part1/5-HTTPGetNews.png)

Count the total amount of items retrieved in the last step. And add a Parse JSON and use the body of the HTTP request.

![Amount of newsitems](/images/20231021UserEngagement/Part1/6-amount.png)

### Apply to each newsitem
The output will be used in the apply to each, so the statistics of each newsitem can be calculated correctly.

![Apply to each newsitem](/images/20231021UserEngagement/Part1/7-applytoeach.png)

```
{ "parameters": { "ViewXml": "<View><ViewFields><FieldRef Name=\"_LikeCount\" /><FieldRef Name=\"_CommentCount\" /></ViewFields><Query><Where><Eq><FieldRef Name=\"ID\"/><Value Type=\"Number\">@{items('Apply_to_each')?['ID']}</Value></Eq></Where></Query><RowLimit /></View>" } }
```

In the body the ID of the newsitem is used to get the _LikeCount and _CommentCount. Those values aren’t available by default.
The output of the HTTP request is used in the Parse JSON and using a compose the first result is detracted. Theoretically there can be more results, although we know it’s only one result, because of the unique ID. 

![Compose](/images/20231021UserEngagement/Part1/8-compose.png)

For every newsitem the correct variables will be set. When a newsitem didn’t get a like, the variable ‘NewsArticleNoLike’ will be incremented by 1. When a newsitem has likes, the variable ‘NewsArticleWithLike’ will be incremented by 1 and the total likes (variable NewsArticlesTotalLikes) will be incremented with the amount of likes.

![Likes](/images/20231021UserEngagement/Part1/9-conditionlikes.png)


![Comments](/images/20231021UserEngagement/Part1/10-conditioncomments.png)


### Store values in SharePoint list
The results needs to be stored into a SharePoint list:

![SharePoint list create item](/images/20231021UserEngagement/Part1/11-createitemSP.png)

The result of the SharePoint list:

![SharePoint list](/images/20231021UserEngagement/Part1/12-sharepointlist.png)


So now you have insight into the half year statistics of your newsitems from your SharePoint Intranet. 