---
author: ""
title: "PowerFx: Overcome time zone conversion error in Dataverse Formula column"
date: 2024-05-02
description: Time zone adjustment setting
tags:
  - Dataverse
  - Power Fx
  - Time zones
thumbnail: /images/20240502DataverseFormulaDate/00DataverseFormulaDate.png
preview: /00DataverseFormulaDate.png
images: 
- /00DataverseFormulaDate.png
---


## Scenario
In a Dataverse table you have a date column of which you want to extract the Year, Month, Day or Weekday using a Formula column. While doing this the following error appears: 
"_cannot be performed on this input without a time zone conversion, which is not supported in formula columns._"


![Error message](/images/20240502DataverseFormulaDate/01-errormessage.png)



## Solution
Go to the created Date column and check the 'Time zone adjustment'. It's probably set to 'User local'.
Switch the Time zone adjustment (Advanced options) to 'Time zone independent' or 'Date only'.

![Time zone adjustment](/images/20240502DataverseFormulaDate/02-timezoneadjustment.png)

Now it's no longer a problem to use the Year, Month, Day, Weekday into the newly created formula column:

![Formula](/images/20240502DataverseFormulaDate/03-formula.png)


## Tips and tricks
* Be aware: changes to the 'time zone adjustment' settings on a column can be made once. After that it's not changeable back and forward anymore.
* Weekday: the weekday value of a date will be returned as a numeric value. To retrieve the full name of the day, you can use this formula (replace Date for the name of your date column): 

```
If(Weekday(Date) = 1, "Sunday", If(Weekday(Date) = 2, "Monday",If(Weekday(Date) = 3, "Tuesday", If(Weekday(Date) = 4, "Wednesday",If(Weekday(Date) = 5, "Thursday", If(Weekday(Date) = 6, "Friday", If(Weekday(Date) = 7, "Saturday", "")))))))
```
