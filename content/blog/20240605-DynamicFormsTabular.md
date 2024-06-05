---
author: ""
title: "Dynamics forms: tabular question type"
date: 2024-06-04
description: How to create flexible tabular questions
tags:
  - Power Apps
  - Dynamic forms
  - ParseJSON
thumbnail: /images/20240605DynamicFormsTabular/00DynamicForms.png
preview: /00DynamicForms.png
images: 
- /00DynamicForms.png
---


## Dynamics Forms
Inspired by [Matthey Devaney](https://www.matthewdevaney.com/power-apps-dynamic-forms-generate-forms-from-a-questions-list/), a fully dynamic form was created in Power Apps, incorporating various question types like toggles, text inputs, and comboboxes. Everything worked smoothly until the need for tabular questions came along.

For these tabular questions, the requirement was to allow flexible setup of the question and definition of table headers, enabling end users to enter their answers in the rows below. This challenge is now ready to be addressed 💪🏻.


## End result
The end result is the possibility to answer tabular question in which the user can add and remove answers.

![End result](/images/20240605DynamicFormsTabular/1-endresult.gif)



## Define column headers
Management of the questions takes place in a Model Driven app. 
The question is defined and the column headers are entered as options formatted using comma separated values.


![Options](/images/20240605DynamicFormsTabular/2-Options.png)

The limitations in the Power Apps Canvas are set to work with a maximum of 5 column headers. In this example question there are just 3 column headers needed. 

A collection 'colTabularAnswers' is created to store the information for all questions of type 'tabular'.

```json
Clear(colTabularAnswers);
    ForAll(
        Filter(colQuestions,FieldType = "Tabular") As data,
            With({splitted: Split(data.Options, ",")},
            Collect(
                colTabularAnswers,
                {
                    QuestionID: data.QuestionID,
                    ID: GUID(),
                    ColumnType: 0, 
                    Column1: If(CountRows(splitted) >= 1,
                        Text(Index(splitted,1).Value),
                        " "),
                    Column2: If(CountRows(splitted) >= 2,
                        Text(Index(splitted,2).Value),
                         " "),
                    Column3: If(CountRows(splitted) >= 3,
                        Text(Index(splitted,3).Value),
                        " "),
                    Column4: If(CountRows(splitted) >= 4,
                        Text(Index(splitted,4).Value),
                        " "),
                    Column5: If(CountRows(splitted) >= 5,
                        Text(Index(splitted,5).Value),
                        " ")
                }
            )
        ));
```

This results in a collection in which for all questions with fieldtype tabular the column headers are defined. By ColumnType = 0 it's known as header.
![Headers](/images/20240605DynamicFormsTabular/3-Headers.png)


## Question setup
In the gallery in which all questions types are covered a container is added which three different parts: header, form and answers. As you can see a maximum of 5.
![container](/images/20240605DynamicFormsTabular/4a-container.png)
![container](/images/20240605DynamicFormsTabular/4b-container.png)


### Header
The column headers are set as text:
![header text](/images/20240605DynamicFormsTabular/5-headertext.png)

### Form
The form is created using text input. 

![form](/images/20240605DynamicFormsTabular/6-forminput.png)

The visibility of each TabularValue is set based on the number of column headers available as options: 
`If(CountRows(Split(ThisItem.Options,",")) >= 1,true, false)`

### Answer gallery

In the galTabular the answers of the current questions are loaded.
The items:
`Filter(colTabularAnswers, QuestionID = ThisItem.QuestionID And ColumnType = 1) As Tabular`

![galAnswers](/images/20240605DynamicFormsTabular/7-galAnswers.png)

In this example there are just three columns available, to equally divided the columns the width of the label is calculated dynamically. 

Width: 
`If(CountRows(Split(ThisItem.Options,",")) = 0, "", (Parent.Width - btnTabularFormAdd.Width) / (CountRows(Split(ThisItem.Options,","))))`


## Answers
The answers need to be initially stored, deleted and reloaded. 

### Add answers
Not only the answers needed to be given, they need to be saved as well. 
After clicking on the Add button the collection is updated with the entered values. 


```json
Patch(
    colTabularAnswers,
    Defaults(colTabularAnswers),
    {
        ID: GUID(),
        QuestionID: ThisItem.QuestionID,
        ColumnType: 1,
        Column1: If(IsBlank(txtTabularForm1.Value), " ", txtTabularForm1.Value),
        Column2: If(IsBlank(txtTabularForm2.Value), " ", txtTabularForm2.Value),
        Column3: If(IsBlank(txtTabularForm3.Value), " ", txtTabularForm3.Value),
        Column4: If(IsBlank(txtTabularForm4.Value), " ", txtTabularForm4.Value),
        Column5: If(IsBlank(txtTabularForm5.Value), " ", txtTabularForm5.Value)
    }
);

Reset(txtTabularForm1);
Reset(txtTabularForm2);
Reset(txtTabularForm3);
Reset(txtTabularForm4);
Reset(txtTabularForm5);
Reset(galTabular);

UpdateIf(
    colQuestionsModified, QuestionID = ThisItem.QuestionID,
    {
        Modified: 1,
        Answer: Text(JSON(Filter(colTabularAnswers As data, data.QuestionID = ThisRecord.QuestionID)))
    }
);

```


The given values are added to the collection and next to that the colQuestionsModified in which all modified answers are stored is updated.  
The answer is stored as text which looks like JSON. Due to the fact PowerFx doesn't have the opportunity to create dynamic column value, the 'Column1', 'Column2' etcetera are introduced. 

```json
[
{"Column1":"Training/Certification","Column2":" Institution","Column3":" Year completed","Column4":" ","Column5":" ","ColumnType":0,"ID":"4d658e27-a765-4179-af59-b6883fd1c7a0","QuestionID":"58935396-891d-ef11-840a-002248a269cd"},
{"Column1":"Scrum master","Column2":"Scrum.org","Column3":"2022","Column4":" ","Column5":" ","ColumnType":1,"ID":"22d3907e-f7ca-4cfa-af4c-3316e2888788","QuestionID":"58935396-891d-ef11-840a-002248a269cd"},
{"Column1":"PL-100","Column2":"Microsoft","Column3":"2023","Column4":" ","Column5":" ","ColumnType":1,"ID":"0138e7c9-6e85-4e35-9cd7-0f85bd38c438","QuestionID":"58935396-891d-ef11-840a-002248a269cd"},
{"Column1":"PL-200","Column2":"Microsoft","Column3":"2024","Column4":" ","Column5":" ","ColumnType":1,"ID":"34aa3e5c-188a-4914-991f-71801b5ff97f","QuestionID":"58935396-891d-ef11-840a-002248a269cd"}
]
```

### Remove answers
While clicking on the remove button the selected item needs to be deleted. 
In the OnSelect the following logic is added: 
```json
Remove(
    colTabularAnswers,
    LookUp(colTabularAnswers, ID = galTabular.Selected.ID)
);

UpdateIf(
    colQuestionsModified, QuestionID = ThisItem.QuestionID,
    {
        Modified: 1,
        Answer: Text(JSON(Filter(colTabularAnswers As data, data.QuestionID = ThisRecord.QuestionID)))
    }
);
```

Both the collection of tabular answers and the collection which stores the values of the modified questions is updated.


### Pre-load previous answers
All the above steps are required for newly answered tabular questions. Additionally, previous answers need to be loaded into the dynamic form. When selecting a previously filled-in form, the colQuestions collection is loaded to store all the information regarding the questions and given answers. For tabular questions, this means the answer values are loaded as follows:

```json
[
{"Column1":"Training/Certification","Column2":" Institution","Column3":" Year completed","Column4":" ","Column5":" ","ColumnType":0,"ID":"4d658e27-a765-4179-af59-b6883fd1c7a0","QuestionID":"58935396-891d-ef11-840a-002248a269cd"},
{"Column1":"Scrum master","Column2":"Scrum.org","Column3":"2022","Column4":" ","Column5":" ","ColumnType":1,"ID":"22d3907e-f7ca-4cfa-af4c-3316e2888788","QuestionID":"58935396-891d-ef11-840a-002248a269cd"},
{"Column1":"PL-100","Column2":"Microsoft","Column3":"2023","Column4":" ","Column5":" ","ColumnType":1,"ID":"0138e7c9-6e85-4e35-9cd7-0f85bd38c438","QuestionID":"58935396-891d-ef11-840a-002248a269cd"},
{"Column1":"PL-200","Column2":"Microsoft","Column3":"2024","Column4":" ","Column5":" ","ColumnType":1,"ID":"34aa3e5c-188a-4914-991f-71801b5ff97f","QuestionID":"58935396-891d-ef11-840a-002248a269cd"}
]
```

This needs to be transformed into rows in the colTabularAnswers.
This can be done using following PowerFx: 

```json
ForAll(
    Filter(colQuestions,FieldType = "Tabular") As data,
            ForAll(
                ParseJSON(data.Answer) As jsondata, 
                If(
                    Int(jsondata.ColumnType) = 1,
                    Collect(
                        colTabularAnswers,
                        {
                            Column1: Text(jsondata.Column1),
                            Column2: Text(jsondata.Column2),
                            Column3: Text(jsondata.Column3),
                            Column4: Text(jsondata.Column4),
                            Column5: Text(jsondata.Column5),
                            QuestionID: GUID(jsondata.QuestionID),
                            ID: GUID(),
                            ColumnType: Int(jsondata.ColumnType)
                        }
                    )
                )
            )
        );
```

## Patch
On a separate save button all the given answers are patched to the Dataverse table. 

Hopefully Microsoft comes with a solution to have the ability to create and use flexible column names. Unto that moment this can be a way to go. 


## Tips and tricks
* The height of the background is set dynamically. This is done based on the number of rows added as tabular answers. In the gallery in which all the questions types are stored a button is added in which the height is set based on the current fieldtype. 

```
  If(ThisItem.FieldType = "Tabular",
    (CountRows(MatchAll(ThisItem.Description,"\n")) +1 ) * 20 + (CountRows(Filter(colTabularAnswers, QuestionID = ThisItem.QuestionID And ColumnType = 1)) * 41) + conTabularHeader.Height + conTabularForm.Height + 50, 40)
```

![nested](/images/20240605DynamicFormsTabular/8-nested.png)
