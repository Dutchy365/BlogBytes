---
author: null
title: "Microsoft Forms API"
date: 2023-08-02
description: Different question types require different request body
tags:
  - Microsoft Forms 
  - API
thumbnail: /images/MSForms/Part1-CustomConnector/2-Payload.png
preview: /00FormsCustomConnector.png
keywords:
  - Power Automate
  - custom connector
  - Microsoft Forms
hideMeta: true
---

Every question type has is own setup of the body content. 

## Body content
The payload of the different question types all have the same parameters:
* questionInfo
* type
* title
* id
* order
* isQuiz
* required

```json
{
    "questionInfo": "",
    "type": "",
    "title": "Question",
    "id": "",
    "order": 4000500,
    "isQuiz": false,
    "required": false
}
```

### Parameter type
|Question| Type |
|:--------|:------|
|Choice|Question.Choice|
|Text |Question.TextField| 
|Rating |Question.Rating|
|Date |Question.DateTime|
|Ranking |Question.Ranking|
|Likert |Question.Matrix|
|Upload File |Question.FileUpload|
|Net Promoter Score |Question.NPS|


### Parameter title
The title is quite an easy parameter, it just needs to contain the text for the actual question. 

### Parameter id
The parameter id is a random number starting with `r`.
In Power Automate you can use this expression to populate id:
`concat('r',string(rand(10000,999999)))`

### Parameter order
This contains the order of the questions. 


### Parameter isQuiz
This parameter is available for each question on a Form, while it's based on the Form you created.

### Parameter required
This parameter determines if the question is required to answer or not. Just set true or false value.

### Parameter questionInfo
This parameter is the most important and most challenging for all the question types. 
In this parameter the content value for the question needs to be set.



#### Choice

```json
{
    "questionInfo": "{\"Choices\":[{\"Description\":\"Option 1\",\"IsGenerated\":true},{\"Description\":\"Option 2\",\"IsGenerated\":true}],\"ChoiceType\":1,\"AllowOtherAnswer\":false,\"OptionDisplayStyle\":\"ListAll\",\"ChoiceRestrictionType\":\"None\",\"ShowRatingLabel\":false}",
    "type": "Question.Choice",
    "title": "Question",
    "id": "",
    "order": 4000500,
    "isQuiz": false,
    "required": false
}
```

#### Text

```json
{
    "questionInfo": "{\"Multiline\":false,\"ShowRatingLabel\":false}",
    "type": "Question.TextField",
    "title": "Question",
    "id": "",
    "order": 5000500,
    "isQuiz": false,
    "required": false
}
```

#### Rating
```json
{
    "questionInfo": "{\"Length\":5,\"RatingShape\":\"Star\",\"LeftDescription\":\"\",\"RightDescription\":\"\",\"MinRating\":1,\"ShuffleOptions\":false,\"ShowRatingLabel\":false,\"IsMathQuiz\":false}",
    "type": "Question.Rating",
    "title": "Question",
    "id": "",
    "order": 6000500,
    "isQuiz": false,
    "required": false
}
```

#### Date
```json
{
    "questionInfo": "{\"Date\":true,\"Time\":false,\"ShuffleOptions\":false,\"ShowRatingLabel\":false,\"IsMathQuiz\":false}",
    "type": "Question.DateTime",
    "title": "Question",
    "id": "",
    "order": 7000500,
    "isQuiz": false,
    "required": false
}
```

#### Upload File
```json
{
    "questionInfo": "{\"HasSpecificFileType\":false,\"FileTypes\":{\"Word\":true,\"Excel\":true,\"PowerPoint\":true,\"PDF\":true,\"Image\":true,\"Video\":true,\"Audio\":true},\"MaxFileCount\":1,\"MaxFileSize\":10,\"ShuffleOptions\":false,\"ShowRatingLabel\":false,\"IsMathQuiz\":false}",
    "type": "Question.FileUpload",
    "title": "Question",
    "id": "",
    "order": 16000500,
    "isQuiz": false,
    "required": false
}
```

#### Net Promoter Score
```json
{
    "questionInfo": "{\"LeftDescription\":\"Not at all likely\",\"RightDescription\":\"Extremely likely\",\"ShuffleOptions\":false,\"ShowRatingLabel\":false,\"IsMathQuiz\":false}",
    "type": "Question.NPS",
    "title": "How likely are you to recommend us to a friend or colleague?",
    "id": "",
    "order": 17000500,
    "isQuiz": false,
    "required": false
}
```


## Extra API calls need for Ranking and Likert

The first four question types are easy to had with one API call to the Form.
The Ranking, Likert, Upload File and Net Promoter Score are more challenging; not only to POST the question, but choices as well.


`https://forms.office.com/formapi/api/{TenantID}/users/{UserID}/forms('{FormID}')/questions('QuestiondID')/choices`


#### Ranking

```json
{
    "questionInfo": "{\"ShuffleOptions\":false,\"ShowRatingLabel\":false,\"IsMathQuiz\":false}",
    "type": "Question.Ranking",
    "title": "Question",
    "allowMultipleValues": true,
    "id": "",
    "order": 9000500,
    "isQuiz": false,
    "required": false
}
```

Body to POST new answer option:

```json
{"customProperties":"{\"IsGenerated\":true}","displayText":"Option 2","key":"87bc49ca-21aa-42ce-89bc-07296e64476b","order":2}
```



### Likert
Body to POST the question:
```json
{
    "type": "Question.MatrixChoice",
    "title": "Statement 2",
    "id": "",
    "order": 15000500,
    "groupId": "r3a99df2e5d934b28adbe3ad6580be2fe"
}
```

Body to POST new answer option:

```
{"customProperties":"{\"IsGenerated\":true}","order":4,"displayText":"Option 4","description":null,"key":"0d6772a8-ae78-4515-a3af-4233d2c46d45"}
```


