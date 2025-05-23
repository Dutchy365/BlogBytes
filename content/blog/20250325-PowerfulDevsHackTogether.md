---
author: ""
title: "Price winning solution: AI-Driven archiving of SharePoint Sites"
date: 2025-03-25
description: "One of the winners of the Powerful Dev Hack Together 2025 from Microsoft"
tags:
  - Power Automate
  - SharePoint agents
thumbnail: /images/20250324PowerfulDevHackathon/00PowerfulDevsHack.png
preview: /00PowerfulDevsHack.png
images: 
- /00PowerfulDevsHack.png
---


A very special blog this time! Together with my teammembers from Blis Digital we participated in the Powerful Devs Hack 2025. This hackathon  was organized by Microsoft and could shortly described by:

"It's time to start developing secure solutions at enterprise scale using the power of AI and the Power Platform! 🤖 + 📚 = 🔥"

There were different categories to participate in and all projects were evaluated by a panel of judges against technologies and languages, using the following aspects:

* 20% Innovation
* 20% Real-World Impact
* 20% Technical Usability and Solution Quality – security, scalability, and design
* 40% Alignment with chosen hackathon category


🎉
**We received the exciting news that our submission is one of the winners! We won in the 'Best in Integrations' category.**
🎉

This blog outlines our submission, and even better, there’s a public GitHub repository with the solution, allowing everyone to take advantage of it!

## Submission video
The video as part of the submission:
<video src="https://github.com/Dutchy365/AI-Driven-Archiving/raw/refs/heads/main/assets/AIDrivenArchiving-HackTogether2025.mp4"></video>


## Project AI driven archiving of SharePoint Sites
This project addresses the challenges faced by SharePoint administrators and archivists in managing the complete lifecycle of SharePoint sites. In many organizations, SharePoint sites often exist without clear ownership, leaving archivists to evaluate whether they should be archived and under what retention policies. This process can be time-consuming, particularly when managing a large number of sites.

The goal of this project is to streamline the archiving process and provide support to archivists, making SharePoint site management more efficient and mature. A Power App has been developed to offer a comprehensive overview of SharePoint sites, providing key data such as last modification dates and usage statistics.

The solution incorporates AI-powered assessments to generate summaries of the sites and detect sentiment, helping archivists make informed decisions about archiving. Additionally, a SharePoint agent is provisioned on demand, enabling users to engage in conversations about the site. This tool also allows archivists to confidently set archiving statuses or seek a second opinion from colleagues.

Overall, the project simplifies and accelerates the archiving process, ensuring proper lifecycle management of SharePoint sites with the help of AI technology.

### AI-power of the solution

AI is at the core of this solution, enabling functionality that would otherwise be impossible. The AI-powered components are integral to different parts of the process:

* Creating the summary: AI is used to automatically generate summaries of SharePoint sites. Currently, this process is handled through Azure Blob storage and AI search, with plans to incorporate AI Foundry to directly analyze files stored within SharePoint once it's available ([as outlined in the roadmap](https://www.microsoft.com/en-us/microsoft-365/roadmap?id=476496)).
* Sentiment Analysis: The solution leverages the prebuilt Dataverse AI functions to analyze the sentiment of each SharePoint site’s summary, helping archivists gauge the overall tone and context of the content. [AISummarize, AISentiment, AIReply, AITranslate, AIClassify, and AIExtract functions](https://learn.microsoft.com/en-us/power-platform/power-fx/reference/function-ai).
* User Interaction via SharePoint Agent: To enhance user engagement, an AI-driven SharePoint agent is provisioned automatically when a user wants to ask specific questions about a site. This agent allows users to interact with the site’s data in real time, providing on-demand support for queries related to the archiving process.

Without AI, this solution would not be feasible. It’s the AI technology that makes it possible to efficiently summarize vast amounts of SharePoint site data and assess sentiment, drastically improving the decision-making process for archivists and administrators.


## Screenshot
The app starts with an overview of the SharePoint sites:

![Overview screen](/images/20250324PowerfulDevHackathon/overviewscreen.png)

The detail screen per project, contains some details of the project and the AI assessment takes place. 
![Detail screen](/images/20250324PowerfulDevHackathon/detailscreen.png)

A demo of the app in video format:

<video width="500" height="500" controls>
  <source src="/images/20250324PowerfulDevHackathon/DemoAIArchiving.mp4" type="video/mp4">
</video>




## Resources
You can find the solution on [Github](https://github.com/Dutchy365/AI-Driven-Archiving).

A detailed part of the solution is the provisioning of SharePoint Agents, which is explained in my [previous blog](/blog/20250303-provisionsharepointagent).