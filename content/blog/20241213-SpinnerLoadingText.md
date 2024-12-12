---
author: ""
title: "Spinner loading text"
date: 2024-12-12
description: "Creative loading: adding random text to the spinner"
tags:
  - Power Apps
  - Spinner
  - HTML
thumbnail: /images/20241212SpinnerLoadingText/00SpinnerText.png
preview: /00SpinnerText.png
images: 
- /00SpinnerText.png
---


## Scenario
As a user you want to work an app as fast as possible. While developing an app you're always working on performance. Next to the actual performance you can improve the user experience.
One way to improve the experience is by adding dynamic text during loading screens. This blog will guide you through the process of adding random text to a loading spinner.

## End results 
The end result is a spinner of which the text of the label randomly changes. 

![End result](/images/20241212SpinnerLoadingText/endresult.gif)



## Steps

### Add elements to the screen
You'll need the spinner, two timers and a button on the screen to make this end result possible. 

![Elements](/images/20241212SpinnerLoadingText/screenelements.png)



### Settings of the elements
The settings for the spinner, named spnLoadingData:

|Property| Value |
|---|---|
|Label |ProgressMessage|
|Visible|varShowSpinner| 


#### Timer 1 - tmrShowSpinner
The first timer in this scenario is to set the start and end of the display of the spinner. 

The timer to start the display of the spinner, named tmrShowSpinner: 
|Property| Value |
|---|---|
|OnTimerStart |UpdateContext({varShowSpinner: true});|
|OnTimerEnd| UpdateContext({varShowSpinner: false});|
|Duration| 10000|
|Start|varShowSpinner|

#### Timer 2 - tmrProgressMessage
The timer which will switch the content of the message, named tmrProgressMessage:
| Property      | Value|
|---------------|--------------------------------------------------------------------------------------------------|
| OnTimerEnd    | ```UpdateContext({ProgressMessage: Switch(RandBetween(1, 6), 1, "⌛Loading data, please wait...", 2, "Processing your request...", 3, "⌛Almost there...", 4, "Fetching results...", 5, "Finalizing...", 6, "☕Drinking coffee...")})```|
| Duration      | 2000|
| Repeat        | varShowSpinner|

#### Button
A button to trigger the start of the timers, named btnStart: 
|Property| Value |
|---|---|
|OnSelect |UpdateContext({varShowSpinner: true});|


## Conclusion
Adding dynamic text to your app’s loading spinner is a simple yet effective way to enhance the user experience. By providing users with engaging and varied messages during load times, you can make waiting feel less and more interactive. 

Just add some extra's to your app by adding a personal touch with creative text ideas. If you have suggestions, feel free to share them in the comments!