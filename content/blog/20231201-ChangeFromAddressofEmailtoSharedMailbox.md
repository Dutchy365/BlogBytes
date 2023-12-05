---
author: ""
title: "Change Email From Address to Queue using Environment Variable in JavaScript"
date: 2023-12-05
description: Set email address to a queue using an environment variable in a Model Driven App
tags:
  - Model Driven App
  - Queue ID
  - Email
  - JavaScript 
thumbnail: /images/20231205ChangeEmailAddressMDA/00ChangeEmail.png
preview: /00ChangeEmail.png
images: 
- /00ChangeEmail.png
---


> Special thanks to Kevin Hendricks and Jan-Frederik Kobus for their support in implementing this scenario. 



## Scenario
The scenario of the blog is related to the email entity of a Model Driven app. 
The goal is to use a shared mailbox to send emails from instead of the personal address of the current user. The case is to automatically change the From address and be able to have a flexible setup for different queue ids.

## Preparations
To prepare the mailbox it needs to be set-up and approved as a queue. 

![Queue](/images/20231205ChangeEmailAddressMDA/1-queue.png)



## Environment variable
Create an environment variable named `Outgoing Queue ID` to store the queue ID. This allows for easy deployment of the solution to multiple environments, each having a different queue ID.


![Environment variable](/images/20231205ChangeEmailAddressMDA/2-environmentvar.png)


## Create a webresource with a JavaScript file
Create a Javascript with the following content:
> Change 'demo_outgoingqueueid' with the internal name of your environment variable. 

> Change 'Test Mailbox' with the name of the mailbox you want to use.

```javascript
var MAILBOX;
(function (MAILBOX) {
    var Email;
    (function (Email) {
        let FORM_CONTEXT;
        let GLOBAL_CONTEXT;
        let FORM_ID;
        let FORM_TYPE;
        function onFormLoad(executionContext) {
            console.log('OnFormLoad Triggered');
            FORM_CONTEXT = executionContext.getFormContext();
            GLOBAL_CONTEXT = Xrm.Utility.getGlobalContext();
            FORM_ID = FORM_CONTEXT.ui.formSelector.getCurrentItem() != null ? FORM_CONTEXT.ui.formSelector.getCurrentItem().getId().toUpperCase() : "";
            FORM_TYPE = FORM_CONTEXT.ui.getFormType();
            FORM_CONTEXT.data.entity.addOnSave(function () { onFormSave(); });
            addOnchangeFunctionsToAttributes();

            setFromOutgoingQueue();
        }
        Email.onFormLoad = onFormLoad;
        function onFormSave(executionContext) {
            console.log('onFormSave Triggered');
        }
        Email.onFormSave = onFormSave;
        function addOnchangeFunctionsToAttributes() {
            console.log('addOnchangeFunctionsToAttributes Triggered');
        }
        Email.addOnchangeFunctionsToAttributes = addOnchangeFunctionsToAttributes;
        async function setFromOutgoingQueue() {
            let fromAttribute = FORM_CONTEXT.getAttribute("from");
            if (fromAttribute == null)
				return;
			
			let queueId = await retrieveEnvironmentVariable("demo_outgoingqueueid")
                .catch(error => showDialog("Error", error.message));
            if (queueId == null || queueId === "") 
				return;
			
			fromAttribute.setValue([{ id: queueId, name: "Test Mailbox", entityType: "queue" }]);
        }
        Email.setFromOutgoingQueue = setFromOutgoingQueue;
		async function retrieveEnvironmentVariable(environmentVariableSchemaName) {
			return new Promise((resolve, reject) => {
				var parameters = {};
				parameters.DefinitionSchemaName = environmentVariableSchemaName;

				var retrieveEnvironmentVariableValueRequest = {
					DefinitionSchemaName: parameters.DefinitionSchemaName,

					getMetadata: function() {
						return {
							boundParameter: null,
							parameterTypes: {
								"DefinitionSchemaName": {
									"typeName": "Edm.String",
									"structuralProperty": 1
								}
							},
							operationType: 1,
							operationName: "RetrieveEnvironmentVariableValue"
						};
					}
				};

				Xrm.WebApi.online.execute(retrieveEnvironmentVariableValueRequest).then(
					function success(result) {
						if (result.ok) {
							result.json().then(
								function (response) {
									resolve(response["Value"]);
								}
							);
						}
					},
					function(error) {
						reject(error.message);
					}
				);
			});
		}
        Email.retrieveMultipleRecords = retrieveMultipleRecords;	
		async function showDialog(title, message) {
			var alertStrings = { confirmButtonLabel: "OK", text: message, title: title };
			var alertOptions = { height: 320, width: 460 };
			Xrm.Navigation.openAlertDialog(alertStrings, alertOptions);
		}
        Email.showDialog = showDialog;	
    })(Email = MAILBOX.Email || (MAILBOX.Email = {}));
})(MAILBOX || (MAILBOX = {}));
```

## Form Events
Go to the events on the Email form and add an Event Handler. Select Add library.

![Event Handler](/images/20231205ChangeEmailAddressMDA/3-onload.png)

Select 'New web resource'

![New web resource](/images/20231205ChangeEmailAddressMDA/4-newwebresource.png)

Upload the JavaScript file and 'Save and publish'.
![Upload JavaScript](/images/20231205ChangeEmailAddressMDA/5-webresource.png)

Select the newly added webresource to add to the Email form.
![Add JavaScript](/images/20231205ChangeEmailAddressMDA/6-selectwebresource.png)

Configure the event using the right settings. 
![Configure the event](/images/20231205ChangeEmailAddressMDA/7-configureevent.png)

Publish the changes and test the Email form!

## End result
The final outcome is an email form where the From address is seamlessly set to the shared mailbox queue instead of the user who is logged in, eliminating the need for manual switching and searching.
![End result](/images/20231205ChangeEmailAddressMDA/8-endresultfrom.png)


## Idea
In this version of the script and setup only the queue id of the mail is an environment variable, an idea is to also have the name of the mailbox as an environment variable, i.e. 'outgoing mailbox'.
