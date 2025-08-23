---
author: ""
title: "Manipulate JSON objects or arrays: using setProperty/addProperty"
date: 2025-08-23
description: Use of setProperty and addProperty expression in Power Automate
tags:
  - Power Automate
  - JSON
  - addProperty
  - setProperty
thumbnail: /images/20250823JSONManipulation/00JsonSetAddProperty.png
preview: /00JsonSetAddProperty.png
images: 
- /00JsonSetAddProperty.png
---


In Power Automate, working with JSON objects and arrays is essential for building **advanced, scalable, and maintainable flows**. JSON acts as the backbone of data exchange, allowing you to represent structured information flexibly.

Two powerful expressions—**`setProperty()`** and **`addProperty()`**—unlock the ability to **dynamically update, expand, and manipulate JSON objects**.  

This article explores what these functions do, why they matter, and how you can apply them in real-world automation scenarios.

## Why Manipulate JSON in Power Automate?
Before diving into the syntax, let’s answer the bigger question: *why bother manipulating JSON at all?*

- **Dynamic Data**: APIs, forms, and connectors typically return JSON. Mastering it means fewer conversion headaches.  
- **Reduced Complexity**: One JSON object can replace dozens of separate variables.  
- **Flexibility**: Modify or extend data structures without reworking the entire flow.  
- **Performance**: Each variable initialization is an API call. Consolidating data into JSON cuts down the calls, improving speed and efficiency.  
- **API Call Optimization**: Fewer variable initialization actions mean fewer API calls and better performance.  

💡 For example: if you start a flow with multiple input parameters and create a separate variable for each one, every initialization counts as an API call. Instead, you can group them all into a single object add a Parse JSON to define schema and manage them with `setProperty()` or `addProperty()`. 



## Understanding setProperty() and addProperty()

### 1. setProperty()
The `setProperty()` expression updates an existing property.

**Syntax:**
`setProperty(<object>, <propertyName>, <value>)`

- **`<object>`** – The original JSON object
- **`<propertyName>`** – The property to set or update
- **`<value>`** – The new value

**When to use**:  
- Overwriting existing values (e.g., updating an email address)
- Adding new properties in a controlled way


### 2. addProperty()
The addProperty() expression adds a new property to a JSON object without overwriting existing ones. If the property already exists, the function fails (unlike setProperty()).

**Syntax:**
`addProperty(<object>, <propertyName>, <value>)`

**When to use**:  
- When you need to append new properties without the risk of overwriting
- Useful for incremental building of objects in complex flows


## Example

Example of a JSON object.

![JSON object](/images/20250823JSONManipulation/1-object.png)


Example of a JSON object including data.
![JSON object including data](/images/20250823JSONManipulation/2-objectdata.png)


Consider the following customer interaction data:

```json
// Sample customer interaction data
{
  "customerId": "12345",
  "name": "John Doe",
  "email": "john@example.com",
  "purchase": {
    "product": "Smartphone",
    "price": 799.99,
    "date": "2024-03-17"
  }
}

```
Updating a property with setProperty()

Scenario: The customer updates their email address. You can use the following expression in a Compose action:
`setProperty(variables('CustomerProfile'), 'email', variables('CustomerData')?['email'])`
![JSON setProperty](/images/20250823JSONManipulation/3-setProperty.png)

Output displays the updated email value:

![JSON updated property](/images/20250823JSONManipulation/4-updatedProperty.png)

Result:
The email property is updated while everything else remains untouched.

### Adding a nested element with addProperty()
Scenario: You want to add a product field under purchase. Which will make it easier for use to refer in later actions.
`addProperty(variables('CustomerProfile'),'purchase',variables('CustomerData')?['purchase']?['product'])`

![JSON add property](/images/20250823JSONManipulation/5a-addProperty.png)

Output displays the product value:
![JSON add property](/images/20250823JSONManipulation/5b-addProperty.png)



## Working with Parse JSON Action

While manipulating JSON objects is powerful, you’ll often need to access properties individually in other steps. This is where Parse JSON comes in:

* Input: Provide your raw JSON
* Schema: Auto-generate or define it manually
* Benefit: Use dynamic content directly without extra variables

⚠️ Important:
If you add or remove properties, you must update the schema in the Parse JSON action to prevent runtime errors.




## Conclusion
By mastering setProperty() and addProperty(), you can build flows that are:

* Dynamic – adapting to changing data
* Efficient – fewer API calls and variables
* Maintainable – cleaner, scalable structures

Instead of managing endless variables, think in JSON. With these two expressions, your flows become more robust, future-proof, and easier to maintain.