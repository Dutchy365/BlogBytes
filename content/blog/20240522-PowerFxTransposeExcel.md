---
author: ""
title: "Power Apps: Transpose Excel Data using Power Fx"
date: 2024-05-21
description: How to transpose Excel Data into a Collection
tags:
  - Power Automate
  - Power Fx
  - collection
  - JSON format
  - substitute
thumbnail: /images/20240522PowerFxTransposeExcel/00PowerFxTransposeExcel.png
preview: /00PowerFxTransposeExcel.png
images: 
- /00PowerFxTransposeExcel.png
---

A lot of business processes are supported by data stored in Excel sheets.
Working with Power Apps often eliminates the use of an Excel sheet, but in some cases the data needs to be stored into an Excel sheet.

In this blog the concept of transposing the data from an Excel table will be described, so you can use this data throughout the app.

# Scenario
As an input there is an Excel table in which there are multiple rows and multiple columns. The first column has the Country value in it and the other columns describes the products of that Country.

![Excel Table](/images/20240522PowerFxTransposeExcel/1-ExcelTable.png)

The end result is a gallery in Power Apps that can be filtered by country.

![Filter gallery transposed table](/images/20240522PowerFxTransposeExcel/2-EndResult.gif)


# Add Excel as data source
Store an Excel file into a SharePoint or OneDrive location. In this Excel the data must be converted into a table. It's helpful to give the table a proper name.
In this scenario: CountryProductTable

Select Excel as data source and navigate to the location of your Excel sheet and select the table you want to use.
![Select data source](/images/20240522PowerFxTransposeExcel/3-SelectDatasource.png)


## Load data into Collection
The data of the Excel is loaded into a collection named: <kbb>colExcelData</kbd>.
`ClearCollect(colExcelData, CountryProductTable);`

The original Excel data is now similar to the collection, both content wise as structure based on columns. 
![colExcelData](/images/20240522PowerFxTransposeExcel/4-colExcelData.png)

# Screen elements
On the screen a combobox is used to select a filter. 
In the Items property of the combobox the values of the Country column are shown: 
`SortByColumns(colExcelData, "Country", SortOrder.Ascending)`

![Items combobox](/images/20240522PowerFxTransposeExcel/comboboxItems.png)


# Load data from specific selection
The collection contains all data, but it needs to be filtered to the selected country.

`ClearCollect(colSelectedCountry, Filter(colExcelData, Country = cmbCountry.Selected.Country));`

The filtered collection contains the following data:

![colSelectedCountry](/images/20240522PowerFxTransposeExcel/5-colSelectedCountry.png)


## Transpose data using JSON
This table needs to be transposed so it can be displayed in the correct way in the gallery. 
First step is to format the collection into JSON:

`JSON(colSelectedCountry, JSONFormat.IgnoreBinaryData)`




The output of this part of the formula looks like:

```json
[{"Banana":"25","Country":"India","Kiwi":"12","Pear":"46","Pineapple":"174","Strawberry":"55"}]
```

The unnecessary characters needs to be substitute and for all separate results a new collections needs to be build which contains Product and Value.


![Formula](/images/20240522PowerFxTransposeExcel/6-Formula.png)

This needs to be added on the OnChange of the combobox.

```json
//Create collection based on selected Country
ClearCollect(colSelectedCountry, Filter(colExcelData, Country = cmbCountry.Selected.Country)); 

Clear(colTransposedCountryProduct);
ForAll(
    // create table of records in JSON format and substitute out the unneeded characters
        ForAll(Split(
        Substitute(
            Substitute(
                Substitute(                      
                        Substitute(                          
                            JSON(
                                colSelectedCountry,
                                JSONFormat.IgnoreBinaryData
                            ),                            
                            "[",
                            ""
                        ),
                        "{""",
                        ""
                    ),
                    """}",
                    ""
                ),
                
                "]",
                ""         
        ),
        ""","""  
    ), {Result: ThisRecord.Value}),
    // Transpose data
    Collect(
        colTransposedCountryProduct,
        { 
            Product: Substitute(Left(
                ThisRecord.Result,
                Find(
                    ":",
                    ThisRecord.Result
                ) - 1
            ), """", ""), 
            Value: Substitute(Mid(
                ThisRecord.Result,               
                Find(
                    ":",
                    ThisRecord.Result
                ) + 1
            ), """", "")
        }
    )
);

//The value for country is also set as a Product, this needs to be removed from the collection
Remove(colTransposedCountryProduct, LookUp(colTransposedCountryProduct, Product = "Country"));
```

The output of this formula results in a collection in which also the Country value is set as a product.

![Transposed table](/images/20240522PowerFxTransposeExcel/7-colTransposedTable.png)


Last step is to filter out the country as a valid value:

`Remove(colTransposedCountryProduct, LookUp(colTransposedCountryProduct, Product = "Country"));`






# End result
The formula is ready and the filtering can be made!
![Filter gallery transposed table](/images/20240522PowerFxTransposeExcel/2-EndResult.gif)


# A disclaimer is needed as well... 
Using Excel as a datasource for Power Apps is easy and accessible, but it has some downsides. Excel isn't built for handling large amounts of data or complex relationships, which can slow down your app. It also has limitations with data security and handling multiple users at once. For more reliable and secure applications, consider using Dataverse or other advanced data solutions. Always assess your project's needs and choose the best data source.
