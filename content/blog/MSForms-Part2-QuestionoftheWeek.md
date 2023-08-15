---
author: null
title: "Microsoft Forms automation: update Forms poll on SharePoint intranet - part 2"
date: 2023-08-15T00:00:02Z
description: Keep your ‘Question of the week’ based on Microsoft up-to-date
tags:
  - Power Automate
  - custom connector
  - Microsoft Forms
  - SharePoint intranet
  - Poll
thumbnail: /images/MSForms/Part2-QuestionoftheWeek/00FormsQuestion.png
preview: /00FormsQuestion.png
keywords:
  - Power Automate
  - custom connector
  - Microsoft Forms
  - SharePoint intranet
  - Poll
images:
- /00FormsQuestion.png
---


Creating a social intranet that fosters collaboration and engagement among employees is essential in today's digital workplace. One effective component of a social intranet is a "question of the week" or poll functionality. While SharePoint doesn't have a built-in poll feature, you can use a Microsoft Form with one question to achieve the same effect. However, updating the question weekly can be a manual and time-consuming task.

Unfortunately, Microsoft doesn't provide a standard API for Microsoft Forms that can easily be integrated with Power Automate to automate question creation and management of a Form. In the first part of this blog series there is explained how to create a custom connector for Microsoft Forms. This custom connector with related actions will be used in this blog. 

SharePoint doesn’t have an out-of-the-box functionality to create a poll: by using a Microsoft Form with just one question it’s possible to have the same experience. 

![Intranet](/images/MSForms/Part2-QuestionoftheWeek/1-Intranet.png)


The kind of question can vary from question around topics like how employee spend their holidays or more serious topics to focus attention on it. 

Often a communication department has prepared a stock of questions after a brainstorming session, so they don’t have to think about it every week. How nice would it be if these were also automatically updated every week on the intranet!
Currently, Power Automate only has an action available that receives responses from a Microsoft Forms, no ability to create questions on a Form.

[In the first part of this blog series](/blog/msforms-part1-customconnector/) a custom connector using the undocumented Microsoft Forms API is created.


The High Level Design of the steps described in this blog:

![High Level Design](/images/MSForms/Part2-QuestionoftheWeek/HLD.png)





## Set up SharePoint list
Create a SharePoint list adding the following columns:
|Columnname|Column type|
|---|---|
|Question| Single line of text (you can use/rename the title column)|
|AnswerOptions|Multiple line of text (description: enter answer options separated by '&#124;') |
|StartDate|Date (to be sure no two items are created with same starting date, set this column to contain unique values) |
|QuestionID|Single line of text|
|Results|Multiline of text|

The SharePoint list looks like this:

![SharePoint list](/images/MSForms/Part2-QuestionoftheWeek/2-SPlist.png)

## Flow trigger and variables
Create a ‘Scheduled cloud flow’. Set the recurrence on daily.
Start with initializing the variables:

![Flow initialize variables](/images/MSForms/Part2-QuestionoftheWeek/3-FlowVariables.png)

## Check new question for today
Next step is to get the item of the SharePoint list in which the StartDate is equal to todays date. If there are no items, the Flow can be terminated.

![Condition start date](/images/MSForms/Part2-QuestionoftheWeek/4-ConditionStartDate.png)

## Get information of question that needs to be added
Next steps are to store the results of the current available AnswerOptions and get the current active question id and store that one in a variable.

![FormsChoiceData](/images/MSForms/Part2-QuestionoftheWeek/5-FormsChoiceData.png)

## Get current active question to store results
Get the question that is currently active to get the QuestionID.

![QuestionID](/images/MSForms/Part2-QuestionoftheWeek/6-QuestionID.png)

Based on the QuestionId get the related item ID in the SharePoint list and update that item with the results.

![SP Result update](/images/MSForms/Part2-QuestionoftheWeek/7-SPResultsUpdate.png)

## Delete responses
Next steps are needed to update the Form with a new question, first the responses have to be deleted in order to give everyone the ability to respond on the new question and the old question needs to deleted.

![Delete Responses](/images/MSForms/Part2-QuestionoftheWeek/8-DeleteResponses.png)


## Convert answer options 
The new question needs to be retrieved and AnswerOptions needs to be formatted in usable format.

![New Question](/images/MSForms/Part2-QuestionoftheWeek/9-NewQuestion.png)

![Choices to Generate](/images/MSForms/Part2-QuestionoftheWeek/10-ChoicesToGenerate.png)


The variable varChoicestoGenerate needs to be formatted a bit, using the following expression: 

`@{replace(substring(variables('varChoicestoGenerate'),0, int(lastIndexOf(variables('varChoicestoGenerate'),','))),'\n','')}`

The id is determined by the expression: `@{concat('r',string(rand(10000,999999)))}`


![Post Question](/images/MSForms/Part2-QuestionoftheWeek/11-PostQuestion.png)

## Update SharePoint list with question id
Last step is to store the question id in the SharePoint list:

![Update SharePoint list](/images/MSForms/Part2-QuestionoftheWeek/12-UpdateSPlist.png)


The Flow is ready to run every day to verify if a new question of the week needs to be posted on the intranet. 
Not only the new question is added, also the results of the previous questions are stored into the SharePoint list.

## Something to consider
The use of a custom connector makes it really easy to use to actions into multiple Flows, without technical knowledge needed.
The disadvantages is the fact that you need a premium license to perform those actions.
In this scenario the API calls can be done using 'Send an HTTP request to SharePoint' as well.

Hereby one example for posting a new question:

![HTTP Request to SharePoint](/images/MSForms/Part1-CustomConnector/13-PostHTTPSharePoint.png)


[In the last part of this blog series](/blog/msforms-part3-dashboard/) you can read how to visualize the data from the SharePoint list into a Power BI dashboard.



