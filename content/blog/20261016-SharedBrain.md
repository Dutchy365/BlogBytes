---
author: ""
title: "Building a Shared Second Brain with AI"
date: 2026-10-16
description: "Stop searching. Start remembering."
tags:
  - Power Platform
  - Shared brain
  - Second brain
thumbnail: /images/20261016SharedBrain/00SharedBrain.png
preview: /00SharedBrain.png
images: 
- /00SharedBrain.png
---
# Building a Shared Second Brain with AI

*From scattered project knowledge to a living knowledge base maintained by humans and AI agents.*

Every project starts with good intentions. A Teams channel. A SharePoint site. A repository. Maybe even an agreed documentation structure. And for a while, everything works.

Until someone asks:

**"Why did we decide to build it this way?"**

Someone remembers a Teams discussion. Another points to an architecture document. A developer remembers a pull request. Twenty minutes later, we're still searching.

The information probably exists somewhere. The knowledge? That's a different story.

## We don't have a documentation problem. We have a knowledge problem.

Every architecture discussion, bug fix, meeting and pull request adds to our collective understanding. But we rarely capture it in a way that survives the moment. Conversations disappear into threads, documents become outdated and decisions hide in Git history.

Of course, we can connect an AI chatbot to these sources using Retrieval-Augmented Generation (RAG). That's useful. But **finding information is not the same as maintaining knowledge.** A chatbot can tell us what was written. It doesn't ensure that it's still correct, that conflicts are resolved or that related knowledge is connected. And tomorrow, the same reasoning happens all over again.

What if we could preserve it?

## From a Second Brain to a Shared Brain

In *Building a Second Brain*, Tiago Forte describes a system for capturing, organizing, distilling and expressing information, so our brains can spend less time remembering and more time thinking.

Now apply that to an entire project team. Not another folder or wiki that slowly becomes outdated, but a knowledge base that continuously captures and connects what a team learns. A decision made in a meeting becomes an architecture decision record. A pull request links to the design behind it. And a new developer doesn't just learn how the solution works, but **why it works that way**.

## What if AI became the librarian?

Most AI assistants behave like search engines with conversational skills. A librarian does more: organizing information, connecting subjects and maintaining the catalog. That's the role I'd like AI to play. Imagine an agent that identifies decisions in meeting notes, proposes documentation updates, connects concepts to source code and flags contradictions or outdated information.

Notice the word *propose*. I don't think AI should independently decide what is true.

**AI maintains the library. Humans remain responsible for the truth.**

## Karpathy's LLM Wiki: knowledge that compounds

In April 2026, Andrej Karpathy shared the concept of an LLM-maintained wiki: interconnected Markdown files that an AI agent incrementally creates and maintains. Instead of repeatedly interpreting a pile of documents, it adds a persistent knowledge layer, built from three parts:

1. **Raw sources** – the original documents, notes and code, kept intact so knowledge can always be traced back.
2. **The wiki** – synthesized, interconnected pages maintained by the agent.
3. **The schema** – instructions on how the knowledge base is organized and how conflicts are handled.

This doesn't make RAG obsolete. But each new source now improves existing knowledge instead of becoming another document to search through. **Knowledge that accumulates over time.**

## Why Markdown?

Not because Markdown is somehow more intelligent. Because it's simple. Humans can read it, developers can version it and AI agents can update it. An architecture decision could look like this:

```markdown
# ADR-012: Use Azure Functions for processing

Status: Accepted
Date: 2026-10-12
Owner: Architecture team

## Decision
Use Azure Functions for background processing.

## Related
- [[Integration Architecture]]
- [[Processing Service]]
```

Nothing spectacular. And that's precisely the point.

Combined with Git, it also gives us a governance model: an agent proposes changes through a pull request, a human reviews them before they become trusted knowledge. The same workflow we use for code. Business users may still prefer SharePoint, but as an underlying format Markdown offers a nice balance between simplicity and control.

## Microsoft is moving in the same direction

In October 2026, Microsoft introduced a team knowledge base for SharePoint, curated by Copilot and agents. The approach is remarkably similar: interconnected, agent-friendly Markdown files, compiled by Work IQ from messages, meetings and files. In Microsoft's internal testing, agents answered up to four times faster using 30% fewer tokens. Promising, though not independent benchmarks, and the feature is still in Frontier preview.

So, **should we build our own Shared Second Brain, or let Microsoft build it for us?**

As usual: it depends. For organizations living in Microsoft 365, Work IQ brings knowledge management into the tools people already use. For development teams, technical knowledge lives close to the code, and a Git-based wiki fits the development lifecycle better. Perhaps the most interesting answer is combining both: business context from Microsoft 365, technical knowledge from the repository.

The technology should follow the problem.

## Connecting documentation to code

Imagine a developer changes the authentication mechanism. The code is updated, the architecture documentation isn't. Someone needs to remember to fix that. Sometimes they do. Sometimes they don't.

With an AI-maintained knowledge base, that change could trigger an agent to find the affected architecture page, compare it with the new implementation and propose an update for review. Not to document every line of code, but to preserve the knowledge behind important changes.

Because code shows *what* a system does. It doesn't always explain *why*.

## A practical blueprint

I wouldn't start by connecting every Teams channel, SharePoint site and repository to an agent. That sounds impressive, but also like an excellent way to create an expensive mess. Start small:

1. **Identify valuable knowledge** – decisions, requirements, concepts and lessons learned in one project.
2. **Define your sources of truth** – Teams for conversations, SharePoint for business documents, Git for code.
3. **Create a simple structure** – a few categories, Markdown where it adds value.
4. **Let AI propose changes** – with every important claim traceable to a source.
5. **Introduce human review** – assign clear ownership of what becomes trusted knowledge.
6. **Maintain, don't just capture** – otherwise it's just another place where information goes to become obsolete.

## The difficult part isn't AI

The biggest challenge probably isn't technical. It's organizational. A Shared Second Brain only works when teams agree on what knowledge matters, who owns it and how it's validated. AI can do the repetitive work. It cannot replace accountability.

That's why it needs both consultants, who understand how decisions are made and why knowledge gets lost, and developers, who know how to connect systems and automate the workflow.

**Stop searching for the same answers. Start building on what your team already knows.**

## Further reading

- [Microsoft: Introducing a team knowledge base, curated by Copilot and agents](https://techcommunity.microsoft.com/blog/spblog/introducing-a-team-knowledge-base-curated-by-copilot-and-agents/4564203)
- [Andrej Karpathy's LLM Wiki concept](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)
- [Building a Second Brain — Tiago Forte](https://www.buildingasecondbrain.com/)
