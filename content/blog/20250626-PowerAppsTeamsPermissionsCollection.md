---
author: null
title: "Power Apps: Flexible security setup based on Power Platform Teams"
date: 2025-06-26
description: Guide how to set view and edit permissions based on Team user is member of
tags:
  - Power Apps
  - permissions
  - Dataverse
  - Teammember
thumbnail: /images/20250626PowerAppsTeamsPermissionsCollection/00TeamsPermissions.png
preview: /00TeamsPermissions.png
keywords:
  - Power Apps
  - permissions
---


## Scenario

The Power App Canvas stores information about multiple products that a company sells. Product managers are responsible for their own product, so that product they need to be able to edit and only view other products. 

As data source Dataverse is used, so of course row level security can be applied on the table level, but in the app the user feedback needs to be clear that they are not able to edit product information that they are not allowed of.

The setup requires maximum flexibility, because resources and products can change over time.

## End result of the screen
In this scenario the user is product manager for the Apple products, but needs to be able to see the information of the other products.


![EndResult Gallery Display Mode](/images/20250626PowerAppsTeamsPermissionsCollection/1-EndresultGalleryDisplayMode.gif)


## Teams in Dataverse

In the Power Platform admin center create the Teams for which you want to differentiate permissions: 

![Team](/images/20250626PowerAppsTeamsPermissionsCollection/2-Team2.png)


## Power App
In the Power App add the Users table as Data.


![Data Users table](/images/20250626PowerAppsTeamsPermissionsCollection/3-UsersTable.png)


The following Power Fx formulas are need to decide the Teams of which the logged in user is member of. The ‘Team teammembership association’ stores that information. The collection colUserTeams now has a lot of metadata available of those Teams, but the name of the Team isn’t part of it. 

So next step is needed to loop through all the Teams and get the Team name and store that in a separate collection.

Following action is to create a collection of the details names of the Product the product manager needs permissions. 

![Permissions Collection](/images/20250626PowerAppsTeamsPermissionsCollection/4-PermissionCollection.png)

````
//Get current user info
Set(varUser, User());
Set(CurrentUser,LookUp(Users,'Primary Email' = varUser.Email));

//Get Teams User is Member of
ClearCollect(colUserTeams, CurrentUser.'Teams (teammembership_association)');

//Create collection in which Team Names are stored
Clear(colTeamNames);
ForAll(colUserTeams,
    Collect(colTeamNames,
        {
            Name: ThisRecord.'Team Name',
            Id: ThisRecord.Team
        }
    )
);
Clear(colUserTeams);

ClearCollect(colPermissionsProduct, Blank());
//Check if the Team name is available in the colTeamNames, if so: add Products to colPermissions accordingly
If("ProductManagerApple" in colTeamNames.Name,
    Collect(
        colPermissionsProduct,
        {Value: "Elstar"},
        {Value: "Pink Lady"},
        {Value: "Jonagold"}
    )
);
If("ProductManagerPear" in colTeamNames.Name,
    Collect(
        colPermissionsProduct,
        {Value: "Comice"},
        {Value: "Green Anjou"}
    )
);
If("ProductManagerBanana" in colTeamNames.Name,
    Collect(
        colPermissionsProduct,
        {Value: "Banana"}
    )
);

`````


The end result is a collection in which the products are mentioned:


![Content Permission Collection](/images/20250626PowerAppsTeamsPermissionsCollection/5-ContentPermissionCollection.png)

## Gallery and Form
In the gallery the available products are visible and selectable. The Form contains two fields, that based on the selected products needs to be editable or not. 
The OnSelect of the Gallery:

![Set DisplayMode](/images/20250626PowerAppsTeamsPermissionsCollection/6-SetDisplaymode.png)

````
Set(varProductSelected, ThisItem);
If(
    (varProductSelected.Product in colPermissionsProduct.Value),
    UpdateContext({DisplayModeProductManager: DisplayMode.Edit}),
    UpdateContext({DisplayModeProductManager: DisplayMode.View})
);
````


The formula checks if the selected product is available in the collection, if so the DisplayMode can be set to Edit, otherwise it needs to be View only.

And off course the DisplayMode of the Product related fields are set to ‘DisplayModeProductManager’.

![DisplayMode](/images/20250626PowerAppsTeamsPermissionsCollection/7-Displaymode.png)

This setup up makes it possible to be flexible in the way users can view all data, but only edit data they are responsible for. To setup the security accordingly, please reconsider also the use of row-level security.