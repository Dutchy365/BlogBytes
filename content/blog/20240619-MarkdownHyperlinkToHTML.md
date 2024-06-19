---
author: ""
title: "From Markdown syntax hyperlink to HTML link"
date: 2024-06-19
description: How transform Markdown notation to clickable HTML formatted link
tags:
  - Power Apps
  - Markdown
  - Hyperlink
thumbnail: /images/20240619MarkdowntoHTMLHyperlink/00MarkdowntoHTML.png
preview: /00MarkdowntoHTML.png
images: 
- /00MarkdowntoHTML.png
---

# Scenario
This blogs scenario is regarding a plain multi line text input in which no rich text was allowed. Requirement was just one exception to have the ability to have clickable hyperlinks.

In the Dataverse table no html is stored only plain text, so using a markdown syntax notation was the solution. 

Markdown syntax for a hyperlink is square brackets followed by parentheses. The square brackets hold the text, the parentheses hold the link.
```
`[Link text Here](https://link-url-here.org)`
``` 

# One link as input
In the textinput you can add your text and add a link using Markdown syntax.
In case there is just one link, the Match is quite straightforward to make.

![One Link](/images/20240619MarkdowntoHTMLHyperlink/onelink.gif)

## MatchAll and regular expression
Use MatchAll and a regular expression `\[(.*?)\]\((.*?)\)`. 
This regular expression is used to find patterns of Markdown links within the string. 

### Input
This example, the input string is:
```
On this website you can learn new things [Microsoft](learn.microsoft.com).
```

The MatchAll returns a table where each row corresponds to a match, and each match has columns: FullMatch for the link, one for StartMatch as the text position and one Submatches as table.

![MatchAll](/images/20240619MarkdowntoHTMLHyperlink/1a-matchall.png)
The submatches look like this, in which the link text and actually link are in two separate rows:
![Submatches](/images/20240619MarkdowntoHTMLHyperlink/1b-matchallSubmatches.png)

### Output
Output string is:
```
"On this website you can learn new things <a href=\"https://learn.microsoft.com\">Microsoft</a>."
```
This output can be used in a HTML element to have the clickable link to an external of internal location. 

## PowerFx

Complete code which is behind the OnSelect property of the button:
```json
ClearCollect(
    colMatchOneLink,
    MatchAll(
        txtInputOneLink.Value,
        "\[(.*?)\]\((.*?)\)"
    )
);
Set(
    varOutPutHTMLOneLink,
    Substitute(
        txtInputOneLink.Value,
        First(colMatchOneLink).FullMatch,
        Concatenate(
            "<a href=""" & If(
                StartsWith(
                    Last(First(colMatchOneLink).SubMatches).Value,
                    "https://"
                ),
                Last(First(colMatchOneLink).SubMatches).Value,
                "https://" & Last(First(colMatchOneLink).SubMatches).Value
            ) & """>" & First(First(colMatchOneLink).SubMatches).Value & "</a>"
        )
    )
);  
```

Read some [more detailed explanation](#hyperlink) about the reason why 'https://' is added. 


# Multiple links as input
The one link input approach asked for more...
Multiple links in the input string. Therefor the MatchAll wasn't the challenge.
The MatchAll just results in multiple rows. The challenge regarding replacing the multiple links into one output string.
Due to the fact the ForAll in PowerFx can't update a variable inside the loop, we need to come up with a different approach.

![Mulitple links](/images/20240619MarkdowntoHTMLHyperlink/multiplelinks.gif)


As you can see in the animation while modifying the text, it is still in Markdown syntax for the enduser. Both the plain text and the html formatted text is stored into the collection. 


## PowerFx
On the OnSelect of the Save button, the following PowerFx is executed:

```json
UpdateContext({varTextInput: txtInputPrompt.Value});

// Extract all matches and their positions
ClearCollect(
    colTextMatch,
    MatchAll(varTextInput,"\[(.*?)\]\((.*?)\)")
);

// Convert matches to HTML links and calculate their lengths
ClearCollect(
    colExtraColumns,
    AddColumns(colTextMatch,
        Link,
        "<a href=""" & If(
            StartsWith(Last(SubMatches).Value,"https://"),
            Last(SubMatches).Value,
            "https://" & Last(SubMatches).Value
        ) & """>" & First(SubMatches).Value & "</a>",

        wordLength,
        Len(ThisRecord.FullMatch)
    )
);

// Initialize the result collection
Clear(colResults);
// Iterate through the matches and build the result collection
ForAll(
    colExtraColumns As Result,
    With(
        {
            matchStart: Result.StartMatch,
            matchLength: Result.wordLength,
            previousEnd: If(CountRows(colResults) = 0, 1, Last(colResults).end + 1)
        },
        Collect(
            colResults,
            {
                type: "text",
                content: Mid(varTextInput,previousEnd,matchStart - previousEnd),
                start: previousEnd,
                end: matchStart - 1
            },
            {
                type: "link",
                content: Result.Link,
                start: matchStart,
                end: matchStart + matchLength - 1
            }
        )
    )
);

// Append any remaining text after the last match
If(
    Last(colResults).end < Len(varTextInput),
    Collect(
        colResults,
        {
            type: "text",
            content: Mid(varTextInput,Last(colResults).end + 1,Len(varTextInput) - Last(colResults).end),
            start: Last(colResults).end + 1,
            end: Len(varTextInput)
        }
    )
);
// Concatenate all values from the 'content' column into one string
UpdateContext({varOutputHTML: Concat(colResults,content)});

Clear(colResults);
Clear(colTextMatch);
Clear(colExtraColumns);

If(varCommentModify,   
    //Update current response
     Patch(colAnswers, galResponses.Selected,
          { 
        Name: User().FullName,
        Date: Now(),
        Answer: varTextInput,
        Response: varOutputHTML
    }),
    //Collect new response 
    Collect(colAnswers,
        { 
            Name: User().FullName,
            Date: Now(),
            Answer: varTextInput,
            Response: varOutputHTML
        }
    )
);

Set(varCommentModify, false);

Reset(txtInputPrompt);
```

### Convert all links
The formula matches the links in the text input and creates a collection in which the Markdown syntax links and converted HTML links are stored:

![Collection Columns](/images/20240619MarkdowntoHTMLHyperlink/2-colExtraColumns.png)

### Setup results
To setup the colResults it iterates through each match to construct a result collection that separates text and HTML links.
It uses text positions to split the input text into multiple rows.

![colResults](/images/20240619MarkdowntoHTMLHyperlink/3-colResults.png)

### Concatenate into one string
The last step concatenate all values from the 'content' column into one string
`UpdateContext({varOutputHTML: Concat(colResults,content)});`

To have the ability to have a thread of messages the results are stored into a collection. In this collection both plain input text as the HTML output is stored. The HTML output is used to display the text and the plain text is used when user wants to modify their answer.


# Hyperlink error {#hyperlink}
The HTML link may produce an error such as:
```
This authoring.eu-il108.gateway.prod.island.powerapps.com page can’t be found
```

This error happens when the link doesn't start with 'https://'. To avoid this issue, ensure the link starts with 'https://'. If it doesn't, add 'https://' to the link.

