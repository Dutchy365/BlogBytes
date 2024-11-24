---
author: ""
title: "Power Pages: visual message indicator"
date: 2024-11-24
description: Indicator of the number of message for the current contact
tags:
  - Power Pages
  - svg
  - Liquid
  - FetchXML
thumbnail: /images/20241124PowerPagesMessageIndicator/00MessageIndicator.png
preview: /00MessageIndicator.png
images: 
- /00MessageIndicator.png
---



## End result
The end result is an envelop icon in which a counter displays the number of messages for the current logged in contact.


![content snippet](/images/20241124PowerPagesMessageIndicator/01-endresult.png)



### Datamodel
Simplified view of the datamodel, just to support the understanding of the technical setup.

![content snippet](/images/20241124PowerPagesMessageIndicator/02-datamodel.png)



## Content snippet
To accomplish this, start by creating an HTML content snippet. This snippet will serve as the foundation for counting the number of messages and displaying the envelop icon.

![content snippet](/images/20241124PowerPagesMessageIndicator/03-contentsnippet.png)

In this scenario the name of the snippet is: Message Counter.



```html
<!-- Count Messages for current logged in user --> 
{% fetchxml querymessages %}
<fetch version="1.0" mapping="logical" aggregate="true">
    <entity name="cr4c5_message">

    <attribute name="cr4c5_messageid" aggregate="count" alias="messagescount"/>
    <filter>
        <condition attribute="cr4c5_to" operator="eq" value="{{user.id}}" />
    </filter>

</entity>
</fetch>
{% endfetchxml %}

{% for result in querymessages.results.entities %}
    {% assign messagescount = result.messagescount %}
{% endfor %}

<!--The envelop icon in svg format as a link to details page --> 
<a href="~/Messages">
   
<svg height="40px" width="40px" version="1.1" id="_x32_" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" 
	 viewBox="0 0 512 512"  xml:space="preserve">
<style type="text/css">
	.st0{fill:#fff;}
    .st1{fill:#ff0000;
</style>
<g>
	<path class="st0" d="M395.914,280.909v110.243L293.305,290.163l42.018-35.667c-9.729-7.633-18.24-16.686-25.196-26.818
		l-87.074,73.902c-1.69,1.418-4.19,2.228-6.891,2.228c-2.635,0-5.135-0.81-6.822-2.228L49.785,166.209h237.846
		c-0.338-3.783-0.541-7.635-0.541-11.553c0-8.308,0.812-16.414,2.297-24.318H0v324.244h432.324v-173.47
		c-5.742,0.81-11.617,1.216-17.563,1.216C408.344,282.328,402.062,281.855,395.914,280.909z M36.41,203.091l43.908,37.288
		l58.701,49.784L36.41,391.152V203.091z M62.891,418.712L168.27,314.955l13.779,11.686c9.188,7.836,21.279,12.092,34.113,12.092
		c12.834,0,24.994-4.256,34.113-12.024l13.782-11.754l105.377,103.757H62.891z"/>

	<path class="st1" d="M414.744,57.418c-53.713,0-97.256,43.543-97.256,97.256s43.543,97.256,97.256,97.256
		c53.717,0,97.256-43.543,97.256-97.256S468.461,57.418,414.744,57.418z 29.078-25.261h26.068V211.504z"/>
</g>
<g>
     <text x="370" y="200" style="fill: #ffffff;font-size:130px;font-weight:bold;">{{messagescount}}</text>
</g>
</svg>

</a>
```



### Add content snippet to the header
Go to Web Templates and select Header. Add html to the source code:

![page snippet](/images/20241124PowerPagesMessageIndicator/04-webtemplate.png)

This is the html, which is only displayed if the user is logged in:

```html
{%if user %}
<li class="divider-vertical" aria-hidden="true"></li>
    <li >  {% editable snippets 'MessagesCounter' type: 'html' %}</li>
{% endif %}
```


Just sync and test! The envelop will be displayed and the user is informed about the number of messages!

## Tips
* Use [FetchXml Test](https://www.xrmtoolbox.com/plugins/MscrmTools.FetchXmlTester/) in the XrmToolBox to test your FetchXml queries. 
