---
author: ""
title: "Color = context. Work smarter, avoid mistakes"
date: 2025-10-03
description: Use environment variables to switch colors
tags:
  - Power Automate
  - Canvas  
  - Environments
thumbnail: /images/20251003EnvironmentSwitchColor/00environmentcolors.png
preview: /00environmentcolors.png
images: 
- /00environmentcolors.png
---



Ever clicked in your app and wondered: *Am I in DEV or PRD now?*  
Mistakes happen. Mis-clicks happen. And worst case: you update data in the wrong environment.  

In this blog: a simple pattern to make your app *visually aware* — based on environment.


## 🎯 The idea in short

- Create an **environment variable** (e.g. `CurrentEnvironment`) with possible values `DEV`, `ACC`, `PRD`  
- In your app, use logic to pick a **color** based on that value  
- Result: the UI itself signals *which environment you’re in*

> Color = Context. Work smarter, avoid mistakes.


## 1. Create the variable

In your solution:

- Add a new **Environment Variable**  

![New Environment](/images/20251003EnvironmentSwitchColor/newenvironment.png)

- Name it `CurrentEnvironment`  
- Give it value (DEV, ACC, PRD)


![Environment Variable](/images/20251003EnvironmentSwitchColor/environmentvariable.png)


## 2. Assign colors per environment

In Power Apps you add a variable which is set while loading the app to switch based on current environment:

```
Set(varEnvironmentColor, 
    Switch(LookUp('Environment Variable Values', 'Environment Variable Definition'.'Schema Name' = "emb_CurrentEnvironment").Value, 
        "DEV", Color.Yellow,
        "ACC", Color.Red,
        "PRD", Color.White       
    )); 
```

![PowerFx](/images/20251003EnvironmentSwitchColor/powerfx.png)


Bind that to background, header bar, or banner — anywhere you want the color cue.


### Differentation

| DEV | ACC | PRD |
|-----|-----|-----|
| ![dev](/images/20251003EnvironmentSwitchColor/dev.png) | ![acc](/images/20251003EnvironmentSwitchColor/acc.png) | ![prd](/images/20251003EnvironmentSwitchColor/prd.png) |




## 👍Why this helps
* At a glance you see which environment you’re working in
* Prevents fatal mistakes (like editing PRD while you thought you were in DEV)
* Consistent across your team: everyone sees the same cues
* Flexible: add more environments later 

## 💡Tips & variations
* Use lighter shades (pastels) so the color cue is subtle, not distracting
* Combine with icons or labels like “DEV mode” or “ACC mode”
* Always set a fallback color in case something goes wrong

## 🧩 Implementation checklist
* Create environment variable CurrentEnvironment
* Define values: DEV, ACC, PRD
* Pick your colors
* Write the switch logic in the app
* Apply it to a prominent UI area
* Test: change the variable and see the effect immediately



With one simple variable and a splash of color, you turn your Power App into a smarter and more user-friendly tool; no more second-guessing where you are.