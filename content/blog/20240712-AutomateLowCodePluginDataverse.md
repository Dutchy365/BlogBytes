---
author: ""
title: "Automated plugin: different triggers with different actions"
date: 2024-07-12
description: Dataverse low-code plugin collect, set and patch using different triggers
tags:
  - Power Apps
  - Dataverse
  - Plugin
  - Automated
thumbnail: /images/20240712AutomatedPlugin/00AutomatedPlugin.png
preview: /00AutomatedPlugin.png
images: 
- /00AutomatedPlugin.png
---

*Side note: As of writing this blog, Dataverse low-code plugins are still in preview.*

In the Dataverse Accelerator app, you have the opportunity to create plugins. This blog focuses on the possibilities of automated plugins.

After selecting a table, you can choose different types of triggers: when a row is created, updated, or deleted. To get information about existing records, you can't use `ThisItem` or `ThisRecord`, and `Set` behaves differently compared to Power Apps Canvas.

## Architecture and process
The tables:

![tables](/images/20240712AutomatedPlugin/tables.png)


In the *meeting*  table the original meeting date, times and location.
In the *sensor data*  table the sensor data is stored.
In the *meetingpresence* table is updated by the plugin.



## Use data to populate other table
You can use Collect to populate a row in another table based on the creation of a new row.
![create trigger collect](/images/20240712AutomatedPlugin/createtriggercollect.png)


```json
Collect(MeetingPresences, {
    Location: NewRecord.Location, 
    'Start Date':NewRecord.Startdate, 
    'End Date': NewRecord.Enddate, 
    Presence:If(CountRows(Filter('Sensor data',RecordedTime >= NewRecord.Startdate && RecordedTime <= NewRecord.Enddate && Location = NewRecord.Location && PresenceValue = 1))> 0, "Yes","No")
    }
)
```

Using 'Patch' instead of 'Collect' will give an error while adding a new row in the table: "There was an error in saving this record. Not implemented: Patch single record is invalid for tables/records with no primary key."

For more details, check the [full blog about populating a new row in a different table](/blog/20240707-DataverseLowCodePlugin/)

## Populate column in newly created row
To update a value in the newly created row, you can use `Set`. 
In this example the 'occupation' column is of type text and the 'occupied' column is a boolean type.

![create trigger collect](/images/20240712AutomatedPlugin/set.png)


### Update text column
<code>
Set(NewRecord.Presence,
If(CountRows(Filter('Sensor data',RecordedTime >= NewRecord.Startdate && RecordedTime <= NewRecord.Enddate && Location = NewRecord.Location && PresenceValue = 1))> 0, "Yes","No"))
</code>

### Update boolean column
<code>
Set(NewRecord.Occupied,If(CountRows(Filter('Sensor data',RecordedTime >= NewRecord.Startdate && RecordedTime <= NewRecord.Enddate && Location = NewRecord.Location && PresenceValue = 1))> 0, 'Occupied (Meetings)'.Yes,'Occupied (Meetings)'.No));
</code>



## Trigger deleted - OldRecord
On the trigger Deleted you can use the details of the deleted row. 
To get the details of the deleted record use OldRecord.


![Remove](/images/20240712AutomatedPlugin/deleted-remove.png)

In this example the meeting presence record with same meeting id as the deleted record in meetings table is removed.

<code>
Remove(MeetingPresences, LookUp(MeetingPresences,'Meeting ID' = OldRecord.crc36_meetingid))
</code>


Or update a record using Patch.
![Remove](/images/20240712AutomatedPlugin/deleted-patch.png)

<code>
Patch(MeetingPresences, LookUp(MeetingPresences, 'Meeting ID' = OldRecord.'Meeting ID'), {Presence: "2"})
</code>

By leveraging these triggers and actions, you can automate data processes in Dataverse efficiently. This approach enhances data integrity and in scenarios can replace a complex Power Automate Flow.