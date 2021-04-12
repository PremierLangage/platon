---
name: Component request
about: Propose a new web component.
title: "[WEBCOMPONENT] "
labels: WebComponent
assignees: ''

---
**Selector**
Html tag for the web component.

Example:

wc-input-box

**Goal**
A clear and concise description of what you want to happen.

Example:
Inputs provides a way for users to enter a data.

***Features***:

- support multiline
- support numeric (force value to be a int or float in python context)
- support math expressions
- support autosubmit on press enter
- support autocompletion
- prefix and suffix icons

**Properties (excluding the default properties cid, selector, debug...)**

A list of important properties exposed by component. This list can be completed by the developer team
if needed.

Example:

| property | description |
|----------|------------|
| `value: string \| number` | content of the inputbox  |
| `disabled: boolean` | disable user interaction  |

If you want a the **filter** markdown, latex applyed to the variable indicate it in the desciption.  

**Controller**
An optional python class attached to the component instance.

**Dependencies**
Optional list of javascript or python (for grader) libraries used by the component.

**Example**
Optional link to an exercise that reproduce the behavior of the component.

**Additional Info**
Add any other context, schemas or screenshots about the component request here.
