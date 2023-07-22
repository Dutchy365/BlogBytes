---
author: Elianne Burgers
title: How to create a markdown table with flexible amount of rows in an Approval
date: 2023-07-21
description: Flexible amount of rows in a markdown table in the Approval action
tags:
  - Power Automate
  - Approval
  - markdown
#thumbnail: https://picsum.photos/id/1073/400/250
thumbnail: images/20230721ApprovalMDTableRows/00ApprovalMDTableRows.png
preview: /thumbnails/20230707-PowerAppAdvancedFiltering.png
---


The Approval functionality is really powerful! A lot of situation requires a response like an approval. The approval action in Power Automate does have some parameters which you can enter data in. Next to required details like the ‘Approval type’, ‘Title’ and ‘Assigned to’, you can enter Details. For Details you can use markdown to design the setup. 

## The challenge
In this blog the challenge that’s got resolved is that the approval request contains a table which as multiple rows, but the amount of rows are flexible and different every flow run. 

Scenario: a quote can have multiple quote lines and those quote lines needs to be visible in the approval message.
First of all initialize a string variable. This variable is needed to store the rows of the table. In this example I created ‘QuoteLines’. 

In this case I want a table which has 3 columns: Name, Amount and Description. So I use the ‘append to string variable’ to enter the information and set up the structure in the columns separated by ‘|’. 
To be sure that every QuoteLine is on a new row in the table, add: ```decodeUriComponent('%0A')``` as expression to the end of the string.  

## Power Automate actions
![Append to string](/blog/images/20230721ApprovalMDTableRows/1-AppendtoString.png)

The first two lines of a table set the column headers and the alignment of elements in the table. In the details of the approval the header of the table needs to be setup in markdown: 
```
|Name | Amount | Description |
|---|---|---|
```

The approval action will looks like: 

![Append to string](/blog/images/20230721ApprovalMDTableRows/2-Approval.png)


The end result of what an end user will see, looks as follows: 

![Append outcome](/blog/images/20230721ApprovalMDTableRows/3-ApprovalOutcome.png)

## Tips & Tricks
* Official documentation regarding the markdown for approvals can be found here: https://learn.microsoft.com/en-us/power-automate/approvals-markdown-support
