---
author: 
title: "Using SharePoint column formatting together with the lookup column and special characters (% and #)"
date: 2023-11-17
description: Guide how to overcome special characters in SharePoint lookup column
tags:
  - SharePoint
  - column formatting
  - SharePoint list
  - lookup column
thumbnail: /images/20231117SharePointColumnFormSpecialChar/00SPColumnFormSpecialChar.png

---



The capabilities of SharePoint regarding column and view formatting can enhance the usability of both SharePoint libraries and list.
In this blog the explanation using a lookup column and the challenging part regarding the use of special characters. 

## Scenario
The SharePoint list has a lookup column to a document library, so a link between the list item and associated document can be made. At first glance, this looked fine:


![First glance](/images/20231117SharePointColumnFormSpecialChar/1-firstglance.png)

However when you clicked on the file link, the file didn’t open, but navigated to the display form of the library item instead. 

![Display Form](/images/20231117SharePointColumnFormSpecialChar/2-displayform.png)

Next step is to format the column so the document itself will be opened.

![Column formatting](/images/20231117SharePointColumnFormSpecialChar/3-columnformatting.png)

See below the JSON used (don't forget to replace <<sitename>>  and <<name of library>> with values applicable to your scenario)

````json
{
  "$schema": "https://developer.microsoft.com/json-schemas/sp/v2/column-formatting.schema.json",
  "elmType": "a",
  "attributes": {
    "class": "ms-fontColor-themePrimary ms-fontColor-themeDark--hover",
    "target": "_blank",
    "href": "='/sites/<<sitename>>/<<name of library>> /' + @currentField.lookupValue + '?web=1'"
  },
  "style": {
    "border": "none",
    "background-color": "transparent",
    "cursor": "pointer",
    "text-decoration": "none"
  },
  "children": [
    {
      "elmType": "span",
      "txtContent": "@currentField.lookupValue"
    }
  ]
}

````


## Special characters percentage sign % and # hashtag
This way to go works fine, as long as the lookup value does not contain special characters like percentage sign or a hashtag.

![Special character](/images/20231117SharePointColumnFormSpecialChar/4-specialcharacter.png)

If you then want to open the document, an error message appears: 'Bad Request - Invalid URL' or 'The resource cannot be found'.


![Error](/images/20231117SharePointColumnFormSpecialChar/5-error.png)

To solve this, the special characters have to be replaced, in the case of the percent sign it is %25 and for the hashtag it is %23. The column formatting now looks like this:

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/sp/v2/column-formatting.schema.json",
  "elmType": "a",
  "attributes": {
    "class": "ms-fontColor-themePrimary ms-fontColor-themeDark--hover",
    "target": "_blank",
    "href": "='/sites/<<sitename>>/<<library name>>/' + replaceAll(replaceAll(@currentField.lookupValue, '%', '%25'), '#', '%23') + '?web=1'"
  },
  "style": {
    "border": "none",
    "background-color": "transparent",
    "cursor": "pointer",
    "text-decoration": "none"
  },
  "children": [
    {
      "elmType": "span",
      "txtContent": "@currentField.lookupValue"
    }
  ]
}

```

In this way, documents that have a value with a special character can also be opened without any problems.

## Some points of interest: 
* The '@currentField.lookupValue' retrieves the title field of the document. In this example, the file name and file type are stored directly in the title field.
* Setting '?web=1' after it, opens all files in the online view, even if they still have the old 'doc' file extension.
