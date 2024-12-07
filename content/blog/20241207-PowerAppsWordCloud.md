---
author: ""
title: "Power Apps: word cloud"
date: 2024-12-07
description: Create your own word cloud in Power Apps
tags:
  - Power Apps
  - Word cloud
  - HTML
thumbnail: /images/20241207PowerAppsWordCloud/00WordCloud.png
preview: /00WordCloud.png
images: 
- /00WordCloud.png
---


Out-of-the-box there is no word cloud possibility in Power Apps. This blog describes how to create your own flexible word cloud without importing third parties tools or use of external code. It’s easier than you might think!

## ☁️What Is a Word Cloud?
A word cloud is a visual representation of text data, where the size of each word indicates its frequency or importance. These types of visualizations are perfect for displaying topics, themes, or even feedback in a way that’s easy to digest. In simple terms: it’s a cloud made of words, and some of those words are bigger because they matter more.

## End result
The end results consists of a dynamic and flexible word cloud on which words are randomly positioned on the screen, rotated and styled with different colors. The best part? You can do all of this with just a little Power Fx (and HTML).

![End result](/images/20241207PowerAppsWordCloud/wordcloud.gif)

## Building the Word Cloud

Let's break down how we can create a word cloud that positions words randomly on the screen, adjusts their colors, and even rotates them for added effect—all using Power Fx in Power Apps.

### Step 1: Prepare the Data
First, you need a collection of words to populate the word cloud. Let’s assume we have a collection called colWordCloudData, which contains a set of words.

<details>
<summary> Example data</summary>
Hereby example data used in this scenario:

```json
Clear(colWordCloudData);
Collect(
    colWordCloudData,    
{Word: "LowCode"},
{Word: "NoCode"},
{Word: "Automation"},
{Word: "Workflow"},
{Word: "Integration"},
{Word: "App"},
{Word: "Platform"},
{Word: "Development"},
{Word: "Cloud"},
{Word: "Data"},
{Word: "API"},
{Word: "Dynamics"},
{Word: "Customizable"},
{Word: "BusinessLogic"},
{Word: "Azure"},
{Word: "PowerApps"},
{Word: "RapidPrototyping"},
{Word: "AI"},
{Word: "MachineLearning"},
{Word: "Deployment"},
{Word: "Security"},
{Word: "DragAndDrop"},
{Word: "UserInterface"},
{Word: "Agile"},
{Word: "Collaborative"},
{Word: "Database"},
{Word: "Widgets"},
{Word: "UX/UI"},
{Word: "SaaS"},
{Word: "CRM"},
{Word: "AutomationTools"},
{Word: "NoCodePlatform"},
{Word: "BusinessSolutions"},
{Word: "IntegrationTools"},
{Word: "CustomApps"},
{Word: "ProcessAutomation"},
{Word: "RapidDevelopment"},
{Word: "TechStack"},
{Word: "EndUserCustomization"},
{Word: "Scalable"}
);
```

</details>

For this demonstration, we'll shuffle the list of words and pick the first 15. The FirstN() function allows us to select a subset, and Shuffle() ensures that the words appear in a random order.

```json
Set(varWords,
    ForAll(
        FirstN(Shuffle(colWordCloudData), 15) As record,
        "<div style='
            text-align:center;
            position: absolute;
           left: "& If(RandBetween(0, (htmlWordCloud.Width- Len(record.Word) * 14)) < 0, 0,RandBetween(0, (htmlWordCloud.Width- Len(record.Word) * 14)))  & "px;
            top: "& If(RandBetween(0, (htmlWordCloud.Height - Len(record.Word) * 14)) <0, 0, RandBetween(0, (htmlWordCloud.Height - Len(record.Word) * 14)))  & "px;
            width: "& Len(record.Word) * 12 & "px;
            height: "& Len(record.Word) * 12 & "px;            
            color: #" & If(RandBetween(0, 1) = 0, Char(RandBetween(65, 70)), Text(RandBetween(0, 9))) &
                        If(RandBetween(0, 1) = 0, Char(RandBetween(65, 70)), Text(RandBetween(0, 9))) &
                        If(RandBetween(0, 1) = 0, Char(RandBetween(65, 70)), Text(RandBetween(0, 9))) &
                        If(RandBetween(0, 1) = 0, Char(RandBetween(65, 70)), Text(RandBetween(0, 9))) &
                        If(RandBetween(0, 1) = 0, Char(RandBetween(65, 70)), Text(RandBetween(0, 9))) &
                        If(RandBetween(0, 1) = 0, Char(RandBetween(65, 70)), Text(RandBetween(0, 9))) & ";
            transform: rotate(" & Round(RandBetween(-90, 90), 0) & "deg);
            font-size: "& RandBetween(12, 28) & "px;
            font-family: "& Switch(
                        RandBetween(1, 6), 
                        1, "Arial", 
                        2, "Courier New", 
                        3, "Comic Sans MS", 
                        4, "Times New Roman", 
                        5, "Dancing Script",
                        6, "Tahoma"
                    ) & ";
        '>" &
        record.Word & "</div>"
    )
);

Set(varWordCloud, Concat(varWords, Value));;
```

### Step 2: The formula breakdown

Here’s what each part of the formula does:

* **Shuffling words**: use the Shuffle() function to randomly shuffle the collection of words, ensuring that the words are displayed in a random order.
* **Selecting 15 Words**: FirstN() is used to select the first 15 words from the shuffled list. You can adjust this number depending on how many words you want in your cloud.
* **Positioning** the words:
        The left and top properties are calculated randomly using the RandBetween() function. This ensures that the words are placed at random locations on the canvas, but aren't outside of the canvas.
        We calculate the size of each word dynamically using Len(record.Word) * 12, which means the longer the word, the more space it occupies.
* **Random Color**: Each word is given a random color.  using a combination of RandBetween() to generate random RGB values. This adds an additional layer of fun to the word cloud, making each display unique. RandBetween(0, 1) is used to generate either a 0 or 1. If it’s 0, we generate a random letter from A to F (Char(RandBetween(65, 70))), because only letters A to F are used in hex codes. If it’s 1, we generate a random digit (RandBetween(0, 9)). 
This logic is repeated six times because we want the hex code to consist of 6 characters.
The result will always be a 6-character string in the format #A1F0C9, where each position can either be a letter A-F or a digit 0-9.

* **Rotation**: We use the transform: rotate() CSS property to randomly rotate each word between -90 and 90 degrees. This gives the word cloud a more dynamic, less predictable appearance.

* **Set variable**: Once all the words are randomly placed, sized, colored, and rotated, we need to combine the HTML code into one big string so that it can be displayed in an HTML text control. `Set(varWordCloud, Concat(varWords, Value));`


### Step 3: Display the word cloud
In the HTML text element (in this example the name of the element is htmlWordCloud) you need to place the variable varWordCloud.
![HTML](/images/20241207PowerAppsWordCloud/html.png)

Your dynamic word cloud is ready to be viewed!

![Word Cloud](/images/20241207PowerAppsWordCloud/wordcloud2.png)

