---
author: null
title: "Microsoft Forms automation: a custom connector - part 1"
date: 2023-08-15T00:00:01Z
description: Creating an custom connector for undocumented Microsoft Forms API
tags:
  - Power Automate
  - custom connector
  - Microsoft Forms 
  - API
thumbnail: /images/MSForms/Part1-CustomConnector/00FormsCustomConnector.png
preview: /00FormsCustomConnector.png
keywords:
  - Power Automate
  - custom connector
  - Microsoft Forms
images:
- cover00FormsCustomConnector.png
---


Creating a social intranet that fosters collaboration and engagement among employees is essential in today's digital workplace. One effective component of a social intranet is a "question of the week" or poll functionality. While SharePoint doesn't have a built-in poll feature, you can use a Microsoft Form with one question to achieve the same effect. However, updating the question weekly can be a manual and time-consuming task.

Unfortunately, Microsoft doesn't provide a standard API for Microsoft Forms that can easily be integrated with Power Automate to automate question creation and management of a Form. But don't worry! In this blog, we'll explore creative ways to make use of the undocumented Microsoft Forms API and Power Automate to automate the process of updating the question every week.

These blog series contains three parts:
1.	Create a custom connector using the undocumented Microsoft Forms API
2.	[Keep your ‘Question of the week’ based on Microsoft Forms up-to-date](/blog/msforms-part2-questionoftheweek/)
3.	[Make use of the responses: display the survey data of the Forms](/blog/msforms-part3-dashboard/)

This is part one in which tips and tricks will be shared to create a custom connector for Microsoft Forms.


## Microsoft Forms API
There is no formal Microsoft Forms API documentation, so you have to be a bit creative to make this happen.
All the steps and possibilities mentioned in this blog are discovered by using F12 in the browser while working on a Microsoft Forms Form. 

First step to get the request URL.

![Microsoft Forms F12](/images/MSForms/Part1-CustomConnector/1-FormsF12.png)

Next to get an example of the Payload:
![Payload](/images/MSForms/Part1-CustomConnector/2-Payload.png)

The payload in a more readable format, so you can detect what's in there.
![Payload readable](/images/MSForms/Part1-CustomConnector/3-PayloadReadible.png)

## Create an App Registration for Microsoft Forms 
First step you need to do is set up an app registration. I won’t write everything in detail in this blog, there are a lot of other resources that will do that. 
I’ve given my App Registration the name: FlowAPI.

Here are the relevant settings for the app registration:
Add application permissions for Microsoft Forms 


![API Permissions](/images/MSForms/Part1-CustomConnector/4-APIPermissions.png)

Copy and save the API link, you’ll need that later on.

![Request Permissions](/images/MSForms/Part1-CustomConnector/5-RequestPermissions.png)

Set the Redirect URL settings to: `https://global.consent.azure-apim.net/redirect`
![Redirect URL](/images/MSForms/Part1-CustomConnector/6-RedirectURL.png)

Create a client secret and store the value in a password manager.
![Secret](/images/MSForms/Part1-CustomConnector/7-Secret.png)

Now the App Registration settings are ready, you can continuing creating a custom connector. 

## Create the custom connector
Go to make.powerplatform.com and create a custom connector and start from blank.
![Make Connector](/images/MSForms/Part1-CustomConnector/8-MakeConnector.png)


Set the following general information:
* Host: `forms.office.com`
* Base URL: `/formapi/api/`


![General Information](/images/MSForms/Part1-CustomConnector/9-GeneralInformation.png)

### Security
Choose the authentication you want to use, to use the just create App Registration select ‘OAuth. 2.0’.
Set Identity Provider to ‘Azure Active Directory’ and set the Client ID and Client secret values from the App Registration.

Resource URL: `api://forms.office.com/c9a559d2-7aab-4f13-a6ed-e7e9c52aec87`


![Security](/images/MSForms/Part1-CustomConnector/10-Security.png)



### Definition
In the Definition part all the actions need to be declared.
The details of the actions created to perform required tasks in this scenario. 


|General|Verb |Request |Description|
|--|--|-------|-------|
|GetQuestions |GET |<div style="width:220px; word-wrap:break-word;">`https://forms.office.com/formapi/api/{TenantID}/users/{UserID}/forms('{FormID}')/questions` </div>   |Get an overview of the questions that are available on a Form 
|PostQuestions   |POST   | <div style="width:220px; word-wrap:break-word;">`https://forms.office.com/formapi/api/{TenantID}/users/{UserID}/forms('{FormID}')/questions` <br/> <br/> body: `{"questionInfo":"","type":"Question.Choice","title":"","id":"","order":,"isQuiz":false,"required":false}` </div> | Post a Question <br/><br/>Different question types require different body. <br/> [For more details read the information on this page.](https://www.burgersandbytes.nl/page/msformapi) |
|DeleteQuestion  |DELETE   |<div style="width:220px; word-wrap:break-word;"> `https://forms.office.com/formapi/api/{TenantID}/users/{UserID}/forms('{FormID}')/questions('{QuestionID}')` </div>  | Delete a question using the questionid  |
|DeleteResponses |DELETE|<div style="width:220px; word-wrap:break-word;"> `https://forms.office.com/formapi/api/{TenantID}/users/{UserID}/forms('{FormID}')/responses` </div>|Delete responses from a Form|
|<div style="width:115px; word-wrap:break-word;">GetAggregateSurveyData</div>|GET|<div style="width:220px; word-wrap:break-word;">`https://forms.office.com/formapi/api/{TenantID}/users/{UserID}/forms('{FormID}')/GetAggregateSurveyData`</div>| Get response details of a Form| 


![Request](/images/MSForms/Part1-CustomConnector/11-Request.png)


### Response
While creating a custom connector it's not required to define the Response, although it is best practice to do so. The response settings make it possible to use the parameters of the outcome in Power Automate immediately.
Although the output of the Forms calls looks like JSON it isn't, so for this connector defining a response doesn't work. In Power Automate you can use Parse JSON, to make use of the output.

## Custom Connector - End result
Ending the Custom Connector with a couple of Operations:
![Request](/images/MSForms/Part1-CustomConnector/12-ConnectorOperations.png)

🎉 The Custom Connector is ready to use! 🎉


## Something to consider
The use of a custom connector makes it really easy to use to actions into multiple Flows, without technical knowledge needed.
The disadvantages is the fact that you need a premium license to perform those actions.
In this scenario the API calls can be done using 'Send an HTTP request to SharePoint' as well.

Hereby one example for posting a new question:

![HTTP Request to SharePoint](/images/MSForms/Part1-CustomConnector/13-PostHTTPSharePoint.png)

[In the second part of this blog series](/blog/msforms-part2-questionoftheweek/) you'll read how to use the custom connector.
