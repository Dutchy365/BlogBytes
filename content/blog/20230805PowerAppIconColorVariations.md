---
author: ""
title: "Power Apps Canvas: one icon with eleven color variations"
date: 2023-08-05
description: Flexible set of color variations for one icon
tags:
  - Power Automate
  - Approval
  - markdown
thumbnail: /images/20230805PowerAppIconColorVariations/00IconColorVariations.png
preview: /00IconColorVariations.png
---

## Situation
In the Netherlands, the energy label of houses is indicated by a letter and a corresponding color. Today, we have 11 different labels, ranging from A++++ to G (https://woonbewust.nl/energielabel-woningen).

This label is usually indicated by a pentagonal arrow, containing the letter and corresponding color. An example:


![Example](/images/20230805PowerAppIconColorVariations/1-Example.png)

Source: https://www.homekeur.nl/energielabel-woning-uitleg/ 

## Scenario
In a Canvas Power App, the letter could be selected in the dropdown and icon and its corresponding label should be displayed based on the selected value.
The end result:

![Example](/images/20230805PowerAppIconColorVariations/2-EndResult.gif)

## Step by step
By default, there is no icon available in Power Apps that contains the appearance of this pentagon arrow, this means that a SVG will be used as an image. Because there is currently a variation of 11 different letters and this has evolved greatly in recent years, it is needed to set this as flexible as possible. An normal if statement is not an option because of the quantity. 

To start with, a table is created in the OnStart app in which the colors of the energy labels are defined:


![Onstart formula collection](/images/20230805PowerAppIconColorVariations/3-Onstart.png)

A SVG has been created with the desired layout for an energy label; it is placed in the image.

![SVG](/images/20230805PowerAppIconColorVariations/4-SVG.png)

In the formula of the SVG, a variable is used for the color. This variable is determined by a With function, which uses the text from the label to extract the color from the EnergieLabelColor table.

```
With(
    {
        ColorEnergieLabel: LookUp(EnergielabelColor, Letter = LabelEnergieLabel.Text, Color)
    },
    "data:image/svg+xml;utf8, " & EncodeUrl(
        "
<svg width='15' height='10' xmlns='http://www.w3.org/2000/svg' fill='none'>
  <path fill-rule='evenodd' clip-rule='evenodd' d='m0,0l10.6846,0l3.89302,5l-3.99925,5.05119l-10.57837,-0.00771l0,-10.04348z' fill='" & ColorEnergieLabel & " ' id='svg_1'/>
</svg>"
    )
)
```

This way, we have a future-ready setup: new labels and colors can easily be added and minimal assets ensure good performance.


## Tips and tricks
* To use a SVG you can use the icons available through bootstrap: https://icons.getbootstrap.com/
* The SVG used in this example is not available by default, via the website: https://editor.method.ac it is possible to open a SVG and edit it.
