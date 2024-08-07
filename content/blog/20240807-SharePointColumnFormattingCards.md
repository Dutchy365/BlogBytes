---
author: ""
title: "SharePoint column formatting: visualize status cards"
date: 2024-08-07
description: Hover over the status value to get more details regarding the progress
tags:
 - SharePoint
  - column formatting
  - SharePoint list
  - status column
thumbnail: /images/20240807SPColumnFormattingHoverCards/00SPFormattingHoverCards.png
preview: /00SPFormattingHoverCards.png
images: 
- /00SPFormattingHoverCards.png
---


A visually appealing presentation helps in swiftly and clearly grasping information at a glance. Users can capture a lot of information in SharePoint, where you can stick to just capturing it, but by taking a moment to consider the possibilities of view, row and column formatting, users can realize significant benefits.

One common data element frequently recorded in a column is the "status". By using the standard column formatting nowadays you can easily assign a different color to each status:


![Advanced mode](/images/20240807SPColumnFormattingHoverCards/1-advanced.png)


## Advanced mode
By switching to advanced mode, the possibilities are endless.
The first option I added is an icon per state, so that in addition to the color usage, the icon also provides insight. This can be done by working within the various data with if-statements that can change per status, both for the icon and the color the if-statements are created.

One of the initial options introduced is the inclusion of an icon for each state. In addition to utilizing colors, these icons offer further insight into the status. This is achieved by manipulating the data using if-statements tailored to each status, enabling dynamic changes in both the icon and color based on the specified conditions.



![Formatting](/images/20240807SPColumnFormattingHoverCards/2-formatting.png)

The json used to get this view: 

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/sp/v2/column-formatting.schema.json",
  "elmType": "div",
  "children": [
    {
      "elmType": "span",
      "attributes": {
        "class": "ms-fontColor-themePrimary ms-fontColor-themeDarker--hover",
        "iconName": "=if([$Status] == 'New', 'Asterisk', if([$Status] == 'Tender', 'AccountActivity', if([$Status] == 'Planning', 'PenWorkspace', if([$Status] == 'In progress', 'WorkFlow', if([$Status] == 'Monitoring', 'Flow', if([$Status] == 'Closure', 'Accept', 'CircleStopSolid'))))))"
      },
      "style": {
        "border": "none",
        "background-color": "transparent",
        "cursor": "pointer",
        "font-size": "15px"
      },
      "children": [
        {
          "elmType": "span",
          "attributes": {
            "class": "='ms-fontColor-' + if([$Status] == 'New', 'neutralSecondaryAlt', if([$Status] == 'Tender', 'orange', if([$Status] == 'Planning', 'red', if([$Status] == 'In progress', 'yellow', if([$Status] == 'Monitoring', 'green', if([$Status] == 'Closure', 'blue', 'grey'))))))"
          },
          "style": {
            "border": "none",
            "background-color": "transparent",
            "cursor": "pointer",
            "font-size": "14px",
            "padding-left": "15px",
            "font-family": "Segoe UI"
          },
          "txtContent": "@currentField"
        }
      ]
    }
  ]
}
```

If you ask me, this already makes the status column clearer.

## Status cards
To get to the current status, we go a bit further.
Hovering over the current status opens a card with the process flow.


![Formatting](/images/20240807SPColumnFormattingHoverCards/3-Projectcard.png)

The json used to get this view: 

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/sp/v2/column-formatting.schema.json",
  "elmType": "button",
  "customRowAction": {},
  "attributes": {
    "class": "ms-fontColor-themePrimary ms-fontColor-themeDarker--hover"
  },
  "style": {
    "border": "none",
    "background-color": "transparent",
    "cursor": "pointer"
  },
  "children": [
    {
      "elmType": "span",
      "attributes": {
        "iconName": "=if([$Status]=='New', 'Asterisk', if([$Status]=='Tender','AccountActivity', if([$Status]=='Planning','PenWorkspace', if([$Status]=='In progress','WorkFlow', if([$Status]=='Monitoring','Flow', if([$Status]=='Closure','Accept','CircleStopSolid')",
        "class": "='ms-fontColor-' + if([$Status] == 'New', 'neutralSecondaryAlt', if([$Status] == 'Tender', 'orange',if([$Status] == 'Planning', 'red',if([$Status] == 'In progress', 'yellow', if([$Status] == 'Monitoring', 'green',if([$Status] == 'Closure', 'blue','grey')))"
      },
      "style": {
        "padding-right": "6px"
      }
    },
    {
      "elmType": "span",
      "attributes": {
        "class": "='ms-fontColor-' + if([$Status] == 'New', 'neutralSecondaryAlt', if([$Status] == 'Tender', 'orange',if([$Status] == 'Planning', 'red',if([$Status] == 'In progress', 'yellow', if([$Status] == 'Monitoring', 'green',if([$Status] == 'Closure', 'blue','grey')))"
      },
      "txtContent": "@currentField"
    }
  ],
  "customCardProps": {
    "formatter": {
      "elmType": "div",
      "children": [
        {
          "elmType": "div",
          "children": [
            {
              "elmType": "div",
              "style": {
                "padding": "15px 45px 15px 15px"
              },
              "children": [
                {
                  "elmType": "div",
                  "children": [
                    {
                      "elmType": "div",
                      "style": {
                        "font-size": "18px",
                        "text-align": "center",
                        "margin-bottom": "10px"
                      },
                      "txtContent": "Status details"
                    }
                  ]
                },
                {
                  "elmType": "div",
                  "children": [
                    {
                      "elmType": "span",
                      "style": {
                        "font-size": "16px",
                        "padding-left": "15px"
                      },
                      "txtContent": " ",
                      "attributes": {
                        "iconName": "=if([$Status]=='New', 'Asterisk', if([$StatusCode] > 0, 'StatusCircleCheckmark', 'CircleRing')",
                        "class": "='ms-fontColor-' + if([$Status] == 'New', 'grey', if([$StatusCode] > 0, 'green', 'neutralSecondaryAlt'))"
                      }
                    },
                    {
                      "elmType": "span",
                      "style": {
                        "font-size": "16px",
                        "margin-left": "-16px"
                      },
                      "txtContent": " ",
                      "attributes": {
                        "iconName": "=if([$Status]=='New', 'Asterisk', 'CircleRing'",
                        "class": "='ms-fontColor-' + if([$Status] == 'New', 'grey', if([$StatusCode] > 0, 'green', 'neutralSecondaryAlt'))"
                      }
                    },
                    {
                      "elmType": "span",
                      "style": {
                        "font-size": "16px",
                        "padding-left": "9px"
                      },
                      "txtContent": "New",
                      "attributes": {
                        "class": "='ms-fontColor-' + if([$Status] == 'New', 'grey', if([$StatusCode] > 0, 'green', 'neutralSecondaryAlt'))"
                      }
                    }
                  ]
                },
                {
                  "elmType": "div",
                  "children": [
                    {
                      "elmType": "span",
                      "style": {
                        "border-left-style": "solid",
                        "border-left-color": "='ms-borderColor-' + if([$Status] > 0,'green','neutralSecondaryAlt')",
                        "margin-left": "21px"
                      },
                      "attributes": {
                        "class": "='ms-fontColor-' + if([$StatusCode] > 0,'green','neutralSecondaryAlt')"
                      }
                    }
                  ]
                },
                {
                  "elmType": "div",
                  "children": [
                    {
                      "elmType": "span",
                      "style": {
                        "font-size": "16px",
                        "padding-left": "15px"
                      },
                      "txtContent": " ",
                      "attributes": {
                        "iconName": "=if([$Status]=='Tender', 'AccountActivity', if([$StatusCode] > 1, 'StatusCircleCheckmark', 'CircleRing')",
                        "class": "='ms-fontColor-' + if([$Status] == 'Tender', 'orange', if([$StatusCode] > 0, 'green', 'neutralSecondaryAlt'))"
                      }
                    },
                    {
                      "elmType": "span",
                      "style": {
                        "font-size": "16px",
                        "margin-left": "-16px"
                      },
                      "txtContent": " ",
                      "attributes": {
                        "iconName": "=if([$Status]=='Tender', 'AccountActivity', 'CircleRing'",
                        "class": "='ms-fontColor-' + if([$Status] == 'Tender', 'orange', if([$StatusCode] > 0, 'green', 'neutralSecondaryAlt'))"
                      }
                    },
                    {
                      "elmType": "span",
                      "style": {
                        "font-size": "16px",
                        "padding-left": "9px"
                      },
                      "txtContent": "Tender",
                      "attributes": {
                        "class": "='ms-fontColor-' + if([$Status] == 'Tender', 'orange', if([$StatusCode] > 0, 'green', 'neutralSecondaryAlt'))"
                      }
                    }
                  ]
                },
                {
                  "elmType": "div",
                  "children": [
                    {
                      "elmType": "span",
                      "style": {
                        "border-left-style": "solid",
                        "border-left-color": "='ms-borderColor-' + if([$Status] > 1 ,'green','neutralSecondaryAlt')",
                        "margin-left": "21px"
                      },
                      "attributes": {
                        "class": "='ms-fontColor-' + if([$StatusCode] > 1,'green','neutralSecondaryAlt')"
                      }
                    }
                  ]
                },
                {
                  "elmType": "div",
                  "children": [
                    {
                      "elmType": "span",
                      "style": {
                        "font-size": "16px",
                        "padding-left": "15px"
                      },
                      "txtContent": " ",
                      "attributes": {
                        "iconName": "=if([$Status]=='Planning', 'PenWorkspace', if([$StatusCode] > 2, 'StatusCircleCheckmark', 'CircleRing')",
                        "class": "='ms-fontColor-' + if([$Status] == 'Planning', 'red', if([$StatusCode] > 2, 'green', 'neutralSecondaryAlt'))"
                      }
                    },
                    {
                      "elmType": "span",
                      "style": {
                        "font-size": "16px",
                        "margin-left": "-16px"
                      },
                      "txtContent": " ",
                      "attributes": {
                        "iconName": "=if([$Status]=='Planning', 'PenWorkspace', 'CircleRing'",
                        "class": "='ms-fontColor-' + if([$Status] == 'Planning', 'red', if([$StatusCode] > 2, 'green', 'neutralSecondaryAlt'))"
                      }
                    },
                    {
                      "elmType": "span",
                      "style": {
                        "font-size": "16px",
                        "padding-left": "9px"
                      },
                      "txtContent": "Planning",
                      "attributes": {
                        "class": "='ms-fontColor-' + if([$Status] == 'Planning', 'red', if([$StatusCode] > 2, 'green', 'neutralSecondaryAlt'))"
                      }
                    }
                  ]
                },
                {
                  "elmType": "div",
                  "children": [
                    {
                      "elmType": "span",
                      "style": {
                        "border-left-style": "solid",
                        "border-left-color": "='ms-borderColor-' + if([$Status] > 2 ,'green','neutralSecondaryAlt')",
                        "margin-left": "21px"
                      },
                      "attributes": {
                        "class": "='ms-fontColor-' + if([$StatusCode] > 2,'green','neutralSecondaryAlt')"
                      }
                    }
                  ]
                },
                {
                  "elmType": "div",
                  "children": [
                    {
                      "elmType": "span",
                      "style": {
                        "font-size": "16px",
                        "padding-left": "15px"
                      },
                      "txtContent": " ",
                      "attributes": {
                        "iconName": "=if([$Status]=='In progress', 'Workflow', if([$StatusCode] > 3, 'StatusCircleCheckmark', 'CircleRing')",
                        "class": "='ms-fontColor-' + if([$Status] == 'In progress', 'yellow', if([$StatusCode] > 3, 'green', 'neutralSecondaryAlt'))"
                      }
                    },
                    {
                      "elmType": "span",
                      "style": {
                        "font-size": "16px",
                        "margin-left": "-16px"
                      },
                      "txtContent": " ",
                      "attributes": {
                        "iconName": "=if([$Status]=='In progress', 'Workflow', 'CircleRing'",
                        "class": "='ms-fontColor-' + if([$Status] == 'In progress', 'yellow', if([$StatusCode] > 3, 'green', 'neutralSecondaryAlt'))"
                      }
                    },
                    {
                      "elmType": "span",
                      "style": {
                        "font-size": "16px",
                        "padding-left": "9px"
                      },
                      "txtContent": "In progress",
                      "attributes": {
                        "class": "='ms-fontColor-' + if([$Status] == 'In progress', 'yellow', if([$StatusCode] > 3, 'green', 'neutralSecondaryAlt'))"
                      }
                    }
                  ]
                },
				{
                  "elmType": "div",
                  "children": [
                    {
                      "elmType": "span",
                      "style": {
                        "border-left-style": "solid",
                        "border-left-color": "='ms-borderColor-' + if([$Status] > 3 ,'green','neutralSecondaryAlt')",
                        "margin-left": "21px"
                      },
                      "attributes": {
                        "class": "='ms-fontColor-' + if([$StatusCode] > 3,'green','neutralSecondaryAlt')"
                      }
                    }
                  ]
                },
                {
                  "elmType": "div",
                  "children": [
                    {
                      "elmType": "span",
                      "style": {
                        "font-size": "16px",
                        "padding-left": "15px"
                      },
                      "txtContent": " ",
                      "attributes": {
                        "iconName": "=if([$Status]=='Monitoring', 'Flow', if([$StatusCode] > 4, 'StatusCircleCheckmark', 'CircleRing')",
                        "class": "='ms-fontColor-' + if([$Status] == 'Monitoring', 'green', if([$StatusCode] > 4, 'green', 'neutralSecondaryAlt'))"
                      }
                    },
                    {
                      "elmType": "span",
                      "style": {
                        "font-size": "16px",
                        "margin-left": "-16px"
                      },
                      "txtContent": " ",
                      "attributes": {
                        "iconName": "=if([$Status]=='Monitoring', 'Flow', 'CircleRing'",
                        "class": "='ms-fontColor-' + if([$Status] == 'Monitoring', 'green', if([$StatusCode] > 4, 'green', 'neutralSecondaryAlt'))"
                      }
                    },
                    {
                      "elmType": "span",
                      "style": {
                        "font-size": "16px",
                        "padding-left": "9px"
                      },
                      "txtContent": "Monitoring",
                      "attributes": {
                        "class": "='ms-fontColor-' + if([$Status] == 'Monitoring', 'green', if([$StatusCode] > 4, 'green', 'neutralSecondaryAlt'))"
                      }
                    }
                  ]
                },
                {
                  "elmType": "div",
                  "children": [
                    {
                      "elmType": "span",
                      "style": {
                        "border-left-style": "solid",
                        "border-left-color": "='ms-borderColor-' + if([$Status] > 4 ,'green','neutralSecondaryAlt')",
                        "margin-left": "21px"
                      },
                      "attributes": {
                        "class": "='ms-fontColor-' + if([$StatusCode] > 4,'green','neutralSecondaryAlt')"
                      }
                    }
                  ]
                },
                {
                  "elmType": "div",
                  "children": [
                    {
                      "elmType": "span",
                      "style": {
                        "font-size": "16px",
                        "padding-left": "15px"
                      },
                      "txtContent": " ",
                      "attributes": {
                        "iconName": "=if([$Status]=='Closure', 'Accept', if([$StatusCode] > 5, 'StatusCircleCheckmark', 'CircleRing')",
                        "class": "='ms-fontColor-' + if([$Status] == 'Closure', 'blue', if([$StatusCode] > 5, 'green', 'neutralSecondaryAlt'))"
                      }
                    },
                    {
                      "elmType": "span",
                      "style": {
                        "font-size": "16px",
                        "margin-left": "-16px"
                      },
                      "txtContent": " ",
                      "attributes": {
                        "iconName": "=if([$Status]=='Closure', 'Accept', 'CircleRing'",
                        "class": "='ms-fontColor-' + if([$Status] == 'Closure', 'blue', if([$StatusCode] > 5, 'green', 'neutralSecondaryAlt'))"
                      }
                    },
                    {
                      "elmType": "span",
                      "style": {
                        "font-size": "16px",
                        "padding-left": "9px"
                      },
                      "txtContent": "Closure",
                      "attributes": {
                        "class": "='ms-fontColor-' + if([$Status] == 'Closure', 'blue', if([$StatusCode] > 5, 'green', 'neutralSecondaryAlt'))"
                      }
                    }
                  ]
                },
                {
                  "elmType": "div",
                  "children": [
                    {
                      "elmType": "span",
                      "style": {
                        "border-left-style": "solid",
                        "border-left-color": "='ms-borderColor-' + if([$Status] > 5 ,'green','neutralSecondaryAlt')",
                        "margin-left": "21px"
                      },
                      "attributes": {
                        "class": "='ms-fontColor-' + if([$StatusCode] > 5,'green','neutralSecondaryAlt')"
                      }
                    }
                  ]
                },
                {
                  "elmType": "div",
                  "children": [
                    {
                      "elmType": "span",
                      "style": {
                        "font-size": "16px",
                        "padding-left": "15px"
                      },
                      "txtContent": " ",
                      "attributes": {
                        "iconName": "=if([$Status]=='Archived', 'CircleStopSolid', if([$StatusCode] > 6, 'StatusCircleCheckmark', 'CircleRing')",
                        "class": "='ms-fontColor-' + if([$Status] == 'Archived', 'grey', if([$StatusCode] > 6, 'green', 'neutralSecondaryAlt'))"
                      }
                    },
                    {
                      "elmType": "span",
                      "style": {
                        "font-size": "16px",
                        "margin-left": "-16px"
                      },
                      "txtContent": " ",
                      "attributes": {
                        "iconName": "=if([$Status]=='Archived', 'CircleStopSolid', 'CircleRing'",
                        "class": "='ms-fontColor-' + if([$Status] == 'Archived', 'grey', if([$StatusCode] > 6, 'green', 'neutralSecondaryAlt'))"
                      }
                    },
                    {
                      "elmType": "span",
                      "style": {
                        "font-size": "16px",
                        "padding-left": "9px"
                      },
                      "txtContent": "Archived",
                      "attributes": {
                        "class": "='ms-fontColor-' + if([$Status] == 'Archived', 'grey', if([$StatusCode] > 6, 'green', 'neutralSecondaryAlt'))"
                      }
                    }
                  ]
                }
              ]
            }
          ]
        }
      ]
    },
    "openOnEvent": "hover",
    "directionalHint": "bottomCenter",
    "isBeakVisible": true
  }
}
```

A StatusCode column has been added to define the order of the statuses to make it more clear in the JSON formatting.

## Different process steps per project type
Until now, the assumption has been that each project type can have the same statuses. It is easy to imagine that this is by no means true in all cases.
For a project type 'innovation' several statuses are possible compared to a project type 'default':

**Default** 

![Default projects card](/images/20240807SPColumnFormattingHoverCards/4-DefaultProjects.png)


**Innovation**
![Innovation project card](/images/20240807SPColumnFormattingHoverCards/5-InnovationProjects.png)


By setting visibility on the right elements, you can create different cards. 

```json
"style": {
        "visibility": "=if([$Projecttype]=='Innovation', 'visible', 'hidden')",
		"margin-top": "=if([$Projecttype]=='Innovation', '0', '-40px')"
      }
```

<details>
<summary>Full JSON</summary>


```json

{
  "$schema": "https://developer.microsoft.com/json-schemas/sp/v2/column-formatting.schema.json",
  "elmType": "button",
  "customRowAction": {},
  "attributes": {
    "class": "ms-fontColor-themePrimary ms-fontColor-themeDarker--hover"
  },
  "style": {
    "border": "none",
    "background-color": "transparent",
    "cursor": "pointer"
  },
  "children": [
    {
      "elmType": "span",
      "attributes": {
        "iconName": "=if([$Status]=='New', 'Asterisk', if([$Status]=='Tender','AccountActivity', if([$Status]=='Planning','PenWorkspace', if([$Status]=='In progress','WorkFlow', if([$Status]=='Monitoring','Flow', if([$Status]=='Closure','Accept','CircleStopSolid')",
        "class": "='ms-fontColor-' + if([$Status] == 'New', 'neutralSecondaryAlt', if([$Status] == 'Tender', 'orange',if([$Status] == 'Planning', 'red',if([$Status] == 'In progress', 'yellow', if([$Status] == 'Monitoring', 'green',if([$Status] == 'Closure', 'blue','grey')))"
      },
      "style": {
        "padding-right": "6px"
      }
    },
    {
      "elmType": "span",
      "attributes": {
        "class": "='ms-fontColor-' + if([$Status] == 'New', 'neutralSecondaryAlt', if([$Status] == 'Tender', 'orange',if([$Status] == 'Planning', 'red',if([$Status] == 'In progress', 'yellow', if([$Status] == 'Monitoring', 'green',if([$Status] == 'Closure', 'blue','grey')))"
      },
      "txtContent": "@currentField"
    }
  ],
  "customCardProps": {
    "formatter": {
      "elmType": "div",
      "children": [
        {
          "elmType": "div",
          "children": [
            {
              "elmType": "div",
              "style": {
                "padding": "15px 45px 15px 15px"
              },
              "children": [
                {
                  "elmType": "div",
                  "children": [
                    {
                      "elmType": "div",
                      "style": {
                        "font-size": "18px",
                        "text-align": "center",
                        "margin-bottom": "10px"
                      },
                      "txtContent": "Status details"
                    }
                  ]
                },
                {
                  "elmType": "div",
                  "children": [
                    {
                      "elmType": "span",
                      "style": {
                        "font-size": "16px",
                        "padding-left": "15px"
                      },
                      "txtContent": " ",
                      "attributes": {
                        "iconName": "=if([$Status]=='New', 'Asterisk', if([$StatusCode] > 0, 'StatusCircleCheckmark', 'CircleRing')",
                        "class": "='ms-fontColor-' + if([$Status] == 'New', 'grey', if([$StatusCode] > 0, 'green', 'neutralSecondaryAlt'))"
                      }
                    },
                    {
                      "elmType": "span",
                      "style": {
                        "font-size": "16px",
                        "margin-left": "-16px"
                      },
                      "txtContent": " ",
                      "attributes": {
                        "iconName": "=if([$Status]=='New', 'Asterisk', 'CircleRing'",
                        "class": "='ms-fontColor-' + if([$Status] == 'New', 'grey', if([$StatusCode] > 0, 'green', 'neutralSecondaryAlt'))"
                      }
                    },
                    {
                      "elmType": "span",
                      "style": {
                        "font-size": "16px",
                        "padding-left": "9px"
                      },
                      "txtContent": "New",
                      "attributes": {
                        "class": "='ms-fontColor-' + if([$Status] == 'New', 'grey', if([$StatusCode] > 0, 'green', 'neutralSecondaryAlt'))"
                      }
                    }
                  ]
                },
                {
                  "elmType": "div",
                  "children": [
                    {
                      "elmType": "span",
                      "style": {
                        "border-left-style": "solid",
                        "border-left-color": "='ms-borderColor-' + if([$Status] > 0,'green','neutralSecondaryAlt')",
                        "margin-left": "21px"
                      },
                      "attributes": {
                        "class": "='ms-fontColor-' + if([$StatusCode] > 0,'green','neutralSecondaryAlt')"
                      }
                    }
                  ]
                },
                {
                  "elmType": "div",
                  "style": {
                    "visibility": "=if([$Projecttype]=='Innovation', 'visible', 'hidden')",
                    "margin-top": "=if([$Projecttype]=='Innovation', '0', '-40px')"
                  },
                  "children": [
                    {
                      "elmType": "span",
                      "style": {
                        "font-size": "16px",
                        "padding-left": "15px"
                      },
                      "txtContent": " ",
                      "attributes": {
                        "iconName": "=if([$Status]=='Tender', 'AccountActivity', if([$StatusCode] > 1, 'StatusCircleCheckmark', 'CircleRing')",
                        "class": "='ms-fontColor-' + if([$Status] == 'Tender', 'orange', if([$StatusCode] > 0, 'green', 'neutralSecondaryAlt'))"
                      }
                    },
                    {
                      "elmType": "span",
                      "style": {
                        "font-size": "16px",
                        "margin-left": "-16px"
                      },
                      "txtContent": " ",
                      "attributes": {
                        "iconName": "=if([$Status]=='Tender', 'AccountActivity', 'CircleRing'",
                        "class": "='ms-fontColor-' + if([$Status] == 'Tender', 'orange', if([$StatusCode] > 0, 'green', 'neutralSecondaryAlt'))"
                      }
                    },
                    {
                      "elmType": "span",
                      "style": {
                        "font-size": "16px",
                        "padding-left": "9px"
                      },
                      "txtContent": "Tender",
                      "attributes": {
                        "class": "='ms-fontColor-' + if([$Status] == 'Tender', 'orange', if([$StatusCode] > 0, 'green', 'neutralSecondaryAlt'))"
                      }
                    }
                  ]
                },
                {
                  "elmType": "div",
                  "children": [
                    {
                      "elmType": "span",
                      "style": {
                        "border-left-style": "solid",
                        "border-left-color": "='ms-borderColor-' + if([$Status] > 1 ,'green','neutralSecondaryAlt')",
                        "margin-left": "21px"
                      },
                      "attributes": {
                        "class": "='ms-fontColor-' + if([$StatusCode] > 1,'green','neutralSecondaryAlt')"
                      }
                    }
                  ]
                },
                {
                  "elmType": "div",
                  "children": [
                    {
                      "elmType": "span",
                      "style": {
                        "font-size": "16px",
                        "padding-left": "15px"
                      },
                      "txtContent": " ",
                      "attributes": {
                        "iconName": "=if([$Status]=='Planning', 'PenWorkspace', if([$StatusCode] > 2, 'StatusCircleCheckmark', 'CircleRing')",
                        "class": "='ms-fontColor-' + if([$Status] == 'Planning', 'red', if([$StatusCode] > 2, 'green', 'neutralSecondaryAlt'))"
                      }
                    },
                    {
                      "elmType": "span",
                      "style": {
                        "font-size": "16px",
                        "margin-left": "-16px"
                      },
                      "txtContent": " ",
                      "attributes": {
                        "iconName": "=if([$Status]=='Planning', 'PenWorkspace', 'CircleRing'",
                        "class": "='ms-fontColor-' + if([$Status] == 'Planning', 'red', if([$StatusCode] > 2, 'green', 'neutralSecondaryAlt'))"
                      }
                    },
                    {
                      "elmType": "span",
                      "style": {
                        "font-size": "16px",
                        "padding-left": "9px"
                      },
                      "txtContent": "Planning",
                      "attributes": {
                        "class": "='ms-fontColor-' + if([$Status] == 'Planning', 'red', if([$StatusCode] > 2, 'green', 'neutralSecondaryAlt'))"
                      }
                    }
                  ]
                },
                {
                  "elmType": "div",
                  "children": [
                    {
                      "elmType": "span",
                      "style": {
                        "border-left-style": "solid",
                        "border-left-color": "='ms-borderColor-' + if([$Status] > 2 ,'green','neutralSecondaryAlt')",
                        "margin-left": "21px"
                      },
                      "attributes": {
                        "class": "='ms-fontColor-' + if([$StatusCode] > 2,'green','neutralSecondaryAlt')"
                      }
                    }
                  ]
                },
                {
                  "elmType": "div",
                  "children": [
                    {
                      "elmType": "span",
                      "style": {
                        "font-size": "16px",
                        "padding-left": "15px"
                      },
                      "txtContent": " ",
                      "attributes": {
                        "iconName": "=if([$Status]=='In progress', 'Workflow', if([$StatusCode] > 3, 'StatusCircleCheckmark', 'CircleRing')",
                        "class": "='ms-fontColor-' + if([$Status] == 'In progress', 'yellow', if([$StatusCode] > 3, 'green', 'neutralSecondaryAlt'))"
                      }
                    },
                    {
                      "elmType": "span",
                      "style": {
                        "font-size": "16px",
                        "margin-left": "-16px"
                      },
                      "txtContent": " ",
                      "attributes": {
                        "iconName": "=if([$Status]=='In progress', 'Workflow', 'CircleRing'",
                        "class": "='ms-fontColor-' + if([$Status] == 'In progress', 'yellow', if([$StatusCode] > 3, 'green', 'neutralSecondaryAlt'))"
                      }
                    },
                    {
                      "elmType": "span",
                      "style": {
                        "font-size": "16px",
                        "padding-left": "9px"
                      },
                      "txtContent": "In progress",
                      "attributes": {
                        "class": "='ms-fontColor-' + if([$Status] == 'In progress', 'yellow', if([$StatusCode] > 3, 'green', 'neutralSecondaryAlt'))"
                      }
                    }
                  ]
                },
                {
                  "elmType": "div",
                  "children": [
                    {
                      "elmType": "span",
                      "style": {
                        "border-left-style": "solid",
                        "border-left-color": "='ms-borderColor-' + if([$Status] > 3 ,'green','neutralSecondaryAlt')",
                        "margin-left": "21px"
                      },
                      "attributes": {
                        "class": "='ms-fontColor-' + if([$StatusCode] > 3,'green','neutralSecondaryAlt')"
                      }
                    }
                  ]
                },
                {
                  "elmType": "div",
                  "style": {
                    "visibility": "=if([$Projecttype]=='Innovation', 'visible', 'hidden')",
                    "margin-top": "=if([$Projecttype]=='Innovation', '0', '-40px')"
                  },
                  "children": [
                    {
                      "elmType": "span",
                      "style": {
                        "font-size": "16px",
                        "padding-left": "15px"
                      },
                      "txtContent": " ",
                      "attributes": {
                        "iconName": "=if([$Status]=='Monitoring', 'Flow', if([$StatusCode] > 4, 'StatusCircleCheckmark', 'CircleRing')",
                        "class": "='ms-fontColor-' + if([$Status] == 'Monitoring', 'green', if([$StatusCode] > 4, 'green', 'neutralSecondaryAlt'))"
                      }
                    },
                    {
                      "elmType": "span",
                      "style": {
                        "font-size": "16px",
                        "margin-left": "-16px"
                      },
                      "txtContent": " ",
                      "attributes": {
                        "iconName": "=if([$Status]=='Monitoring', 'Flow', 'CircleRing'",
                        "class": "='ms-fontColor-' + if([$Status] == 'Monitoring', 'green', if([$StatusCode] > 4, 'green', 'neutralSecondaryAlt'))"
                      }
                    },
                    {
                      "elmType": "span",
                      "style": {
                        "font-size": "16px",
                        "padding-left": "9px"
                      },
                      "txtContent": "Monitoring",
                      "attributes": {
                        "class": "='ms-fontColor-' + if([$Status] == 'Monitoring', 'green', if([$StatusCode] > 4, 'green', 'neutralSecondaryAlt'))"
                      }
                    }
                  ]
                },
                {
                  "elmType": "div",
                  "children": [
                    {
                      "elmType": "span",
                      "style": {
                        "border-left-style": "solid",
                        "border-left-color": "='ms-borderColor-' + if([$Status] > 4 ,'green','neutralSecondaryAlt')",
                        "margin-left": "21px"
                      },
                      "attributes": {
                        "class": "='ms-fontColor-' + if([$StatusCode] > 4,'green','neutralSecondaryAlt')"
                      }
                    }
                  ]
                },
                {
                  "elmType": "div",
                  "children": [
                    {
                      "elmType": "span",
                      "style": {
                        "font-size": "16px",
                        "padding-left": "15px"
                      },
                      "txtContent": " ",
                      "attributes": {
                        "iconName": "=if([$Status]=='Closure', 'Accept', if([$StatusCode] > 5, 'StatusCircleCheckmark', 'CircleRing')",
                        "class": "='ms-fontColor-' + if([$Status] == 'Closure', 'blue', if([$StatusCode] > 5, 'green', 'neutralSecondaryAlt'))"
                      }
                    },
                    {
                      "elmType": "span",
                      "style": {
                        "font-size": "16px",
                        "margin-left": "-16px"
                      },
                      "txtContent": " ",
                      "attributes": {
                        "iconName": "=if([$Status]=='Closure', 'Accept', 'CircleRing'",
                        "class": "='ms-fontColor-' + if([$Status] == 'Closure', 'blue', if([$StatusCode] > 5, 'green', 'neutralSecondaryAlt'))"
                      }
                    },
                    {
                      "elmType": "span",
                      "style": {
                        "font-size": "16px",
                        "padding-left": "9px"
                      },
                      "txtContent": "Closure",
                      "attributes": {
                        "class": "='ms-fontColor-' + if([$Status] == 'Closure', 'blue', if([$StatusCode] > 5, 'green', 'neutralSecondaryAlt'))"
                      }
                    }
                  ]
                },
                {
                  "elmType": "div",
                  "children": [
                    {
                      "elmType": "span",
                      "style": {
                        "border-left-style": "solid",
                        "border-left-color": "='ms-borderColor-' + if([$Status] > 5 ,'green','neutralSecondaryAlt')",
                        "margin-left": "21px"
                      },
                      "attributes": {
                        "class": "='ms-fontColor-' + if([$StatusCode] > 5,'green','neutralSecondaryAlt')"
                      }
                    }
                  ]
                },
                {
                  "elmType": "div",
                  "children": [
                    {
                      "elmType": "span",
                      "style": {
                        "font-size": "16px",
                        "padding-left": "15px"
                      },
                      "txtContent": " ",
                      "attributes": {
                        "iconName": "=if([$Status]=='Archived', 'CircleStopSolid', if([$StatusCode] > 6, 'StatusCircleCheckmark', 'CircleRing')",
                        "class": "='ms-fontColor-' + if([$Status] == 'Archived', 'grey', if([$StatusCode] > 6, 'green', 'neutralSecondaryAlt'))"
                      }
                    },
                    {
                      "elmType": "span",
                      "style": {
                        "font-size": "16px",
                        "margin-left": "-16px"
                      },
                      "txtContent": " ",
                      "attributes": {
                        "iconName": "=if([$Status]=='Archived', 'CircleStopSolid', 'CircleRing'",
                        "class": "='ms-fontColor-' + if([$Status] == 'Archived', 'grey', if([$StatusCode] > 6, 'green', 'neutralSecondaryAlt'))"
                      }
                    },
                    {
                      "elmType": "span",
                      "style": {
                        "font-size": "16px",
                        "padding-left": "9px"
                      },
                      "txtContent": "Archived",
                      "attributes": {
                        "class": "='ms-fontColor-' + if([$Status] == 'Archived', 'grey', if([$StatusCode] > 6, 'green', 'neutralSecondaryAlt'))"
                      }
                    }
                  ]
                }
              ]
            }
          ]
        }
      ]
    },
    "openOnEvent": "hover",
    "directionalHint": "bottomCenter",
    "isBeakVisible": true
  }
}
```
</details>


## End result
The end result 
![End result](/images/20240807SPColumnFormattingHoverCards/6-endresult.gif)

## Helpfull tooling
With knowledge of HTML, CSS and your own creativity, you can make column formatting completely your own. To make your life easier two more tools to help with this:
* **The HTML formatter**:
https://pnp.github.io/List-Formatting/tools/html-formatter-generator/ 

This allows you to have the JSON generated by setting up HTML and CSS. You still have to add further intelligence of formulas yourself, but creating a layout setup becomes much easier!
* **SP formatter**: [Google Chrome extension](https://chrome.google.com/webstore/detail/sp-formatter/fmeihfaddhdkoogipahfcjlicglflkhg/related)

When working with column formatting you often click on Preview to see the result. This extension allows you to get a live preview of the formatting, so you can get your final result faster. In addition, you can activate intellisense, you get to see JSON validation with error messages and you can use various keyboard shortcuts. For detailed description of these read the [following blog](https://spblog.net/post/2019/06/11/introducing-sp-formatter-google-chrome-extension-which-enhances-your-column-view-formatting-editing-experience).