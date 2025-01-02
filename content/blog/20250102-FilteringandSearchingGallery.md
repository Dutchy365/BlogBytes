---
author: ""
title: "Filter and search data in a gallery"
date: 2025-01-02
description: "Multiple filters and search options explained"
tags:
  - Power Apps
  - Gallery
  - Filtering
  - Search
  - Combobox
thumbnail: /images/20250102FilteringSearching/00Filtersearch.png
preview: /00Filtersearch.png
images: 
- /00Filtersearch.png
---


## Scenario

One of the features often used in Power Apps is the gallery, which typically requires filtering and search functionality. Initially, you might set up a gallery with just two filters and a search box. However, as you continue developing, end-users often request additional filtering options. Time and time again, I found it challenging to easily implement these extra filters. That's when I realized it was time to document my approach; hopefully, you can benefit from it too.

## End result

The end result contains of a gallery and multiple comboboxes and a searchbox to filter the data on.

![endresult](/images/20250102FilteringSearching/endresult.gif)

## Setup

In this scenario there is a table with application records with multiple lookup columns.
To easily filter on the values of lookup columns the AddColumns is used to add columns with the specific lookup value. 

Comboboxes are added to be able to filter the data and a text input to enter the search query. 

![filters](/images/20250102FilteringSearching/filters.png)


### Single selected filters

To filter the data based on a single selection in the comboboxes the following PowerFx can be applied.

![single select](/images/20250102FilteringSearching/singleselect.png)

```json
Sort(
    With({ActiveItems: AddColumns(Applications, 'Status application', 'Application Status'.'Status Name', 'Approved by',ApprovalBy.'Full Name', 'Faculty name', Faculty.'Faculty Name') },

            Filter(ActiveItems, 
                  (IsBlank(cmbStatus.Selected.'Status Name') || 'Status application' in cmbStatus.Selected.'Status Name') &&
                  (IsBlank(cmbFilterFaculty.Selected.'Faculty Name') || 'Faculty name' = cmbFilterFaculty.Selected.'Faculty Name') &&
                  (IsBlank(cmbFilterApprovedBy.Selected.Value) || 'Approved by' = cmbFilterApprovedBy.Selected.Value) &&
                  (IsBlank(cmbFilterType.Selected.'Application Type') || Type.'Type Name' = cmbFilterType.Selected.'Type Name')
           &&
            (
                txtSearchInput.Text in 'Application Title' || 
                txtSearchInput.Text in Status ||
                txtSearchInput.Text in 'Approved by' ||
                txtSearchInput.Text in 'Faculty name'||
                txtSearchInput.Text in Case
            )

        )
    ), 
    'Created On', If(SortModified, SortOrder.Ascending, SortOrder.Descending)
)
```

If no selection is made (IsBlank), no filter will be applied to that field, so all records will be shown.



### Multi selected filters
On the comboboxes the multi select can be set on true, therefor the PowerFx needs to be adjusted to work with multiple filter values.

To allow for multiple selections in the combobox (for example cmbStatus), you'll need to adjust the formula so it checks if any of the selected values in the cmbStatus dropdown are present in the 'Status application' field for each record.

In Power Fx, if you want to handle multiple selections in a ComboBox (like cmbStatus), you can use the `in` operator combined with the .SelectedItems property of the ComboBox, which contains a list of selected values.


![multiselect](/images/20250102FilteringSearching/multiselect.png)

```json
Sort(
    With(
        {ActiveItems: AddColumns(
            Applications, 
            'Status application', 
            'Application Status'.'Status Name', 
            'Approved by', ApprovalBy.'Full Name', 
            'Faculty name', Faculty.'Faculty Name'
        )},
        Filter(
            ActiveItems, 
            (IsBlank(cmbStatus.SelectedItems) || CountRows(cmbStatus.SelectedItems) = 0 || 'Status application' in cmbStatus.SelectedItems.'Status Name') &&
            (IsBlank(cmbFilterFaculty.Selected.'Faculty Name') || CountRows(cmbFilterFaculty.SelectedItems) = 0 || 'Faculty name' in cmbFilterFaculty.SelectedItems.'Faculty Name') &&   
            (IsBlank(cmbFilterApprovedBy.Selected.Value) || CountRows(cmbFilterApprovedBy.SelectedItems) = 0 || 'Approved by' in cmbFilterApprovedBy.Selected.Value) &&           
            (IsBlank(cmbFilterType.SelectedItems) || CountRows(cmbFilterType.SelectedItems) = 0 || Type.'Type Name' in cmbFilterType.SelectedItems.'Type Name')             
            &&         
            (
                txtSearchInput.Text in 'Application Title' || 
                txtSearchInput.Text in Status ||
                txtSearchInput.Text in 'Approved by' ||
                txtSearchInput.Text in 'Faculty name' ||
                txtSearchInput.Text in Case
            )
        )
    ), 
    'Created On', 
    If(SortModified, SortOrder.Ascending, SortOrder.Descending)
)
```

## Result
If nothing is selected, it will not filter records and all records will be displayed. If selections are made, it filters based on those selected values.
This ensures that if a ComboBox is left empty, it behaves as if no filter is applied, and all records are shown for that field.
The same applies for the search input, if empty no filter is applied, if populated the value is search in selected columns.

This way you can easily and flexible filter the data and when there is a request to add a new filter, this can be implemented quickly.