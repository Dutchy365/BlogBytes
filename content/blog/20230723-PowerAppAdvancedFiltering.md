---
author: Elianne Burgers
title: "Power Apps: Advanced filtering on a period of time with only Month and Year value"
date: 2023-07-22
description: Guide to create from to filters based on Month/ Year values only
tags:
  - Power Apps
  - filtering gallery
  - month year
  - collection
thumbnail: /blog/images/20230723PowerAppAdvancedFiltering/00AdvancedFiltering.png
preview: /blog/images/20230723PowerAppAdvancedFiltering/00AdvancedFiltering.png
---

## Scenario
Todays scenario is regarding filter options based on Month and Year values in Power Apps. In a Dataverse table named ‘Products’ the information of a Name, Month and Year are stored. The challenging part is the Month column only contains the text value of the short form of the month.

The data in the table looks like:


![table](/blog/images/20230723PowerAppAdvancedFiltering/1-table.png)


Now it needs to be possible to filter the gallery based on a Month Year range filter. There where some challenges to overcome of which the solutions are shared in this blog.

Solved challenges:
* Month value is short text value of the month, like Jan, Aug, Dec.
* Over time there will be more years added 
* Datepicker as filter selection doesn’t meet requirements, because specific date isn’t relevant, only Month and Year 

## End result
The end result looks like this: 

![End Result](/blog/images/20230723PowerAppAdvancedFiltering/2-FilterMonthYearValueGIF.gif)

## Step by step
There are some steps to take in order to get the end result you want to have. 

### Store data
It starts with storing the data in the Products table. The Form to enter data contains only three fields and a save button:

![Example Form](/blog/images/20230723PowerAppAdvancedFiltering/3-ExampleForm.png)

The Month Value is a choice column for which the values can be selected by using a ComboBox:

![Month Combobox](/blog/images/20230723PowerAppAdvancedFiltering/4-MonthCombobox.png)

Year is a column of type Number.

In the Dataverse table an extra Number column is created, named MonthYearValue. While saving records this column needs to be updated. Based on the formula: <kbd>(Year * 100 + Month numeric value)</kbd>. The user only selects a month by the ComboBox, so the calculation needs to be made while saving the record. 

### Magic in the Patch formula 
The magic happens in the Patch formula, by creating a Switch between the selected Month and the related number of the Month.

```json
Patch(
    Products,
    Defaults(Products),
    {
        Name: txtProduct.Text,
        Month: cmbMonth.Selected.Value,
        Year: Value(txtYear.Text),
        MonthYearValue: Sum(
            Value(txtYear.Text) * 100 + Switch(
                Text(cmbMonth.Selected.Value),
                "Jan",1,
                "Feb",2,
                "Mar",3,
                "Apr",4,
                "May",5,
                "Jun",6,
                "Jul",7,
                "Aug",8,
                "Sep",9,
                "Oct",10,
                "Nov",11,
                "Dec",12,
                0
            )
        )
    }
);

```

An example of input and what’s saved in the table. When an user enters the following in to the form and clicks on save:


![Example Form input](/blog/images/20230723PowerAppAdvancedFiltering/5-ExampleFormInput.png)

In the Dataverse table the column MonthYearValue is populated:

![Dataverse table populated](/blog/images/20230723PowerAppAdvancedFiltering/6-DataverseTable.png)

Now all items in the table have a MonthYearValue which can be used to filter on. Next step is to set up the filters.

### Collection with dynamic Month Year values
There needs to be a collection which can be used in the ComboBoxes. 
The collection needs to be flexible based on the unique Year values that are available in the Products table. So first step is to get Distinct values of the Years and use UpdateContext to store those values. Next step in the collection is to loop through all those years and get all months for those years. In a separate column of the collection the calculation is made to be used to filter on, again the formula: <kbd>(Year * 100 + Month numeric value)</kbd>.

```json
UpdateContext({Years: Distinct(Products,Year)});

Clear(ColMonthYearFilter);
ForAll(
    Sequence(Count(Years), Min(Years,Value)) As Year,
ForAll(
        Sequence(12),
        Collect(
            ColMonthYearFilter,
            {
                Month: Value,
                MonthYear: Concatenate(Last(FirstN(Calendar.MonthsShort(),Value)).Value, " ",
                    Year.Value),
                Year: Year.Value,
                Calculation: Sum((Year.Value * 100) + Value)
            }       
    )
));
```

The content of the collection:


![Content of Collection](/blog/images/20230723PowerAppAdvancedFiltering/7-CollectionContent.png)

### Comboboxes as filters
Create two ComboBoxes and set Items to the name of the collection, in this example ‘ColMonthYearFilter’. One ComboBox to use for the Month From and one for Month To. 

![Filter Comboboxes](/blog/images/20230723PowerAppAdvancedFiltering/8-FilterComboboxes.png)


### Gallery filtering
In the Gallery you need to setup the filter for the items. In this scenario all the items needs to be shown when no filter is active and when filters are set the gallery needs to display the filtered items. 
In Items of the gallery the following formula is used.

````json
Sort(
    Filter(
        Products,
        (cmbMonthFrom.Selected.Calculation = Blank() Or cmbMonthTo.Selected.Calculation = Blank()) 
        Or (MonthYearValue >= cmbMonthFrom.Selected.Calculation And MonthYearValue <= cmbMonthTo.Selected.Calculation)
    ),
    MonthYearValue
)

`````

And now the users is able to filter the gallery on Month/Year values!