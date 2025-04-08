---
author: ""
title: "Display the version history of Dataverse records in Power Apps"
date: 2025-04-03
description: "How to provision a SharePoint agent using a Power Automate flow"
tags:
  - Power Apps
  - SharePoint 
  - Version History
thumbnail: /images/20250403DataverseVersionHistory/00DataverseHistory.png
preview: /00DataverseHistory.png
images: 
- /00DataverseHistory.png
---


In SharePoint users are used to see version history of files and items. In Dataverse this isn't there by default.
In a Model Driven app the audit history is visible as related table on the form, this blog describes how to make it possible to make this available in a Canvas App just like we are used in SharePoint.

## Endresult
The endresult on which a user can select an item and the flow will retrieve the version history data. 

![endresult](/images/20250403DataverseVersionHistory/endresult.gif)


## Activating audit
Activating Dataverse auditing it's possible to activate on an environment.

![audit setting](/images/20250403DataverseVersionHistory/adminsetting.png)

On table level activate the audit changed to its data:
![table setting](/images/20250403DataverseVersionHistory/tablesetting.png)


## Power Automate
The button needs to trigger a flow to retrieve the versions of the record.

![Flow](/images/20250403DataverseVersionHistory/Flow.png)

The HTTP request to get the audit details per record:
replace the organization url and table name matching with your own scenario. The tablename needs to be the logical name.

```
https://<<organisation>>.crm4.dynamics.com/api/data/v9.2/audits?$select=_objectid_value,objecttypecode,changedata,createdon,_userid_value&$filter=objecttypecode eq '<<tablename>>' and _objectid_value eq '@{triggerBody()['text']}'
```

The outcome doesn't contain the name of the user who made the change, so therefor some extra steps are needed.



## App set up
The button used to retrieve the version history of the selected item contains this PowerFx formula. It triggers the flow to fetch data, organizes it into a structured collection, and then generates another collection with row numbers to enable version sorting.

```powerfx
UpdateContext({varshowSpinner: true});

Clear(colVersionHistory);
Clear(colVersionHistoryNo);

Set(varversionhistoryinfo, 'Personal-getversionhistory'.Run(ThisItem.Camp).versionhistory);

If(Not(IsBlank(varversionhistoryinfo)),
Collect(
    colVersionHistory,
    ForAll(
        Table(ParseJSON(varversionhistoryinfo)) As _dataRows,
        {
            objectvalue: Text(_dataRows.Value.objectvalue),
            changedata: ForAll(
                Table(ParseJSON(Text(_dataRows.Value.changedata)).changedAttributes) As changed,
                {
                    oldValue: changed.Value.oldValue,
                    newValue: changed.Value.newValue,
                    logicalName: changed.Value.logicalName
                }
            ),
            createdon: DateTimeValue(_dataRows.Value.createdon),
            userfullname: Text(_dataRows.Value.userfullname),
            useremail: Text(_dataRows.Value.useremail)
        }
    )
));

// Generate row number code
Collect(
    colVersionHistoryNo,
    ForAll(
        Sequence(CountRows(colVersionHistory)),
        Patch(
            Last(FirstN(colVersionHistory, Value)),
            {RowNumber: Value}
        )
    )
);

UpdateContext({varShowVersionHistory: true});
UpdateContext({varshowSpinner: false});
```


The yaml code for the Version History popup:

```yaml
- conVersionHistory:
    Control: GroupContainer@1.3.0
    Variant: ManualLayout
    Properties:
      Fill: =RGBA(255, 255, 255, 1)
      Height: |+
        =600
      Visible: =varShowVersionHistory
      Width: =800
      X: =(Parent.Width- Self.Width) /2
      Y: =(Parent.Height - Self.Height)/2
    Children:
      - galVersions:
          Control: Gallery@2.15.0
          Variant: BrowseLayout_Flexible_SocialFeed_ver5.0
          Properties:
            Height: =galChangedData.Height + (CountRows(Self.AllItems) * 80)
            Items: =Sort(colVersionHistoryNo,RowNumber,SortOrder.Descending)
            TemplateSize: =galChangedData.Height + 60
            Width: =Parent.Width - Self.X - Self.X
            X: =txtTitle.X
            Y: =txtNo.Y + txtNo.Height
          Children:
            - galChangedData:
                Control: Gallery@2.15.0
                Variant: BrowseLayout_Vertical_TwoTextOneImageVariant_ver5.0
                Properties:
                  Height: =CountRows(Self.AllItems) * 40
                  Items: =ThisItem.changedata
                  TabIndex: =0
                  TemplateSize: =40
                  Width: =txtModifiedValue.Width
                  X: =txtModifiedValue.X
                  Y: =txtModifiedValue.Y + txtModifiedValue.Height
                Children:
                  - txtChangedValue:
                      Control: Text@0.0.50
                      Properties:
                        Text: =ThisItem.newValue
                        Width: =Parent.Width - txtlogicalName.Width
                        X: =txtlogicalName.X + txtlogicalName.Width
                        Y: =txtlogicalName.Y
                  - txtlogicalName:
                      Control: Text@0.0.50
                      Properties:
                        Text: =ThisItem.logicalName
                        Width: =Parent.Width/2
                        Y: =8
            - txtModifiedByValue:
                Control: Text@0.0.50
                Properties:
                  Text: =ThisItem.userfullname
                  Width: =txtModifiedBy.Width
                  X: =txtModifiedValue.X + txtModifiedValue.Width + 10
                  Y: =txtNoValue.Y
            - txtModifiedValue:
                Control: Text@0.0.50
                Properties:
                  FontColor: =RGBA(240, 98, 15, 1)
                  Text: =ThisItem.createdon
                  Width: =txtModified.Width
                  X: =txtNoValue.X + txtNoValue.Width + 10
                  Y: =txtNoValue.Y
            - txtNoValue:
                Control: Text@0.0.50
                Properties:
                  Text: =ThisItem.RowNumber
                  Width: =txtNo.Width
      - txtNoVersions:
          Control: Text@0.0.50
          Properties:
            Font: =
            Text: ="No extra versions available"
            Visible: =If(CountRows(colVersionHistory) = 0, true,false)
            Width: =Parent.Width - Self.X - Self.X
            X: =txtNo.X
            Y: =txtNo.Y + txtNo.Height
      - txtModifiedBy:
          Control: Text@0.0.50
          Properties:
            FontColor: =RGBA(240, 98, 15, 1)
            Text: ="Modified By"
            Weight: ='TextCanvas.Weight'.Semibold
            X: =txtModified.X + txtModified.Width + 10
            Y: =txtNo.Y
      - txtModified:
          Control: Text@0.0.50
          Properties:
            FontColor: =RGBA(240, 98, 15, 1)
            Text: ="Modified"
            Weight: ='TextCanvas.Weight'.Semibold
            Width: =500
            X: =txtNo.X + txtNo.Width + 10
            Y: =txtNo.Y
      - txtNo:
          Control: Text@0.0.50
          Properties:
            FontColor: =RGBA(240, 98, 15, 1)
            Text: ="No"
            Weight: ='TextCanvas.Weight'.Semibold
            Width: =50
            X: =txtTitle.X
            Y: =txtTitle.Y + txtTitle.Height + 20
      - txtTitle:
          Control: Text@0.0.50
          Properties:
            Height: =52
            Size: =24
            Text: ="Version History"
            Weight: ='TextCanvas.Weight'.Bold
            Width: =336
            X: =20
            Y: =20
      - btnClose:
          Control: Button@0.0.44
          Properties:
            Appearance: ='ButtonCanvas.Appearance'.Secondary
            FontColor: =RGBA(240, 98, 15, 1)
            Icon: ="Dismiss"
            Layout: ='ButtonCanvas.Layout'.IconOnly
            OnSelect: =UpdateContext({varShowVersionHistory:false})
            Width: =32
            X: =Parent.Width - Self.Width - 10
            Y: =10
```

## Summarize
This way you can have the same version history layout and look-and-feel in a Power App based on Dataverse data like there is by default in SharePoint.
![Versions](/images/20250403DataverseVersionHistory/versions.png)
