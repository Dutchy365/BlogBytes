---
author: ""
title: "Rich text columns and Power Pages list view: HTML sanitization"
date: 2024-01-29
description: How to transform the rich text column in a list view to properly show the content in Power Pages
tags:
  - Power Pages
  - JavaScript
  - jQuery
  - Sanitize HTML
  - RTE
  - Rich Text Editor
thumbnail: /images/20240129PowerPagesRichTextListView/00RichTextPowerPages.png
preview: /00RichTextPowerPages.png
images: 
- /00RichTextPowerPages.png
---


Working with a Rich Text column can be tricky. In a Model Driven App, handling Rich Text columns is easy. In a view the text is shown as plain text; simple and readable. In the Power Pages list view, it's not great. It ends up showing messy raw HTML instead of the neat content.


#### The view of in Model Driven App:
![View in MDA](/images/20240129PowerPagesRichTextListView/MDAview.png)


#### The view of the list in Power Pages:

![View in Power Pages](/images/20240129PowerPagesRichTextListView/PowerPagesview.png)

Certainly, there was the option to remove the column from the view, but that wasn't the appropriate solution in this case.

## JavaScript (jQuery) to the rescue
Go the the Lists and select the list view in which you have a Rich Text Column and select the tab Options.
![Options tab](/images/20240129PowerPagesRichTextListView/ListOptions.png)

In there you can add you on JavaScript. This code cleans and replaces the HTML content of the description column within each row of the targeted element when the "loaded" event occurs.

In this case the internal name of the columns is 'cr4c5_description'. If you want to use this in you're own scenario, please be aware of replacing this to your own column name.

```javascript
$(document).ready(function (){
	var entityList = $(".entitylist.entity-grid").eq(0);
	entityList.on("loaded", function () {
		entityList.find("table tbody > tr").each(function (index, tr) {
         var descriptionColumnHtml = $(tr).find('td[data-attribute="cr4c5_description"]').html();
         var temporaryElement = $('<div>').html(descriptionColumnHtml);
         var descriptionColumnText = temporaryElement.text();
			   $(tr).find('td[data-attribute="cr4c5_description"]').html(descriptionColumnText);
        });
	});
});
```

## End result

Now, the view in Power Pages looks fantastic—even better than in the Model Driven App. The selected styling is visible immediately and even the hyperlink works.

![Options tab](/images/20240129PowerPagesRichTextListView/PowerPagesviewEndResult.png)
 


## Tips
* To be able to use a rich text field in a Power Pages form Microsoft has an explanation to achieve this on [Microsoft Learn](https://learn.microsoft.com/en-us/power-pages/configure/component-rte-tutorial)
