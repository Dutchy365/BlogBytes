---
author: ""
title: "The importance of testing in low-code development"
date: 2025-12-08
description: the test continuum as mindset reminder
tags:
- testing
- playwright
- test studio
- test engine
thumbnail: /images/20251208automatedtesting/00automatedtesting.png
preview: /00automatedtesting.png
images: 
- /00automatedtesting.png
---


## Testing in low-code
To start with the most important message: it's not a final phase, it's a mindset.

Low-code moves fast. *Really* fast.  
The business wants features, users want improvements, and the market wants updates yesterday.

But here’s the punchline:  
**Testing doesn’t slow you down, it prevents you from crashing later.**

## Speed vs. quality

Low-code teams often feel the pressure to ship quickly. New apps, new capabilities, new ideas.  
But speed without quality?

So let’s anchor this:

> **We don’t test to slow down.  
> We test so we can speed up, without causing damage.**

Robust testing keeps your velocity high, your apps stable, and your users happy.  
And it all starts with one thing: **mindset**.



## Different types of testing


**1. Usability Testing**  
Is your app intuitive? Or are users rage-clicking?

**2. Regression Testing**  
Every new feature risks breaking old logic. This catches the fallout.

**3. User Acceptance Testing (UAT)**  
The final confirmation: does the app actually do what users need?

**4. Unit Testing**  
Small, focused checks on individual components.

**5. Performance Testing**  
Does the app stay fast when real users hit it? What about peak load?

**6. Security Testing**  
If your data isn’t safe, nothing else matters.

Together, these create a safety harness for building fast *and* building well.



**🧭 Governance = Freedom within boundaries**

No governance = chaos.  
Too much governance = bottlenecks.

Real governance gives you **freedom with guardrails**:  
clarity, safety, and predictable delivery.

Inside those boundaries, teams move faster, not slower.


## The test continuum
Testing isn’t a checkbox at the end and not a linear phase, but a loop.
It’s embedded everywhere:

![testing continuum](/images/20251208automatedtesting/testcontinuum.png)
  
A continuous cycle that evolves with every commit, fix, and feature.  
Testing becomes not a task, but a **mindset**.



### Developing
Testing during development: earlier is cheaper

**🩺 App Checker**  
Canvas apps include built-in diagnostics to catch performance issues early.  
Real-time feedback, right where you build.

**🔬 Test Studio**  
For makers integrating testing into the creation process

Test Studio gives low-code developers a native, frictionless test workflow:

- Record or write tests in **Power Fx**  
- Automate execution via **Test Engine**  
- Fully integrated in Power Apps Studio  
- Ideal for Canvas Apps and fast iteration cycles



### Testing

**Test Engine**  
For pro-makers and ALM-driven teams who want stronger governance and automation:

- Robust automated tests  
- Native integration with ALM pipelines  
- Great balance between power and simplicity  

It’s the dependable engine that runs your quality checks in the background.


**Playwright: for enterprise-wide, cross-platform test automation**

When you need industrial-strength testing:

- Write tests in JavaScript/TypeScript
- Ideal for both Canvas and Model-Driven Apps  
- Deep integration with DevOps and CI/CD tooling  
- Full flexibility at enterprise scale  

The learning curve is steeper, but the capabilities are unmatched.

### Deployment
Playwright fits in CI/CD approach, it can be embedded in:
- GitHub Actions
- Azure DevOps Pipelines
- Docker
- Google Cloud Built


### Monitoring

Your app goes live. Great.  
But now the *actual* learning begins.

Monitoring is possible both for Canvas ánd Model Driven Apps.

Monitoring provides:

- Live session insights  
- Automatic logging of actions and errors  
- Enhanced diagnostics with `Trace()`  
- Multi-user data capture via shared sessions  

Monitoring is both your rear-view mirror and your early-warning system.

Trace function example in the app:
![trace](/images/20251208automatedtesting/trace.png)

How this helps you in a monitor session to get more detailled information: 
![trace monitor](/images/20251208automatedtesting/tracemonitor.png)
 

Monitoring performance is often a bit subjective, this can be made more objective using the Apdex score. Which can be read in a [previous blog](/blog/20250211-PowerAutomateApdexScore/).

## Decision Matrix
Choosing the right testing tool

| Scenario                     | Test Studio | Test Engine | Playwright |
|------------------------------|-------------|-------------|-----------|
| **Canvas fit**              | ✅ Excellent | ⚙️ Moderate | ✅ Excellent |
| **MDA fit**                 | ❌ Not possible | ⚙️ Moderate | ✅ Ideal |
| **Learning curve**          | 🟢 Low | 🟠 Medium | 🔴 High |
| **Automation depth**        | ⚙️ Moderate | ✅ Strong | ✅ Strong |
| **Integration in ALM**      | ⚠️ Limited | ✅ Native | ✅ Strong |
| **Governance alignment**    | 🟢 Good | 🟢 Excellent | ⚙️ Good |
| **Ideal for**               | Citizen devs & early Canvas testing | Pro-makers embedding testing in ALM | DevOps/Fusion teams at enterprise scale |




## 🎯 Final message: Testing isn’t a final phase, it’s a mindset

If you test only at the end, you're already late.  
If you see testing as bureaucracy, you slow yourself down.  
But when you embed testing into every step?

You unlock:

- Faster delivery  
- Safer releases  
- Stronger governance  
- Happier users  
- Scalable low-code ecosystems  

