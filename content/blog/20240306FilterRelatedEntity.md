---
author: ""
title: "Power Apps Canvas: filter data of related entity"
date: 2024-03-06
description: Filter gallery with values from related entity
tags:
  - Power Apps
  - filter
  - With function
  - related entities
thumbnail: /images/20240306FilterRelatedEntity/00FilterRelatedEntity.png
preview: /00FilterRelatedEntity.png
---


## Scenario

In the following scenario there is reservation system of different type of housing. For all housings there is an apartment type registered, which are stored in a different table.
In the overview of the reservation you want to be able to filter on apartment type and related capacity.

![Screen overview](/images/20240306FilterRelatedEntity/1-ScreenOverview.png)

This blog describes how to filter a gallery based on values from related entities.

### Database model

To get a proper insight of the data structure, the database architecture looks like this:

![Database Tables](/images/20240306FilterRelatedEntity/2-DatabaseTables.png)

The challenge is to filter the ApartmentReservations based on the values from ApartmentTypes for which there is no direct relation to those two tables.


![Database Tables](/images/20240306FilterRelatedEntity/2a-DatabaseTablesFilter.png)


<details>
<summary>Tables</summary>
The example content of the tables in Dataverse

ApartmentType
![Database Tables](/images/20240306FilterRelatedEntity/3-TableApartmentType.png)

Apartment
![Database Tables](/images/20240306FilterRelatedEntity/4-TableApartment.png)

ApartmentReservations
![Database Tables](/images/20240306FilterRelatedEntity/5-TableApartmentReservation.png)
</details>

## End result
In the end result the user is able to filter on both type and capacity.
If there is no housing available of chosen type and capacity, the gallery needs to be empty.

![Filter Endresult](/images/20240306FilterRelatedEntity/6-EndresultFilterRelatedEntity.gif)


## Create filters of comboboxes
The filters are created using combobox and Item values as choice options.
![Filter Endresult](/images/20240306FilterRelatedEntity/7-Filter.png)


## Formula in the gallery items using With
The gallery shows the relevant data.
The columns Type and Capacity have specific formula to show the data, due to the fact the information comes from the ApartmentTypes table and not the ApartmentReservation table of which the data is shown primarily.

```
LookUp(Apartments, Name = ThisItem.Apartment.Name).ApartmentType.Type
```
![Lookup formula](/images/20240306FilterRelatedEntity/8-Lookup.png)

The Items property of the gallery contains the formula so the shown items are in line with the chosen filters.

![Gallery Items](/images/20240306FilterRelatedEntity/9-GalleryItems.png)


```
With({ApartmentTypes: 
        Filter(ApartmentTypes, 
        (cmbFilterCapacity.Selected.Value = Blank() Or Capacity = cmbFilterCapacity.Selected.Value),
        (cmbFilterType.Selected.Value = Blank() Or Type = cmbFilterType.Selected.Value)).ApartmentType
    },
    If(CountRows(ApartmentTypes) > 0,
    With({Apartments: Filter(Apartments,
                ApartmentType.ApartmentType in ApartmentTypes).Apartment
        },
       With({Reservations: Filter(
                    ApartmentReservations,
                    Apartment.Apartment in Apartments                   
                    )
            },
            Sort(
                Reservations,
                Apartment.Name,
                SortOrder.Ascending
            )
        )
    )
)
)
```


Explanation of the steps in the formula:
1. Filter the ApartmentType table with the values from the Type and/or Capacity combobox and store the outcome in the local variable using the With.
2. The check <kbd>If(CountRows(ApartmentTypes) > 0</kbd> is added so if the outcome of doesn't give back any result, the rest of the function doesn't need to be performed. 
3. Based on this variable the Apartment table can be filtered with relevant Apartments who have to correct ApartmentTypes
4. Next step is to finally filter the ApartmentReservation table based on the outcome of the filtered Apartments.
5. Last step is to properly sort the items of the reservations, in this case sorted ascending on the name of the apartment.

Advantages of using the With formula is to improve the readability of this large formula, so the steps are easy to read and the process of the data can be followed.

## Tips and tricks
* Create database architectural overviews easily using: https://dbdiagram.io/d
* [Official explanation of the With function in Power Apps](https://learn.microsoft.com/en-us/power-platform/power-fx/reference/function-with)